# prod.tfvars

# Réseau (Network)
# Internet Gateway, NAT Gateways, and route tables.
vpc_cidr            = "10.3.0.0/16"          # CIDR block for the VPC
public_subnet_cidrs = ["10.3.1.0/24", "10.3.2.0/24"] # CIDR blocks for public subnets
private_subnet_cidrs = ["10.3.3.0/24", "10.3.4.0/24"] # CIDR blocks for private subnets

# Production Keycloak cluster has its own dedicated network segments for isolation.
keycloak_public_subnet_cidrs  = ["10.3.5.0/24", "10.3.6.0/24"]
keycloak_private_subnet_cidrs = ["10.3.7.0/24", "10.3.8.0/24"]

# Projet (Project)
project     = "HolisticX" # Name of the project
environment = "prod"    # Current deployment environment

# ECS Fargate services configuration (each service’s CPU, memory, etc.)
ecs_services = {
  agenticx = {
    name                  = "agenticx"
    cpu                   = 1024
    memory                = 2048
    desired_count         = 3
    port                  = 8070
    lifecycle_policy_path = "policies/agenticx-lifecycle.json"
  },
  analyticx = {
    name                  = "analyticx"
    cpu                   = 1024
    memory                = 2048
    desired_count         = 3
    port                  = 8060
    lifecycle_policy_path = "policies/analyticx-lifecycle.json"
  },
  "spring-gateway" = {
    name                  = "spring-gateway"
    cpu                   = 1024
    memory                = 2048
    desired_count         = 3
    port                  = 8222
    lifecycle_policy_path = "policies/agenticx-lifecycle.json"
  },
  nextjs = {
    name                  = "nextjs"
    cpu                   = 1024
    memory                = 2048
    desired_count         = 3
    port                  = 3000
    lifecycle_policy_path = "policies/nextjs-lifecycle.json"
  },
  consul = {
    name                  = "consul"
    cpu                   = 1024
    memory                = 2048
    desired_count         = 3
    port                  = 8888 # Default Consul HTTP API port
    lifecycle_policy_path = "policies/consul-lifecycle.json"
  },
  "user-management" = {
    name                  = "user-management"
    cpu                   = 1024
    memory                = 2048
    desired_count         = 3
    port                  = 8050 # Default Consul HTTP API port
    lifecycle_policy_path = "policies/user-management-lifecycle.json"
  }
}

# RDS Database
# These variables configure the PostgreSQL RDS instance via the 'rds' module (modules/rds/main.tf).
db_names    = ["agenticx_db", "analyticx_db"] # Names of the databases
db_username = "myuser"     # Master username for the database

# ACM Certificate
# This variable is used by the 'alb' module (modules/alb/main.tf) for HTTPS certificate.
domain_name = "holisticx.com" 

# RDS Multi-AZ
# This variable controls whether Multi-AZ deployment is enabled for RDS.
rds_multi_az_enabled = true

# RDS Backup S3 Bucket Name
# This variable specifies the name of the S3 bucket used for RDS backups.
rds_backup_s3_bucket_name = "my-prod-rds-backup-bucket"

# Keycloak is enabled and configured for high availability in the production environment.
# This points to a separate, robust Keycloak cluster.
keycloak_db_username = "keycloak_user_prod"

enable_waf = true

# Keycloak RDS - Production Configuration
# Using a more powerful instance class and larger storage for production load.
keycloak_db_instance_class      = "db.t4g.medium"
keycloak_db_allocated_storage   = 100
keycloak_db_engine              = "postgres"
keycloak_db_engine_version      = "16.8"
keycloak_db_multi_az_enabled    = true