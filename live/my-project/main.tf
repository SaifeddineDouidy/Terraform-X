# module "variables" {
#   source      = "../../modules/variables"
#   environment = var.environment
#   size        = var.size
# }

module "network" {
  source               = "../../modules/network"
  vpc_cidr                      = var.vpc_cidr
  public_subnet_cidrs           = var.public_subnet_cidrs
  private_subnet_cidrs          = var.private_subnet_cidrs
  keycloak_public_subnet_cidrs  = var.keycloak_public_subnet_cidrs
  keycloak_private_subnet_cidrs = var.keycloak_private_subnet_cidrs
  name_prefix                   = local.environment_mapped
  single_nat_gateway   = true
}


data "local_file" "ecr_policies" {
  for_each = var.ecs_services
  filename = "${path.root}/${each.value.lifecycle_policy_path}"
}

module "ecr" {
  source = "../../modules/ecr"

  repositories = {
    for svc in var.ecs_services : svc.name => {
      lifecycle_policy_path    = svc.lifecycle_policy_path
      lifecycle_policy_content = data.local_file.ecr_policies[svc.name].content
    }
  }

  tags = local.common_tags
}

module "ecs" {
  source             = "../../modules/ecs_fargate"
  vpc_id             = module.network.vpc_id
  security_group_ids = [module.network.ecs_sg_id]
  cluster_name       = "${local.environment_mapped}-${var.project}-cluster"
  subnet_ids         = module.network.private_subnet_ids
  aws_region         = var.aws_region

  services = { for svc_name, svc_config in var.ecs_services :
    svc_name => {
      cpu       = svc_config.cpu
      memory    = svc_config.memory
      desired   = svc_config.desired_count
      port      = svc_config.port
      image_url = module.ecr.repository_urls[svc_name]

      env = {
        ENV         = local.environment_mapped
        DB_HOST     = module.rds.db_endpoint
        DB_PORT     = module.rds.db_instance_port
        DB_NAME     = "${svc_name}_db"
        CONSUL_HOST = "consul.${local.environment_mapped}-${var.project}-cluster.local"
        CONSUL_PORT = "8500"
      }
      secrets = {
        DB_PASSWORD = aws_secretsmanager_secret.rds_password.arn
      }
    }
  }

  execution_role_arn = module.iam.ecs_execution_role_arn
  task_role_arn      = module.iam.ecs_task_role_arn

  tags         = local.common_tags
  xray_enabled = true
}

module "xray" {
  source      = "../../modules/xray"
  name_prefix = local.environment_mapped
  tags        = local.common_tags
}

module "rds" {
  source                    = "../../modules/rds"
  name_prefix               = local.environment_mapped
  vpc_id                    = module.network.vpc_id
  subnet_ids                = module.network.private_subnet_ids
  security_group_ids        = [module.network.rds_sg_id]
  db_names                  = var.db_names
  db_username               = var.db_username
  db_password               = random_password.rds_password.result
  multi_az_enabled          = var.rds_multi_az_enabled
  tags                      = local.common_tags
  rds_backup_s3_bucket_name = var.rds_backup_s3_bucket_name
}

# module "documentdb" {
#   source             = "../../modules/documentdb"
#   name_prefix        = local.environment_mapped
#   vpc_id             = module.network.vpc_id
#   subnet_ids         = module.network.private_subnet_ids
#   security_group_ids = [module.network.docdb_sg_id]
#   master_username    = var.docdb_master_username
#   master_password    = var.docdb_master_password
#   tags               = local.common_tags
# }

module "alb" {
  source            = "../../modules/alb"
  name_prefix       = local.environment_mapped
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  security_group_id = module.network.alb_sg_id
  certificate_arn   = length(aws_acm_certificate.this) > 0 ? aws_acm_certificate.this[0].arn : ""
  enable_https      = var.domain_name != ""
  services = {
    "spring-gateway" = {
      port = var.ecs_services["spring-gateway"].port
      path = "/*"
    }
  }
  tags = local.common_tags
}

resource "aws_acm_certificate" "this" {
  count             = var.domain_name == "" ? 0 : 1
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = local.common_tags
}

resource "aws_secretsmanager_secret" "rds_password" {
  name = "${local.environment_mapped}/rds/password"
  tags = local.common_tags

  recovery_window_in_days = 0 # Set to 0 to allow immediate deletion for dev environments
}

resource "aws_secretsmanager_secret_version" "rds_password" {
  secret_id     = aws_secretsmanager_secret.rds_password.id
  secret_string = random_password.rds_password.result
}

