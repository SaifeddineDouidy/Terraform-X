module "variables" {
  source      = "../../modules/variables"
  environment = var.environment
  size        = var.size
}

module "network" {
  source               = "../../modules/network"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  vpc_id               = var.vpc_id
  name_prefix          = local.environment_mapped

}

module "consul_server" {
  source                     = "../../modules/compute"
  vpc_id                     = module.network.vpc_id
  subnet_ids                 = module.network.private_subnet_ids
  instance_type              = "t2.micro" # Or a suitable instance type for Consul
  ami_id                     = data.aws_ami.ubuntu.id
  name_prefix                = "${local.environment_mapped}-consul"
  allowed_ssh_cidr           = var.allowed_ssh_cidr
  instance_profile_role_name = module.iam.consul_ec2_role_name
  security_group_ids         = [module.network.consul_sg_id]
  user_data                  = <<-EOT
              #!/bin/bash
              # Install Consul
              # (Add your Consul installation and configuration script here)
              echo "Consul installation script placeholder" > /tmp/consul_install.log
              EOT
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
        ENV     = local.environment_mapped
        DB_HOST = module.rds.db_endpoint
        DB_PORT = module.rds.db_instance_port
        DB_NAME = "${svc_name}_db"
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
  db_password               = var.db_password
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
    for svc_name in ["keycloak", "nextjs", "spring-gateway"] : svc_name => {
      port = var.ecs_services[svc_name].port
    }
  }
  tags = local.common_tags
}

module "api_gateway" {
  source = "../../modules/api_gateway"
  name   = "${local.environment_mapped}-${var.project}-api"

  routes = {
    for svc_name in keys(var.ecs_services) : svc_name => {
      path       = "/${svc_name}"
      target_url = contains(["keycloak", "nextjs", "spring-gateway"], svc_name) ? "http://${module.alb.alb_dns_name}/${svc_name}" : "http://${module.alb.alb_dns_name}/spring-gateway/${svc_name}"
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
}

resource "aws_secretsmanager_secret_version" "rds_password" {
  secret_id     = aws_secretsmanager_secret.rds_password.id
  secret_string = var.db_password
}

resource "aws_secretsmanager_secret" "docdb_password" {
  name = "${local.environment_mapped}/docdb/password"
  tags = local.common_tags
}

resource "aws_secretsmanager_secret_version" "docdb_password" {
  secret_id     = aws_secretsmanager_secret.docdb_password.id
  secret_string = var.docdb_master_password
}

module "waf" {
  source      = "../../modules/waf"
  name_prefix = local.environment_mapped
  tags        = local.common_tags
}

resource "aws_wafv2_web_acl_association" "this" {
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

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}
provider "postgresql" {
  host            = module.rds.db_endpoint
  port            = module.rds.db_instance_port
  database        = "postgres"
  username        = var.db_username
  password        = var.db_password
  sslmode         = "require"
  connect_timeout = 15
}

resource "postgresql_database" "app_databases" {
  for_each = toset(var.db_names)
  name     = each.value
  owner    = var.db_username
}