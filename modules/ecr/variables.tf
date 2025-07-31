variable "repositories" {
  description = "Map of repositories and their lifecycle policy paths"
  type = map(object({
    lifecycle_policy_path = string
    lifecycle_policy_content = string
  }))
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to each repository"
}
