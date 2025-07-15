resource "aws_xray_sampling_rule" "this" {
  rule_name      = "${var.name_prefix}-sampling-rule"
  priority       = 10
  fixed_rate     = 0.05 # 5% of requests
  reservoir_size = 1
  service_name   = "*"
  http_method    = "*"
  url_path       = "*"
  service_type   = "*"
  host           = "*"
  resource_arn   = "*"
  version        = 1

  tags = var.tags
}