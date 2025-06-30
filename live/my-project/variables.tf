variable "project" {
  description = "Project name for tagging"
  type = string
}
variable "ssh_key_name" {
  description = "Key pair name for SSH (for EC2 instances)"
  type = string
}
variable "allowed_ssh_cidr" {
  description = "List of CIDRs allowed to SSH into instances (set narrowly for prod)"
  type = list(string)
  default = ["0.0.0.0/0"]
}

variable "workspace_to_environment_map" {
  type = map(string)
  default = {
    develop = "develop"
    uat     = "uat"
    preprod = "preprod"
    prod    = "prod"
  }
}

variable "environment_to_size_map" {
  type = map(string)
  default = {
    develop = "small"
    uat     = "small"
    preprod = "medium"
    prod    = "large"
  }
}

variable "workspace_to_size_map" {
  type = map(string)
  default = { develop = "small" }
}

variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidr" {}

variable "public_subnet_cidrs" {
  type = list(string)
}