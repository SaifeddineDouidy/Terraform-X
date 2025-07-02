locals {
  # Map Terraform workspace to a normalized FinOps-approved Environment tag
  environment_mapped = lookup(
    {
      dev    = "Dev"
      develop = "Dev"
      live   = "Prod"
      prod   = "Prod"
      uat    = "Stage"
      staging = "Stage"
    },
    terraform.workspace,
    "Dev" # default if not explicitly mapped
  )

  size = (local.environment_mapped == "Dev" ?
    lookup(var.workspace_to_size_map, terraform.workspace, "small") :
    lookup(var.environment_to_size_map, local.environment_mapped)
  )
  common_tags = {
    Project     = var.project
    Service     = var.service
    Environment = local.environment_mapped
  }
}
