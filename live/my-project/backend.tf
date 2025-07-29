terraform {
  backend "s3" {
    bucket  = "terraform-state-bucket-test-v1"
    key     = "my-project/terraform.tfstate"
    region  = "eu-north-1"
    encrypt = true
  }
}