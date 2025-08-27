terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket-name"
    key            = "my-project/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "your-terraform-lock-table-name"
    encrypt        = true
  }
}