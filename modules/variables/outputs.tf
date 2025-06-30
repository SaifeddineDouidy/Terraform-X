output "instance_type" {
  value = var.instance_type_map[var.size]
}

output "node_count" {
  value = var.node_count_map[var.size]
}

output "dynamodb_read_capacity" {
  value = var.dynamodb_read_capacity_map[var.size]
}

output "dynamodb_write_capacity" {
  value = var.dynamodb_write_capacity_map[var.size]
}