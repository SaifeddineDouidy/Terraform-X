output "keycloak_alb_dns_name" {
  description = "The DNS name of the Keycloak Application Load Balancer."
  value       = aws_lb.keycloak_alb.dns_name
}

output "keycloak_alb_zone_id" {
  description = "The canonical hosted zone ID of the Keycloak ALB (for Route 53 Alias records)."
  value       = aws_lb.keycloak_alb.zone_id
}

output "keycloak_rds_endpoint" {
  description = "The endpoint address of the Keycloak RDS database."
  value       = aws_db_instance.keycloak_rds.address
}