terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.20.0"
    }
  }
}
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

