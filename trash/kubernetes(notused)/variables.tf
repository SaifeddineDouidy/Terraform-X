variable "subnet_ids" {
  description = "Subnets where the EKS cluster and nodes will be placed."
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type for EKS worker nodes."
  type        = string
}

variable "node_count" {
  description = "Number of worker nodes in the EKS node group."
  type        = number
}

variable "name_prefix" {
  description = "Prefix for naming EKS cluster and related resources."
  type        = string
}