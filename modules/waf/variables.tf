variable "name_prefix" {
  description = "Prefix for the WAF resources."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}