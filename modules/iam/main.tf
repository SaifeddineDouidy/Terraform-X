resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.name_prefix}-ecs-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "exec_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.name_prefix}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_policy" "rds_access_policy" {
  name = "${var.name_prefix}-rds-access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["rds:*"],
      Resource = "*"
    }]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "rds_policy_attach" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.rds_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "xray_policy" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}

resource "aws_iam_policy" "secrets_manager_access" {
  name = "${var.name_prefix}-secrets-manager-access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "secretsmanager:GetSecretValue",
        Resource = "*",
        Condition = {
          StringEquals = {
            "secretsmanager:ResourceTag/Environment" = var.name_prefix
          }
        }
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "secrets_manager_policy_attach" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.secrets_manager_access.arn
}

resource "aws_iam_role" "consul_ec2_role" {
  name = "${var.name_prefix}-consul-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_policy" "consul_ec2_policy" {
  name = "${var.name_prefix}-consul-ec2-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "ec2:DescribeInstances",
          "cloudwatch:PutMetricData",
          "ecs:DiscoverTasks" # For Consul to discover ECS tasks
        ],
        Resource = "*"
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "consul_ec2_policy_attach" {
  role       = aws_iam_role.consul_ec2_role.name
  policy_arn = aws_iam_policy.consul_ec2_policy.arn
}

resource "aws_iam_instance_profile" "consul_ec2_profile" {
  name = "${var.name_prefix}-consul-ec2-profile"
  role = aws_iam_role.consul_ec2_role.name
  tags = var.tags
}

resource "aws_iam_role" "rds_instance_role" {
  name = "${var.name_prefix}-rds-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "rds.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_policy" "rds_s3_backup_policy" {
  name = "${var.name_prefix}-rds-s3-backup-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = [
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:DeleteObject"
      ],
      Resource = [
        "arn:aws:s3:::${var.rds_backup_s3_bucket_name}",
        "arn:aws:s3:::${var.rds_backup_s3_bucket_name}/*"
      ]
    }]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "rds_s3_backup_policy_attach" {
  role       = aws_iam_role.rds_instance_role.name
  policy_arn = aws_iam_policy.rds_s3_backup_policy.arn
}
