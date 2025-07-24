# ALB SG
resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-alb-sg"
  description = "Allow HTTPS from internet"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = merge(var.tags, {
    Name = "${var.name_prefix}-alb-sg"
  })
}

# ECS SG
resource "aws_security_group" "ecs" {
  name   = "${var.name_prefix}-ecs-sg"
  vpc_id = aws_vpc.this.id

  # Allow from ALB on port 8080

  ingress {
    from_port       = 2000
    to_port         = 2000
    protocol        = "udp"
    self            = true
  }
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    self            = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # For NAT Gateway
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-ecs-sg"
  })
}

# DocumentDB SG
resource "aws_security_group" "docdb" {
  name   = "${var.name_prefix}-docdb-sg"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    # Reference will be created in security_group_rules.tf
    # security_groups = [aws_security_group.ecs.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-docdb-sg"
  })
}

# RDS SG
resource "aws_security_group" "rds" {
  name   = "${var.name_prefix}-rds-sg"
  vpc_id = aws_vpc.this.id


  # No outbound rules for RDS as per design

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-rds-sg"
  })
}

# Consul SG
resource "aws_security_group" "consul" {
  name        = "${var.name_prefix}-consul-sg"
  description = "Security group for Consul EC2 instances"
  vpc_id      = aws_vpc.this.id


  ingress {
    from_port = 8300
    to_port   = 8302
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # For NAT Gateway
  }

  egress {
    from_port = 8300
    to_port   = 8302
    protocol  = "tcp"
    self      = true
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-consul-sg"
  })
}
