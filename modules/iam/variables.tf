variable "name_prefix" {
  type        = string
  description = "Prefix for naming IAM resources"
}

variable "tags" {
  type        = map(string)
  description = "Common tags to apply"
}

variable "rds_backup_s3_bucket_name" {
  description = "Name of the S3 bucket for RDS backups."
  type        = string
}
