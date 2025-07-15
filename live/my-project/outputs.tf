output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "instance_id" {
  value = module.compute.instance_id
}

output "rds_instance_endpoint" {
  description = "The connection endpoint for the RDS instance."
  value       = module.rds.db_instance_endpoint
}

output "rds_instance_port" {
  description = "The port on which the RDS instance is listening."
  value       = module.rds.db_instance_port
}

output "docdb_cluster_endpoint" {
  description = "The connection endpoint for the DocumentDB cluster."
  value       = module.documentdb.cluster_endpoint
}

output "docdb_cluster_port" {
  description = "The port on which the DocumentDB cluster is listening."
  value       = module.documentdb.cluster_port
}

/*output "eks_cluster_endpoint" {
  value = module.kubernetes.cluster_endpoint
}
output "eks_cluster_name" {
  value = module.kubernetes.cluster_name
}
*/

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

# --- Added ECS outputs ---

output "ecs_cluster_id" {
  description = "Id of the ECS cluster"
  value       = module.ecs.cluster_id
}
