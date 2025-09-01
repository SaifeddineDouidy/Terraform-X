resource "aws_ecs_service" "consul" {
  name            = "${var.name_prefix}-consul"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.consul.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.consul_sg.id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.consul.arn
  }

  tags = var.tags
}

resource "aws_ecs_task_definition" "consul" {
  family                   = "${var.name_prefix}-consul"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name         = "consul"
      image        = "hashicorp/consul:1.10.0" # Use a specific version
      cpu          = var.cpu
      memory       = var.memory
      essential    = true
      portMappings = [
        {
          containerPort = 8500
          hostPort      = 8500
          protocol      = "tcp"
        },
        {
          containerPort = 8301
          hostPort      = 8301
          protocol      = "udp"
        },
        {
          containerPort = 8301
          hostPort      = 8301
          protocol      = "tcp"
        },
        {
          containerPort = 8302
          hostPort      = 8302
          protocol      = "udp"
        },
        {
          containerPort = 8302
          hostPort      = 8302
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "CONSUL_BIND_INTERFACE"
          value = "eth0"
        },
        {
          name  = "CONSUL_CLIENT_INTERFACE"
          value = "eth0"
        },
        {
          name  = "CONSUL_SERVER"
          value = "true"
        },
        {
          name  = "CONSUL_BOOTSTRAP_EXPECT"
          value = var.desired_count == 1 ? "1" : "3" # For single or multi-node setup
        },
        {
          name  = "CONSUL_UI"
          value = "true"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.consul_logs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "consul"
        }
      }
    }
  ])

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "consul_logs" {
  name              = "/ecs/consul"
  retention_in_days = 30
  tags              = var.tags
}

resource "aws_security_group" "consul_sg" {
  name        = "${var.name_prefix}-consul-sg"
  description = "Security group for Consul ECS service"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict this in production
  }

  ingress {
    from_port   = 8301
    to_port     = 8302
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict this to VPC CIDR in production
  }

  ingress {
    from_port   = 8301
    to_port     = 8302
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict this to VPC CIDR in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_service_discovery_service" "consul" {
  name = "consul"

  dns_config {
    namespace_id = var.service_discovery_namespace_id

    dns_records {
      type = "A"
      ttl  = 10
    }

    routing_policy = "MULTIVALUE"
  }

  tags = var.tags
}