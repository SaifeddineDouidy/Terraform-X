variable "domain_name" {
  description = "The domain name of the hosted zone to create."
  type        = string
}

variable "subdomain" {
  description = "The subdomain to create an A record for."
  type        = string
}

variable "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer."
  type        = string
}

variable "alb_zone_id" {
  description = "The zone ID of the Application Load Balancer."
  type        = string
}