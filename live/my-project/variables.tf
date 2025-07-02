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
  type = string
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
  default = ["0.0.0.0/0"] # Change this to a more restrictive CIDR in production
}

variable "workspace_to_environment_tag_map" {
  type = map(string)
  default = {
    "dev"     = "Dev"
    "uat"     = "Uat"
    "preprod" = "Preprod"
    "prod"    = "Prod"
  }
}

variable "environment_to_size_map" {
  type = map(string)
  default = {
    "Dev"   = "small"
    "Uat" = "small"
    "Prod"  = "large"
    "Preprod" = "large"
  }
}

variable "workspace_to_size_map" {
  type = map(string)
  default = { develop = "small" }
}

variable "aws_region" {
  type        = string
  description = "AWS region"
  default = "us-east-1"
}

variable "vpc_cidr" {}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "sonarqube_ami_id" {
  type        = string
  description = "AMI ID for SonarQube instance"
}

variable "clickhouse_ami_id" {
  type        = string
  description = "AMI ID for ClickHouse instance"
}

variable "ecr_repository_names" {
  type        = list(string)
  default     = ["my-app-repo"]
  description = "List of ECR repository names"
}
variable "lifecycle_policy" {
  description = "JSON string for the ECR lifecycle policy"
  type        = string
  default     = null
}