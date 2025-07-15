resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
  tags = var.tags
}

resource "aws_cloudwatch_log_group" "ecs_service_logs" {
  for_each = var.services
  name     = "/ecs/${each.key}"
  retention_in_days = 30 # Adjust retention as needed
  tags     = var.tags
}

resource "aws_cloudwatch_log_group" "xray_daemon_logs" {
  count = var.xray_enabled ? 1 : 0
  name  = "/ecs/xray-daemon"
  retention_in_days = 30 # Adjust retention as needed
  tags  = var.tags
}

resource "aws_ecs_service" "this" {
  for_each = aws_ecs_task_definition.svc

  name            = each.key
  cluster         = aws_ecs_cluster.this.id
  task_definition = each.value.arn
  desired_count   = var.services[each.key].desired
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = var.subnet_ids
    security_groups = var.security_group_ids
    assign_public_ip = false
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

  container_definitions = jsonencode(
    concat(
      [
        {
          name      = each.key
          image     = each.value.image_url
          cpu       = each.value.cpu
          memory    = each.value.memory
          portMappings = [{ containerPort = each.value.port, hostPort = each.value.port }]
          environment = [
            for k, v in each.value.env : { name = k, value = v }
          ]
          secrets = [
            for k, v in each.value.secrets : { name = k, valueFrom = v }
          ]
          essential   = true
          logConfiguration = {
            logDriver = "awslogs"
            options = {
              "awslogs-group"         = "/ecs/${each.key}"
              "awslogs-region"        = var.aws_region
              "awslogs-stream-prefix" = each.key
            }
          }
        }
      ],
      var.xray_enabled ? [
        {
          name      = "xray-daemon"
          image     = "amazon/aws-xray-daemon:3.x"
          cpu       = 32
          memory    = 256
          essential = true
          portMappings = [
            { containerPort = 2000, protocol = "udp" }
          ]
          logConfiguration = {
            logDriver = "awslogs"
            options = {
              "awslogs-group"         = "/ecs/xray-daemon"
              "awslogs-region"        = var.aws_region
              "awslogs-stream-prefix" = "xray-daemon"
            }
          }
        }
      ] : []
    )
  )
}

