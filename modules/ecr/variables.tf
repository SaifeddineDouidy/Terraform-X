variable "repository_names" {
  type        = list(string)
  description = "List of ECR repository names to create"
}

variable "lifecycle_policy" {
  type        = string
  description = "JSON string for the ECR lifecycle policy"
  default     = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images older than 30 days"
        selection    = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}