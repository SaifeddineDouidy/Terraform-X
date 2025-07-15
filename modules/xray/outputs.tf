output "sampling_rule_arn" {
  description = "The ARN of the X-Ray sampling rule."
  value       = aws_xray_sampling_rule.this.arn
}