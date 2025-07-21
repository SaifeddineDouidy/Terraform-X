resource "aws_db_subnet_group" "this" {
  name       = "${lower(var.name_prefix)}-sng"
  subnet_ids = var.subnet_ids
  tags       = var.tags
}

resource "aws_cloudwatch_log_group" "rds_logs" {
  name              = "/aws/rds/${lower(var.name_prefix)}-rds"
  retention_in_days = 30 # Adjust retention as needed
  tags              = var.tags
}

resource "aws_db_instance" "this" {
  identifier           = "${lower(var.name_prefix)}-rds"
  instance_class       = var.instance_class
  allocated_storage    = var.allocated_storage
  engine               = var.engine
  engine_version       = var.engine_version
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.security_group_ids
  multi_az             = var.multi_az_enabled
  skip_final_snapshot  = true
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"] # Example log types, adjust as needed
  tags = var.tags
}

resource "aws_s3_bucket_lifecycle_configuration" "rds_backup_bucket_lifecycle" {
  bucket = aws_s3_bucket.rds_backup_bucket.id

  rule {
    id     = "log"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      noncurrent_days = 30
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

resource "aws_s3_bucket_versioning" "rds_backup_bucket_versioning" {
  bucket = aws_s3_bucket.rds_backup_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket" "rds_backup_bucket" {
  bucket = var.rds_backup_s3_bucket_name
  acl    = "private" # Or "log-delivery-write" if using for logs


  tags = var.tags
}