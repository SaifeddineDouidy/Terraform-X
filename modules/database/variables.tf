variable "read_capacity" {
  description = "Read capacity units for the DynamoDB table."
  type        = number
}

variable "write_capacity" {
  description = "Write capacity units for the DynamoDB table."
  type        = number
}

variable "name_prefix" {
  description = "Prefix for naming the DynamoDB table."
  type        = string
}