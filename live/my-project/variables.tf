variable "project" {
  description = "Project name for tagging"
  type        = string
}

variable "service" {
  description = "Service name for tagging"
  type        = string
  default     = null
}
variable "environment" {
  description = "The deployment environment (e.g., develop, uat, preprod, prod)."
  type        = string
}

# variable "size" {
#   description = "The infrastructure size (e.g., small, medium, large)."
#   type        = string
# }

# variable "allowed_ssh_cidr" {
#   description = "List of CIDRs allowed to SSH into instances (set narrowly for prod)"
#   type        = list(string)
#   default     = ["0.0.0.0/0"] # Change this to a more restrictive CIDR in production
# }

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

variable "keycloak_public_subnet_cidrs" {
  description = "List of CIDR blocks for Keycloak public subnets."
  type        = list(string)
  default     = []
}

variable "keycloak_private_subnet_cidrs" {
  description = "List of CIDR blocks for Keycloak private subnets."
  type        = list(string)
  default     = []
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
  }))
}

variable "db_names" {
  description = "A list of database names to create within the RDS instance."
  type        = list(string)
  default     = []
}

variable "db_username" {
  description = "The master username for the RDS database."
  type        = string
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

variable "keycloak_db_username" {
  description = "Master username for the centralized Keycloak RDS database."
  type        = string
}


variable "docdb_master_username" {
  description = "The master username for the DocumentDB cluster."
  type        = string
  default     = null
}

variable "enable_waf" {
  description = "If true, enable and associate the AWS WAF with the ALB."
  type        = bool
  default     = false
}

variable "docdb_master_password" {
  description = "The master password for the DocumentDB cluster."
  type        = string
  sensitive   = true
  default     = null
}

variable "rds_backup_s3_bucket_name" {
  description = "Name of the S3 bucket for RDS backups."
  type        = string
}
