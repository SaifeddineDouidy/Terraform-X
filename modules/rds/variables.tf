variable "name_prefix" {
  description = "Prefix for the RDS resources."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to launch the RDS instance in."
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs for the RDS instance."
  type        = list(string)
}

variable "security_group_ids" {
  description = "A list of security group IDs to associate with the RDS instance."
  type        = list(string)
}

variable "instance_class" {
  description = "The instance class for the RDS instance."
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes."
  type        = number
  default     = 20
}

variable "engine" {
  description = "The database engine to use."
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "The database engine version."
  type        = string
  default     = "13.7"
}

variable "db_names" {
  description = "A list of database names to create within the RDS instance."
  type        = list(string)
  default     = []
}

variable "db_username" {
  description = "The master username for the database."
  type        = string
}

variable "db_password" {
  description = "The master password for the database."
  type        = string
  sensitive   = true
}

variable "multi_az_enabled" {
  description = "Whether to enable Multi-AZ deployment for the RDS instance."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

variable "rds_backup_s3_bucket_name" {
  description = "Name of the S3 bucket for RDS backups."
  type        = string
}
