variable "project" {
  description = "Project name for tagging"
  type = string
}

variable "service" {
  description = "Service name for tagging"
  type = string
}
variable "environment" {
  description = "The deployment environment (e.g., develop, uat, preprod, prod)."
}


variable "size" {
  description = "The infrastructure size (e.g., small, medium, large)."
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

variable "workspace_to_environment_tag_map" {
  type = map(string)
  default = {
    dev     = "Dev"
    develop = "Dev"
    live    = "Prod"
    prod    = "Prod"
    uat     = "Stage"
    staging = "Stage"
  }
}

variable "environment_to_size_map" {
  type = map(string)
  default = {
    "Dev"   = "small"
    "Stage" = "medium"
    "Prod"  = "large"
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