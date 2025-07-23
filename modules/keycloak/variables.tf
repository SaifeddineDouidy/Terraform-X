variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the Keycloak resources"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the ALB"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the ECS tasks and RDS"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "keycloak_port" {
  description = "Port for the Keycloak service"
  type        = number
  default     = 8080
}

variable "certificate_arn" {
  description = "Certificate ARN for the ALB"
  type        = string
}

variable "keycloak_cpu" {
  description = "CPU units for the Keycloak ECS task"
  type        = number
}

variable "keycloak_memory" {
  description = "Memory for the Keycloak ECS task"
  type        = number
}

variable "desired_count" {
  description = "Desired number of Keycloak ECS tasks"
  type        = number
}

variable "ecs_execution_role_arn" {
  description = "ECS execution role ARN"
  type        = string
}

variable "ecs_task_role_arn" {
  description = "ECS task role ARN"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "domain_name" {
  description = "Domain name for Keycloak"
  type        = string
}

variable "db_username" {
  description = "Username for the Keycloak database"
  type        = string
}

variable "db_password_secret_arn" {
  description = "ARN of the secret containing the database password"
  type        = string
}

variable "db_instance_class" {
  description = "Instance class for the Keycloak RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage for the Keycloak RDS instance"
  type        = number
  default     = 20
}

variable "db_engine" {
  description = "Database engine for the Keycloak RDS instance"
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "Database engine version for the Keycloak RDS instance"
  type        = string
  default     = "13.7"
}

variable "db_multi_az_enabled" {
  description = "Enable multi-AZ for the Keycloak RDS instance"
  type        = bool
  default     = false
}