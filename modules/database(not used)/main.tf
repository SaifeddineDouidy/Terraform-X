resource "aws_dynamodb_table" "this" {
  name         = "${var.name_prefix}-table"
  billing_mode = "PROVISIONED"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  tags           = { Name = "${var.name_prefix}-table" }
}