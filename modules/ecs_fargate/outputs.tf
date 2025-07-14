output "cluster_id"   { value = aws_ecs_cluster.this.id }
output "service_names" {
  description = "Map of ECS service names by key"
  value       = { for k, s in aws_ecs_service.this : k => s.name }
}
