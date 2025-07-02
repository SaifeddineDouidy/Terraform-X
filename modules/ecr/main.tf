resource "aws_ecr_repository" "this" {
  for_each = toset(var.repository_names)
  name     = each.value
}