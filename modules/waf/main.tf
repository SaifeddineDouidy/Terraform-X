resource "aws_wafv2_web_acl" "this" {
  name        = "${var.name_prefix}-waf-acl"
  scope       = "REGIONAL"
  description = "WAF Web ACL for the application."

  default_action {
    allow {}
  }

  rule {
    name     = "AWS-Managed-Core-Rule-Set"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.name_prefix}-waf-metrics"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.name_prefix}-waf-metrics"
    sampled_requests_enabled   = true
  }

  tags = var.tags
}