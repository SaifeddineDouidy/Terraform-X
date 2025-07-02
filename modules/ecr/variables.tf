variable "repository_names" {
  type        = list(string)
  description = "List of ECR repository names to create"
}

variable "lifecycle_policy" {
  type        = string
  description = "JSON string for the ECR lifecycle policy"
}