variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "project" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Current deployment environment"
  type        = string
}

variable "ecs_services" {
  description = "ECS Fargate services configuration"
  type = map(object({
    name                  = string
    cpu                   = number
    memory                = number
    desired_count         = number
    port                  = number
    lifecycle_policy_path = string
    alb_priority          = optional(number, 100) # Add optional priority for ALB listener rules
  }))
}

variable "db_names" {
  description = "Names of the databases"
  type        = list(string)
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
}

variable "domain_name" {
  description = "Domain name for ACM certificate"
  type        = string
}

variable "rds_multi_az_enabled" {
  description = "Enable Multi-AZ deployment for RDS"
  type        = bool
}

variable "rds_backup_s3_bucket_name" {
  description = "S3 bucket name for RDS backups"
  type        = string
}

variable "keycloak_db_username" {
  description = "Username for the Keycloak database"
  type        = string
}

variable "enable_waf" {
  description = "Enable WAF"
  type        = bool
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "keycloak_db_instance_class" {
  description = "Instance class for the Keycloak RDS instance"
  type        = string
  default     = "db.t4g.micro"
}

variable "keycloak_db_allocated_storage" {
  description = "Allocated storage for the Keycloak RDS instance"
  type        = number
  default     = 20
}

variable "keycloak_db_engine" {
  description = "Database engine for the Keycloak RDS instance"
  type        = string
  default     = "postgres"
}

variable "keycloak_db_engine_version" {
  description = "Database engine version for the Keycloak RDS instance"
  type        = string
  default     = "13.7"
}

variable "keycloak_db_multi_az_enabled" {
  description = "Enable multi-AZ for the Keycloak RDS instance"
  type        = bool
  default     = false
}

variable "workspace_to_environment_tag_map" {
  description = "Map from workspace name to environment tag"
  type        = map(string)
  default     = {}
}

variable "workspace_to_size_map" {
  description = "Map from workspace name to size"
  type        = map(string)
  default     = {}
}

variable "environment_to_size_map" {
  description = "Map from environment to size"
  type        = map(string)
  default     = {}
}

variable "service" {
  description = "The service name"
  type        = string
  default     = "holisticx"
}

variable "keycloak_public_subnet_cidrs" {
  description = "CIDR blocks for Keycloak public subnets"
  type        = list(string)
  default     = []
}

variable "keycloak_private_subnet_cidrs" {
  description = "CIDR blocks for Keycloak private subnets"
  type        = list(string)
  default     = []
}

variable "secret_recovery_window_days" {
  description = "Number of days for secret recovery window. Set to 0 for immediate deletion in dev environments."
  type        = number
  default     = 0
}