resource "random_password" "rds_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "aws_secretsmanager_secret_rotation" "rds_password_rotation" {
  secret_id           = aws_secretsmanager_secret.rds_password.id
  rotation_lambda_arn = "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:aws-secretsmanager-rds-secret-rotation-lambda" # Placeholder ARN, needs to be updated with the actual ARN of the rotation lambda

  rotation_rules {
    automatically_after_days = 30
  }
}

resource "aws_secretsmanager_secret" "keycloak_db_password" {
  name = "${local.environment_mapped}/keycloak/db/password"
  tags = local.common_tags

  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "keycloak_db_password" {
  secret_id     = aws_secretsmanager_secret.keycloak_db_password.id
  secret_string = random_password.keycloak_db_password.result
}

resource "random_password" "keycloak_db_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "aws_secretsmanager_secret_rotation" "keycloak_db_password_rotation" {
  secret_id           = aws_secretsmanager_secret.keycloak_db_password.id
  rotation_lambda_arn = "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:aws-secretsmanager-rds-secret-rotation-lambda" # Placeholder ARN

  rotation_rules {
    automatically_after_days = 30
  }
}

data "aws_caller_identity" "current" {}

module "waf" {
  source      = "../../modules/waf"
  name_prefix = local.environment_mapped
  tags        = local.common_tags
}

resource "aws_wafv2_web_acl_association" "this" {
  count        = var.enable_waf ? 1 : 0
  resource_arn = module.alb.alb_arn
  web_acl_arn  = module.waf.web_acl_arn
}

# module "sonarqube" {
#   source        = "../../modules/sonarqube"
#   ami_id        = var.sonarqube_ami_id
#   instance_type = "t4g.small"
#   subnet_id     = module.network.public_subnet_ids[0]
#   vpc_id        = module.network.vpc_id
#   name_prefix   = local.environment_mapped
#   common_tags   = local.common_tags
# }

# module "clickhouse" {
#   source        = "../../modules/clickhouse"
#   ami_id        = var.clickhouse_ami_id
#   vpc_id        = module.network.vpc_id
#   instance_type = "t4g.small"
#   subnet_id     = module.network.public_subnet_ids[0]
#   name_prefix   = local.environment_mapped
#   common_tags   = local.common_tags
# }

module "iam" {
  source                    = "../../modules/iam"
  name_prefix               = local.environment_mapped
  tags                      = local.common_tags
  rds_backup_s3_bucket_name = var.rds_backup_s3_bucket_name
}

# data "aws_ami" "ubuntu" {
#   most_recent = true
#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }
#   owners = ["099720109477"] # Canonical
# }

provider "postgresql" {
  host            = module.rds.db_endpoint
  port            = module.rds.db_instance_port
  database        = "postgres"
  username        = var.db_username
  password        = random_password.rds_password.result
  sslmode         = "require"
  connect_timeout = 15
}

resource "postgresql_database" "app_databases" {
  for_each = toset(var.db_names)
  name     = each.value
  owner    = var.db_username
}
module "route53_keycloak" {
  source       = "../../modules/route53"
  domain_name  = var.domain_name
  subdomain    = "keycloak.${var.domain_name}"
  alb_dns_name = module.keycloak.keycloak_alb_dns_name
  alb_zone_id  = module.keycloak.keycloak_alb_zone_id
}

module "route53_main_app" {
  source       = "../../modules/route53"
  domain_name  = var.domain_name
  subdomain    = "dev.${var.domain_name}"
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}

module "keycloak" {
  source                 = "../../modules/keycloak"
  name_prefix            = "${local.environment_mapped}-keycloak"
  vpc_id                 = module.network.vpc_id
  public_subnet_ids      = module.network.keycloak_public_subnet_ids
  private_subnet_ids     = module.network.keycloak_private_subnet_ids
  tags                   = local.common_tags
  keycloak_port          = 8080 # Keycloak's default HTTP port
  certificate_arn        = aws_acm_certificate.this[0].arn
  keycloak_cpu           = 1024
  keycloak_memory        = 2048
  desired_count          = 2
  ecs_execution_role_arn = module.iam.ecs_execution_role_arn
  ecs_task_role_arn      = module.iam.ecs_task_role_arn
  aws_region             = var.aws_region
  domain_name            = var.domain_name
  db_username            = var.keycloak_db_username
  db_password_secret_arn = aws_secretsmanager_secret.keycloak_db_password.arn
  db_instance_class      = var.keycloak_db_instance_class
  db_allocated_storage   = var.keycloak_db_allocated_storage
  db_engine              = var.keycloak_db_engine
  db_engine_version      = var.keycloak_db_engine_version
  db_multi_az_enabled    = var.keycloak_db_multi_az_enabled
}

# data "aws_ami" "amazon_linux_2" {
#   most_recent = true
#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm-*-x86_64-gp2"]
#   }
#   owners = ["amazon"]
# }