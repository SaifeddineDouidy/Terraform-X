output "cluster_id"   { value = aws_ecs_cluster.this.id }

output "cloud_map_namespace_name" {
  description = "The name of the Cloud Map private DNS namespace."
  value       = aws_service_discovery_private_dns_namespace.this.name
}
