output "db_endpoint" {
  description = "The connection endpoint for the RDS instance."
  value       = aws_db_instance.this.address
}

output "db_instance_port" {
  description = "The port on which the RDS instance is listening."
  value       = aws_db_instance.this.port
}

output "rds_backup_s3_bucket_name" {
  description = "The name of the S3 bucket created for RDS backups."
  value       = aws_s3_bucket.rds_backup_bucket.bucket
}

output "db_instance_name" {
  description = "The name of the RDS instance."
  value       = aws_db_instance.this.db_name
}