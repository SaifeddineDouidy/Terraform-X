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
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.security_group_ids
  multi_az             = var.multi_az_enabled
  skip_final_snapshot  = true
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"] # Example log types, adjust as needed
  tags                 = var.tags
}