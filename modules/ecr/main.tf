resource "aws_ecr_repository" "this" {
  for_each             = var.repositories
  name                 = each.key
  image_tag_mutability = "MUTABLE"
  tags                 = var.tags
}

resource "aws_ecr_lifecycle_policy" "this" {
  for_each   = var.repositories
  repository = aws_ecr_repository.this[each.key].name
  policy     = each.value.lifecycle_policy_content
}
