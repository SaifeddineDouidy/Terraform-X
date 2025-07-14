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

module "compute" {
  source        = "../../modules/compute"
  vpc_id        = module.network.vpc_id
  subnet_ids    = module.network.public_subnet_ids
  instance_type = module.variables.instance_type
  ami_id        = data.aws_ami.ubuntu.id
  name_prefix   = local.environment_mapped

}

module "kubernetes" {
  source        = "../../modules/kubernetes"
  subnet_ids    = module.network.public_subnet_ids
  instance_type = module.variables.instance_type
  node_count    = module.variables.node_count
  name_prefix   = local.environment_mapped

}

module "database" {
  source         = "../../modules/database"
  read_capacity  = module.variables.dynamodb_read_capacity
  write_capacity = module.variables.dynamodb_write_capacity
  name_prefix    = local.environment_mapped

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

  services = { for svc in var.ecs_services :
    svc.name => {
      cpu       = svc.cpu
      memory    = svc.memory
      desired   = svc.desired_count
      port      = svc.port
      image_url = module.ecr.repository_urls[svc.name]

      env = { ENV = local.environment_mapped }
    }
  }

  execution_role_arn = module.iam.ecs_execution_role_arn
  task_role_arn      = module.iam.ecs_task_role_arn

  tags = local.common_tags
}

module "alb" {
  source            = "../../modules/alb"
  name_prefix       = local.environment_mapped
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  security_group_id = module.network.alb_sg_id
  services = {
    for svc in var.ecs_services : svc.name => {
      port = svc.port
    }
  }
  tags = local.common_tags
}

module "api_gateway" {
  source = "../../modules/api_gateway"
  name   = "${local.environment_mapped}-${var.project}-api"

  routes = {
    for svc in var.ecs_services : svc.name => {
      path       = "/${svc.name}"
      target_url = "http://${module.alb.alb_dns_name}/${svc.name}"
    }
  }

  tags = local.common_tags
}

module "sonarqube" {
  source        = "../../modules/sonarqube"
  ami_id        = var.sonarqube_ami_id
  instance_type = "t4g.small"
  subnet_id     = module.network.public_subnet_ids[0]
  vpc_id        = module.network.vpc_id
  name_prefix   = local.environment_mapped
  common_tags   = local.common_tags
}

module "clickhouse" {
  source        = "../../modules/clickhouse"
  ami_id        = var.clickhouse_ami_id
  vpc_id        = module.network.vpc_id
  instance_type = "t4g.small"
  subnet_id     = module.network.public_subnet_ids[0]
  name_prefix   = local.environment_mapped
  common_tags   = local.common_tags
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}


module "iam" {
  source      = "../../modules/iam"
  name_prefix = local.environment_mapped
  tags        = local.common_tags
}
