// ecs.tf

resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
  tags = var.tags
}

resource "aws_cloudwatch_log_group" "ecs_service_logs" {
  for_each          = toset(keys(var.services))  # Only depend on keys
  name              = "/ecs/${each.key}"
  retention_in_days = 30
  tags              = var.tags
}

resource "aws_cloudwatch_log_group" "xray_daemon_logs" {
  count              = var.xray_enabled ? 1 : 0
  name               = "/ecs/xray-daemon"
  retention_in_days  = 30
  tags               = var.tags
}

resource "aws_service_discovery_private_dns_namespace" "this" {
  name        = "${var.cluster_name}.local"
  description = "Private DNS Namespace for ECS services"
  vpc         = var.vpc_id
}

resource "aws_service_discovery_service" "this" {
  for_each = toset(keys(var.services)) 
  name = each.key

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.this.id

    dns_records {
      type = "A"
      ttl  = 10
    }

    routing_policy = "MULTIVALUE"
  }

}

resource "aws_ecs_task_definition" "svc" {
  for_each = var.services

  family                   = each.key
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = each.value.cpu
  memory                   = each.value.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  container_definitions = jsonencode(
    concat(
      [
        {
          name         = each.key
          image        = each.value.image_url
          cpu          = each.value.cpu
          memory       = each.value.memory
          portMappings = [
            {
              containerPort = each.value.port
              hostPort      = each.value.port
            }
          ]
          environment = [
            for k, v in each.value.env : {
              name  = k
              value = v
            }
          ]
          secrets = [
            for k, v in each.value.secrets : {
              name      = k
              valueFrom = v
            }
          ]
          essential = true
          logConfiguration = {
            logDriver = "awslogs"
            options = {
              awslogs-group         = aws_cloudwatch_log_group.ecs_service_logs[each.key].name
              awslogs-region        = var.aws_region
              awslogs-stream-prefix = each.key
            }
          }
        }
      ],
      var.xray_enabled ? [
        {
          name         = "xray-daemon"
          image        = "amazon/aws-xray-daemon:3.x"
          cpu          = 32
          memory       = 256
          essential    = true
          portMappings = [
            {
              containerPort = 2000
              protocol      = "udp"
            }
          ]
          logConfiguration = {
            logDriver = "awslogs"
            options = {
              awslogs-group         = aws_cloudwatch_log_group.xray_daemon_logs[0].name
              awslogs-region        = var.aws_region
              awslogs-stream-prefix = "xray-daemon"
            }
          }
        }
      ] : []
    )
  )
}

resource "aws_ecs_service" "this" {
  for_each = var.services

  name            = each.key
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.svc[each.key].arn
  desired_count   = each.value.desired
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.this[each.key].arn
  }
}
