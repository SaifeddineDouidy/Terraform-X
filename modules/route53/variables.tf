variable "domain_name" {
  description = "The domain name for the Route 53 zone"
  type        = string
}

variable "subdomain" {
  description = "The subdomain to create a record for"
  type        = string
}

variable "alb_dns_name" {
  description = "The DNS name of the ALB to point to"
  type        = string
}

variable "alb_zone_id" {
  description = "The zone ID of the ALB to point to"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}