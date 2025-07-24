variable "name_prefix" {
  description = "Prefix for the DocumentDB resources."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to launch the DocumentDB cluster in."
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs for the DocumentDB cluster."
  type        = list(string)
}

variable "security_group_ids" {
  description = "A list of security group IDs to associate with the DocumentDB cluster."
  type        = list(string)
}

variable "instance_class" {
  description = "The instance class for the DocumentDB instances."
  type        = string
  default     = "db.t4g.small" # Default to a T4g instance type
}

variable "instance_count" {
  description = "The number of instances in the DocumentDB cluster."
  type        = number
  default     = 1
}

variable "master_username" {
  description = "The master username for the DocumentDB cluster."
  type        = string
}

variable "master_password" {
  description = "The master password for the DocumentDB cluster."
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}