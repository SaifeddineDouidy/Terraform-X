variable "vpc_id" {
  description = "ID of the VPC where the instance will be deployed."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for launching the EC2 instance."
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "List of CIDR blocks allowed to SSH to the instances."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ami_id" {
  description = "AMI ID to use for the EC2 instance."
  type        = string
}

variable "name_prefix" {
  description = "Prefix for naming EC2 and Security Group."
  type        = string
}

variable "instance_profile_role_name" {
  description = "The name of the IAM role to associate with the instance profile."
  type        = string
  default     = ""
}

variable "security_group_ids" {
  description = "Additional security group IDs to associate with the EC2 instance."
  type        = list(string)
  default     = []
}

variable "user_data" {
  description = "User data script to run on instance startup."
  type        = string
  default     = null
}