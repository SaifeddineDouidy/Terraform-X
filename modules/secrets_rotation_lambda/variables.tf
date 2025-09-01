variable "name_prefix" {
  description = "A prefix for naming resources to ensure uniqueness and context."
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to all resources."
  type        = map(string)
  default     = {}
}