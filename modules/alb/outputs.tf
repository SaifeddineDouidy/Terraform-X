output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "alb_arn" {
  description = "The ARN of the ALB."
  value       = aws_lb.this.arn
}
