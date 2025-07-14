variable "repository_name" {
  type        = string
  description = "Name of the ECR repository to create"
}

variable "lifecycle_policy" {
  type        = string
  description = "JSON lifecycle policy for the ECR repository"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the repository"
}
