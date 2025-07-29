locals {
  environment_mapped = lookup(var.workspace_to_environment_tag_map, terraform.workspace, "develop")

  size = (local.environment_mapped == "develop" ?
    lookup(var.workspace_to_size_map, terraform.workspace, "small") :
    lookup(var.environment_to_size_map, local.environment_mapped)
  )

  common_tags = {
    Project     = var.project
    Service     = var.service
    Environment = local.environment_mapped
  }
}