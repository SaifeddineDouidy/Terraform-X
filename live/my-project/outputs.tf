output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "instance_id" {
  value = module.compute.instance_id
}

output "database_table_name" {
  value = module.database.table_name
}

output "eks_cluster_endpoint" {
  value = module.kubernetes.cluster_endpoint
}