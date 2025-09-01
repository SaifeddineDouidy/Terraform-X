resource "aws_lambda_function" "secret_rotation" {
  function_name    = "${var.name_prefix}-secret-rotation-lambda"
  handler          = "index.handler"
  runtime          = "python3.9"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  timeout          = 300 # 5 minutes
  memory_size      = 128

  tags = var.tags
}

resource "aws_iam_role" "lambda_role" {
  name = "${var.name_prefix}-secret-rotation-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "secret_rotation_policy" {
  name        = "${var.name_prefix}-secret-rotation-policy"
  description = "IAM policy for Lambda to rotate secrets"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:DescribeSecret",
          "secretsmanager:GetSecretValue",
          "secretsmanager:PutSecretValue",
          "secretsmanager:UpdateSecretVersionStage",
          "secretsmanager:RotateSecret",
        ],
        Resource = "*" # Restrict this to specific secrets in a real-world scenario
      },
      {
        Effect = "Allow",
        Action = [
          "rds:DescribeDBInstances",
          "rds:ModifyDBInstance",
        ],
        Resource = "*" # Restrict this to specific RDS instances
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "secret_rotation_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.secret_rotation_policy.arn
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.secret_rotation.function_name}"
  retention_in_days = 30
  tags              = var.tags
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_src"
  output_path = "${path.module}/lambda_src/lambda_function.zip"
}