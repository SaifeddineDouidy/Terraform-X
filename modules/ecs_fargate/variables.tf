variable "cluster_name"       { type = string }
variable "subnet_ids"         { type = list(string) }
variable "security_group_ids" { type = list(string) }

variable "tags"               { type = map(string) }

variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
}



variable "services" {
  type = map(object({
    cpu         = number
    memory      = number
    desired     = number
    port        = number
    image_url   = string
    env         = map(string)
  }))
}

variable "execution_role_arn" {
  description = "The ARN of the ECS task execution role"
  type        = string
}
# Add your variable declarations here

variable "task_role_arn" {
  description = "The ARN of the IAM role that allows your Amazon ECS container task to make calls to other AWS services."
  type        = string
}