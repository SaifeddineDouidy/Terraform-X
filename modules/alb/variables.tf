variable "name_prefix" { type = string }
variable "vpc_id"       { type = string }
variable "tags"         { type = map(string) }
variable "public_subnet_ids" { type = list(string) }
variable "security_group_id" { type = string }

variable "services" {
  type = map(object({
    port     = number
    path     = string
    priority = optional(number, 100) # Add optional priority for listener rules
  }))
}

variable "certificate_arn" {
  description = "The ARN of the ACM certificate for the HTTPS listener."
  type        = string
  default     = ""
}

variable "enable_https" {
  description = "Whether to enable the HTTPS listener and redirect HTTP traffic."
  type        = bool
  default     = false
}
