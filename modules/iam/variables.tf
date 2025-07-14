variable "name_prefix" {
  type        = string
  description = "Prefix for naming IAM resources"
}

variable "tags" {
  type        = map(string)
  description = "Common tags to apply"
}
