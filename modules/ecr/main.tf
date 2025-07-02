resource "aws_ecr_repository" "this" {
  for_each = toset(var.repository_names)
  name     = each.value
}

resource "aws_ecr_lifecycle_policy" "this" {
  for_each   = toset(var.repository_names)
  repository = each.value
  policy     = var.lifecycle_policy
}