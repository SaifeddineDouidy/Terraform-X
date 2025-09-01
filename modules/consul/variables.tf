variable "name_prefix" {
  description = "A prefix for naming resources to ensure uniqueness and context."
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to all resources."
  type        = map(string)
  default     = {}
}

variable "ecs_cluster_id" {
  description = "The ID of the ECS cluster where Consul will be deployed."
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of private subnet IDs where Consul tasks will be launched."
  type        = list(string)
}

variable "desired_count" {
  description = "The desired number of Consul tasks to run."
  type        = number
  default     = 1
}

variable "cpu" {
  description = "The CPU units for the Consul task."
  type        = number
  default     = 256
}

variable "memory" {
  description = "The memory (in MiB) for the Consul task."
  type        = number
  default     = 512
}

variable "ecs_execution_role_arn" {
  description = "The ARN of the IAM role that the Amazon ECS container agent can assume."
  type        = string
}

variable "ecs_task_role_arn" {
  description = "The ARN of the IAM role that the ECS tasks can assume."
  type        = string
}

variable "aws_region" {
  description = "The AWS region where resources are deployed."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the security group will be created."
  type        = string
}

variable "service_discovery_namespace_id" {
  description = "The ID of the private DNS namespace for service discovery."
  type        = string
}