module "variables" {
  source      = "../../modules/variables"
  environment = var.environment
  size        = var.size
}

module "network" {
  source               = "../../modules/network"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  name_prefix          = local.environment_mapped

}

module "compute" {
  source               = "../../modules/compute"
  vpc_id               = module.network.vpc_id
  subnet_ids           = module.network.public_subnet_ids
  instance_type        = module.variables.instance_type
  ami_id               = data.aws_ami.ubuntu.id
  name_prefix          = local.environment_mapped

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

module "ecr" {
  source           = "../../modules/ecr"
  repository_names = var.ecr_repository_names
  lifecycle_policy = var.lifecycle_policy
}
module "sonarqube" {
  count         = local.environment_mapped == "Dev" ? 1 : 0
  source        = "../../modules/sonarqube"
  ami_id        = var.sonarqube_ami_id
  instance_type = "t4g.small"
  subnet_id     = module.network.public_subnet_ids[0]
  vpc_id        = module.network.vpc_id
  name_prefix   = local.environment_mapped
  common_tags   = local.common_tags
}

module "clickhouse" {
  count         = local.environment_mapped == "Dev" ? 1 : 0
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