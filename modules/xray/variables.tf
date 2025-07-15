variable "name_prefix" {
  description = "Prefix for the X-Ray sampling rule name."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the resources."
  type        = map(string)
  default     = {}
}