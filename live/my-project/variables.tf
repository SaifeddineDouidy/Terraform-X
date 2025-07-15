variable "project" {
  description = "Project name for tagging"
  type        = string
}

variable "service" {
  description = "Service name for tagging"
  type        = string
}
variable "environment" {
  description = "The deployment environment (e.g., develop, uat, preprod, prod)."
  type        = string
}

variable "size" {
  description = "The infrastructure size (e.g., small, medium, large)."
  type        = string
}

variable "ssh_key_name" {
  description = "Key pair name for SSH (for EC2 instances)"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "List of CIDRs allowed to SSH into instances (set narrowly for prod)"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Change this to a more restrictive CIDR in production
}

variable "workspace_to_environment_tag_map" {
  type = map(string)
  default = {
    "dev"     = "Dev"
    "uat"     = "Dev"
    "preprod" = "Stage"
    "prod"    = "Prod"
  }
}

variable "environment_to_size_map" {
  type = map(string)
  default = {
    "Dev"     = "small"
    "Uat"     = "small"
    "Prod"    = "large"
    "Preprod" = "large"
  }
}

variable "workspace_to_size_map" {
  type    = map(string)
  default = { develop = "small" }
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where resources will be created"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_cidr" {}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
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

variable "ecs_services" {
  type = map(object({
    name                  = string
    cpu                   = number
    memory                = number
    desired_count         = number
    port                  = number
    lifecycle_policy_path = string
    secrets               = map(string)
  }))
}
variable "alb_dns_name" {
  type        = string
  description = "DNS name of the ALB to attach to"
}

variable "db_name" {
  description = "The name of the database to create in the RDS instance."
  type        = string
}

variable "db_username" {
  description = "The master username for the RDS database."
  type        = string
}

variable "db_password" {
  description = "The master password for the RDS database."
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "The domain name for the application."
  type        = string
  default     = ""
}

variable "rds_multi_az_enabled" {
  description = "Whether to enable Multi-AZ deployment for the RDS instance in this environment."
  type        = bool
  default     = false
}

variable "docdb_master_username" {
  description = "The master username for the DocumentDB cluster."
  type        = string
}

variable "docdb_master_password" {
  description = "The master password for the DocumentDB cluster."
  type        = string
  sensitive   = true
}
