variable "ami_id" {
  type        = string
  description = "AMI ID for ClickHouse instance"
}

variable "instance_type" {
  type        = string
  description = "Instance type for ClickHouse"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the instance"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the security group"
}

variable "name_prefix" {
  type        = string
  description = "Prefix for resource names"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags to apply to resources"
}