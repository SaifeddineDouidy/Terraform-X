output "db_instance_endpoint" {
  description = "The connection endpoint for the RDS instance."
  value       = aws_db_instance.this.endpoint
}

output "db_instance_port" {
  description = "The port on which the RDS instance is listening."
  value       = aws_db_instance.this.port
}

output "db_instance_name" {
  description = "The name of the RDS instance."
  value       = aws_db_instance.this.db_name
}