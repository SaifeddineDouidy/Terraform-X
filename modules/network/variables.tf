variable "vpc_cidr" {
  description = "CIDR block for the VPC (e.g., 10.0.0.0/16)."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string)
}

variable "name_prefix" {
  description = "Prefix for naming AWS resources (e.g., environment or project name)."
  type        = string
}