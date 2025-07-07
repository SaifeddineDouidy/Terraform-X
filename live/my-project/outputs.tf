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
output "eks_cluster_name" {
  value = module.kubernetes.cluster_name
}
output "ecr_repository_urls" {
  value = module.ecr.repository_urls
}
output "sonarqube_instance_id" {
  value = module.sonarqube.instance_id
}
output "clickhouse_instance_id" {
  value = module.clickhouse.instance_id
}
output "sonarqube_url" {
  value = module.sonarqube.instance_url
}
output "clickhouse_url" {
  value = module.clickhouse.instance_url
}
