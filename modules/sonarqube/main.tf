resource "aws_security_group" "sonarqube_sg" {
  name        = "${var.name_prefix}-sonarqube-sg"
  description = "Security group for SonarQube"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 9000
    to_port     = 9000
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

resource "aws_instance" "sonarqube" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  volume_tags = var.common_tags
  vpc_security_group_ids = [aws_security_group.sonarqube_sg.id]
  tags = merge(var.common_tags, { Name = "${var.name_prefix}-sonarqube" })
  root_block_device {
    volume_type = "gp3"  # Adjust as needed
    volume_size = 10     # Adjust as needed
    tags = var.common_tags
  }
}