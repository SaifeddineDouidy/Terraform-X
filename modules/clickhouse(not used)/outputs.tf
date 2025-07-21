# modules/clickhouse/outputs.tf

# The EC2 instance ID
output "instance_id" {
  description = "ID of the ClickHouse EC2 instance"
  value       = aws_instance.clickhouse.id
}

# The public IP address
output "public_ip" {
  description = "Public IP address of the ClickHouse instance"
  value       = aws_instance.clickhouse.public_ip
}

# The public DNS name
output "public_dns" {
  description = "Public DNS name of the ClickHouse instance"
  value       = aws_instance.clickhouse.public_dns
}

# A full HTTP endpoint on port 8123
output "instance_url" {
  description = "HTTP endpoint for ClickHouse (port 8123)"
  value       = "http://${aws_instance.clickhouse.public_dns}:8123"
}
