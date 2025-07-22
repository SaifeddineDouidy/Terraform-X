resource "aws_security_group" "keycloak_alb_sg" {
  name        = "${var.name_prefix}-keycloak-alb-sg"
  description = "Allow HTTPS from internet to Keycloak ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_security_group" "keycloak_ecs_sg" {
  name        = "${var.name_prefix}-keycloak-ecs-sg"
  description = "Allow traffic to Keycloak ECS tasks from ALB and RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.keycloak_port
    to_port         = var.keycloak_port
    protocol        = "tcp"
    security_groups = [aws_security_group.keycloak_alb_sg.id]
  }

  # Keycloak clustering uses JGroups, which can use TCPPING or JDBC_PING
  # For Fargate, JDBC_PING is often preferred. If TCPPING is used, ensure ports are open.
  ingress {
    from_port = 7600 # JGroups port for Keycloak clustering (if TCP)
    to_port   = 7600
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_lb" "keycloak_alb" {
  name               = "${var.name_prefix}-keycloak-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [aws_security_group.keycloak_alb_sg.id]

  tags = var.tags
}

resource "aws_lb_target_group" "keycloak_tg" {
  name        = "${var.name_prefix}-keycloak-tg"
  port        = var.keycloak_port
  protocol    = "HTTP" # Keycloak's default HTTP port for health checks
  vpc_id      = var.vpc_id
  target_type = "ip" # For Fargate

  health_check {
    path                = "/auth/realms/master" # Keycloak health check endpoint
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = var.tags
}

resource "aws_lb_listener" "keycloak_https_listener" {
  load_balancer_arn = aws_lb.keycloak_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.keycloak_tg.arn
  }
}

resource "aws_ecs_cluster" "keycloak_cluster" {
  name = "${var.name_prefix}-keycloak-cluster"
  tags = var.tags
}

resource "aws_ecs_task_definition" "keycloak_td" {
  family                   = "${var.name_prefix}-keycloak-td"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.keycloak_cpu
  memory                   = var.keycloak_memory
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64" # Graviton for cost savings
  }

  container_definitions = jsonencode([
    {
      name      = "keycloak"
      image     = "quay.io/keycloak/keycloak:23.0.7" # Use a specific version
      cpu       = var.keycloak_cpu
      memory    = var.keycloak_memory
      essential = true
      portMappings = [
        {
          containerPort = var.keycloak_port
          hostPort      = var.keycloak_port
          protocol      = "tcp"
        }
      ]
      environment = [
        { name = "KC_DB", value = "postgres" },
        { name = "KC_DB_URL", value = "jdbc:postgresql://${var.db_endpoint}:${var.db_port}/keycloak" },
        { name = "KC_DB_USERNAME", value = var.db_username },
        { name = "KC_DB_PASSWORD", value = var.db_password },
        { name = "KC_HOSTNAME", value = "keycloak.${var.domain_name}" }, # Public hostname
        { name = "KC_PROXY", value = "edge" },
        { name = "KC_HTTP_PORT", value = tostring(var.keycloak_port) },
        { name = "JGROUPS_DISCOVERY_PROTOCOL", value = "JDBC_PING" }, # For Fargate clustering
        { name = "JGROUPS_JDBC_PING_TABLE_NAME", value = "JGROUPSPING" },
        { name = "JGROUPS_JDBC_PING_SCHEMA", value = "public" },
        { name = "JGROUPS_JDBC_PING_DATASOURCE_JNDI_NAME", value = "java:jboss/datasources/KeycloakDS" } # Default JNDI name
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/keycloak"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "keycloak"
        }
      }
    }
  ])
  tags = var.tags
}

resource "aws_ecs_service" "keycloak_service" {
  name            = "${var.name_prefix}-keycloak-service"
  cluster         = aws_ecs_cluster.keycloak_cluster.id
  task_definition = aws_ecs_task_definition.keycloak_td.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.keycloak_ecs_sg.id, aws_security_group.keycloak_rds_sg.id] # Add RDS SG here
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.keycloak_tg.arn
    container_name   = "keycloak"
    container_port   = var.keycloak_port
  }
  tags = var.tags
}

resource "aws_cloudwatch_log_group" "keycloak_logs" {
  name              = "/ecs/keycloak"
  retention_in_days = 30
  tags              = var.tags
}

resource "aws_db_instance" "keycloak_rds" {
  identifier           = lower(replace("${var.name_prefix}-keycloak-rds", "_", "-"))
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_type
  allocated_storage    = var.db_allocated_storage
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.keycloak_rds_sng.name
  vpc_security_group_ids = [aws_security_group.keycloak_rds_sg.id]
  multi_az             = true # Always Multi-AZ for HA Keycloak DB
  skip_final_snapshot  = true
  tags                 = var.tags
}

resource "aws_db_subnet_group" "keycloak_rds_sng" {
  name       = lower("${var.name_prefix}-keycloak-rds-sng")
  subnet_ids = var.private_subnet_ids
  tags       = var.tags
}

resource "aws_security_group" "keycloak_rds_sg" {
  name        = "${var.name_prefix}-keycloak-rds-sg"
  description = "Allow Keycloak ECS tasks to connect to RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.keycloak_ecs_sg.id] # Allow from ECS SG
  }

  tags = var.tags
}