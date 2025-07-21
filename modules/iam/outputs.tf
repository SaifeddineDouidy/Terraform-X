output "ecs_execution_role_arn" {
  value = aws_iam_role.ecs_execution_role.arn
}

output "ecs_task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}

output "consul_ec2_role_name" {
  value = aws_iam_role.consul_ec2_role.name
}

output "consul_ec2_instance_profile_arn" {
  value = aws_iam_instance_profile.consul_ec2_profile.arn
}

output "rds_instance_role_arn" {
  value = aws_iam_role.rds_instance_role.arn
}
