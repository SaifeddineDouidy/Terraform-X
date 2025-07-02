locals {
  environment = lookup(
    var.workspace_to_environment_map,
    terraform.workspace,
    terraform.workspace
  )

  environment_mapped = title(local.environment)

  common_tags = {
    Project     = var.project
    Service     = var.service
    Environment = local.environment_mapped
  }
}
