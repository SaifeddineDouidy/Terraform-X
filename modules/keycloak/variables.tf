variable "name_prefix" {
  description = "Prefix for naming Keycloak resources."
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
}

variable "domain_name" {
  description = "The root domain name for the Keycloak hostname."
  type        = string
}

variable "ecs_execution_role_arn" {
  description = "The ARN of the ECS task execution role for Keycloak."
  type        = string
}

variable "ecs_task_role_arn" {
  description = "The ARN of the ECS task role for Keycloak."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where Keycloak will be deployed."
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the Keycloak ALB."
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for Keycloak instances and RDS."
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to assign to Keycloak resources."
  type        = map(string)
  default     = {}
}

variable "keycloak_port" {
  description = "The port Keycloak listens on (e.g., 8080 for HTTP, 8443 for HTTPS)."
  type        = number
  default     = 8080 # Default to HTTP for internal ALB communication
}

variable "certificate_arn" {
  description = "The ARN of the ACM certificate for the Keycloak ALB HTTPS listener."
  type        = string
}

variable "keycloak_cpu" {
  description = "The CPU units for the Keycloak Fargate task."
  type        = number
  default     = 1024 # 1 vCPU
}

variable "keycloak_memory" {
  description = "The memory (in MiB) for the Keycloak Fargate task."
  type        = number
  default     = 2048 # 2 GB
}

variable "desired_count" {
  description = "The desired number of Keycloak Fargate tasks."
  type        = number
  default     = 2
}

variable "db_engine" {
  description = "Database engine for Keycloak RDS (e.g., postgres, mysql)."
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "Database engine version for Keycloak RDS."
  type        = string
  default     = "14.7"
}

variable "db_instance_type" {
  description = "RDS instance type for Keycloak database."
  type        = string
  default     = "db.t4g.medium" # Example instance type
}

variable "db_allocated_storage" {
  description = "Allocated storage for Keycloak RDS in GB."
  type        = number
  default     = 20
}

variable "db_username" {
  description = "Master username for Keycloak RDS."
  type        = string
}

variable "db_password" {
  description = "Master password for Keycloak RDS."
  type        = string
  sensitive   = true
}

variable "db_port" {
  description = "Port for Keycloak RDS."
  type        = number
  default     = 5432 # Default for PostgreSQL
}

variable "db_endpoint" {
  description = "The endpoint of the Keycloak RDS instance."
  type        = string
}