output "consul_service_discovery_name" {
  description = "The name of the Consul service in service discovery."
  value       = aws_service_discovery_service.consul.name
}

output "consul_security_group_id" {
  description = "The ID of the security group for the Consul ECS service."
  value       = aws_security_group.consul_sg.id
}