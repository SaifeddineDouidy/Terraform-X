resource "aws_security_group" "clickhouse_sg" {
  name        = "${var.name_prefix}-clickhouse-sg"
  description = "Security group for ClickHouse"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8123
    to_port     = 8123
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust as needed for security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "clickhouse" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.clickhouse_sg.id]
  tags = merge(var.common_tags, { Name = "${var.name_prefix}-clickhouse" })
  root_block_device {
    volume_type = "gp3"  # Adjust as needed
    volume_size = 20     # Adjust as needed
    tags = var.common_tags
  }
}