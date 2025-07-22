output "name_servers" {
  description = "A list of name servers for the created Route 53 zone."
  value       = var.domain_name != "" ? aws_route53_zone.this[0].name_servers : []
}