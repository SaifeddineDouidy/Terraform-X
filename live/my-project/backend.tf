terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "my-project/${terraform.workspace}.tfstate"
    region         = "us-east-1"
    dynamodb_table = "my-terraform-locks"
    encrypt        = true
  }
}