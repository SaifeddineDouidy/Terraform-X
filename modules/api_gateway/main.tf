resource "aws_apigatewayv2_api" "this" {
  name          = var.name
  protocol_type = "HTTP"
  tags          = var.tags
}

# for each route:
resource "aws_apigatewayv2_route" "this" {
  for_each    = var.routes
  api_id      = aws_apigatewayv2_api.this.id
  route_key   = "${each.value.path} GET"
  target      = "http integrations/${aws_apigatewayv2_integration.this[each.key].id}"
}

resource "aws_apigatewayv2_integration" "this" {
  for_each            = var.routes
  api_id              = aws_apigatewayv2_api.this.id
  integration_type    = "HTTP_PROXY"
  integration_uri     = each.value.target_url
  payload_format_version = "1.0"
}
