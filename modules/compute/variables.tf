variable "vpc_id" {
  description = "ID of the VPC where the instance will be deployed."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for launching the EC2 instance."
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type (e.g., t2.micro)."
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