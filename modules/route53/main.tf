resource "aws_route53_zone" "this" {
  count = var.domain_name != "" ? 1 : 0
  name  = var.domain_name
  tags  = var.tags
}

resource "aws_route53_record" "subdomain" {
  count   = var.domain_name != "" && var.subdomain != "" ? 1 : 0
  zone_id = aws_route53_zone.this[0].zone_id
  name    = var.subdomain
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}