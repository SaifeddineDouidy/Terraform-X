variable "repositories" {
  description = "A map of repository names to their lifecycle policy content."
  type        = map(string)
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to each repository"
}
