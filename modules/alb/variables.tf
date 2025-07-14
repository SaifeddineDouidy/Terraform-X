variable "name_prefix" { type = string }
variable "vpc_id"       { type = string }
variable "tags"         { type = map(string) }
variable "public_subnet_ids" { type = list(string) }
variable "security_group_id" { type = string }

variable "services" {
  type = map(object({
    port = number
  }))
}
