variable "vpc_cidr" {
  description = "CIDR block for the VPC (e.g., 10.0.0.0/16)."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string)
}

variable "private_subnet_cidrs"{
  description = "List of CIDR blocks for private subnets."
  type        = list(string)
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

variable "name_prefix" {
  description = "Prefix for naming AWS resources (e.g., environment or project name)."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

variable "single_nat_gateway" {
  description = "If true, create a single NAT gateway. If false, create one per public subnet."
  type        = bool
  default     = false
}