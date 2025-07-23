terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.20.0"
    }
  }
}
provider "aws" {
  # region = var.aws_region
  region                      = "us-east-1"
  access_key                  = "foo"
  secret_key                  = "bar"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_requesting_account_id  = true

  default_tags {
    tags = local.common_tags
  }
}

