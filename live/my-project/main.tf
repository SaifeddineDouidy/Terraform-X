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

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}