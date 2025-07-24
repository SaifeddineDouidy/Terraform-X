output "cluster_endpoint" {
  description = "The connection endpoint for the DocumentDB cluster."
  value       = aws_docdb_cluster.this.endpoint
}

output "cluster_port" {
  description = "The port on which the DocumentDB cluster is listening."
  value       = aws_docdb_cluster.this.port
}

output "cluster_id" {
  description = "The ID of the DocumentDB cluster."
  value       = aws_docdb_cluster.this.id
}