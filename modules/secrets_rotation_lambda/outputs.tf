output "lambda_function_arn" {
  description = "The ARN of the secret rotation Lambda function."
  value       = aws_lambda_function.secret_rotation.arn
}