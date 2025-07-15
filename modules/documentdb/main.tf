resource "aws_docdb_subnet_group" "this" {
  name       = "${lower(var.name_prefix)}-sng"
  subnet_ids = var.subnet_ids
  tags       = var.tags
}

resource "aws_cloudwatch_log_group" "docdb_logs" {
  name              = "/aws/docdb/${lower(var.name_prefix)}-docdb-cluster"
  retention_in_days = 30 # Adjust retention as needed
  tags              = var.tags
}

resource "aws_docdb_cluster" "this" {
  cluster_identifier      = "${lower(var.name_prefix)}-docdb-cluster"
  master_username         = var.master_username
  master_password         = var.master_password
  db_subnet_group_name    = aws_docdb_subnet_group.this.name
  vpc_security_group_ids  = var.security_group_ids
  skip_final_snapshot     = true
  enabled_cloudwatch_logs_exports = ["audit", "profiler"] # Example log types, adjust as needed
  tags                    = var.tags
}

resource "aws_docdb_cluster_instance" "this" {
  count              = var.instance_count
  identifier         = "${lower(var.name_prefix)}-docdb-instance-${count.index}"
  cluster_identifier = aws_docdb_cluster.this.id
  instance_class     = var.instance_class
  tags               = var.tags
}