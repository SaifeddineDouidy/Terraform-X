locals {
  environment = lookup(
    var.workspace_to_environment_map,
    terraform.workspace,
    terraform.workspace
  )
  size = (
    local.environment == "develop" ?
      lookup(var.workspace_to_size_map, terraform.workspace, "small") :
      lookup(var.environment_to_size_map, local.environment)
  )
  common_tags = {
    Project = var.project
    Environment = local.environment
  }
}