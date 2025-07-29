# preprod.tfvars

# Réseau (Network)
# Internet Gateway, NAT Gateways, and route tables.
vpc_cidr            = "10.2.0.0/16"          # CIDR block for the VPC
public_subnet_cidrs = ["10.2.1.0/24", "10.2.2.0/24"] # CIDR blocks for public subnets
private_subnet_cidrs = ["10.2.3.0/24", "10.2.4.0/24"] # CIDR blocks for private subnets

# Projet (Project)
project     = "HolisticX" # Name of the project
environment = "preprod"    # Current deployment environment

# ECS Fargate services configuration (each service’s CPU, memory, etc.)
ecs_services = {
  agenticx = {
    name                  = "agenticx"
    cpu                   = 512
    memory                = 1024
    desired_count         = 2
    port                  = 8070
    lifecycle_policy_path = "policies/agenticx-lifecycle.json"
  },
  analyticx = {
    name                  = "analyticx"
    cpu                   = 512
    memory                = 1024
    desired_count         = 2
    port                  = 8060
    lifecycle_policy_path = "policies/analyticx-lifecycle.json"
  },
  "spring-gateway" = {
    name                  = "spring-gateway"
    cpu                   = 512
    memory                = 1024
    desired_count         = 2
    port                  = 8222
    lifecycle_policy_path = "policies/agenticx-lifecycle.json"
  },
  nextjs = {
    name                  = "nextjs"
    cpu                   = 512
    memory                = 1024
    desired_count         = 2
    port                  = 3000
    lifecycle_policy_path = "policies/nextjs-lifecycle.json"
  },
  consul = {
    name                  = "consul"
    cpu                   = 512
    memory                = 1024
    desired_count         = 2
    port                  = 8888 # Default Consul HTTP API port
    lifecycle_policy_path = "policies/consul-lifecycle.json"
  },
  "user-management" = {
    name                  = "user-management"
    cpu                   = 512
    memory                = 1024
    desired_count         = 2
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
domain_name = "preprod.holisticx.com" 

# RDS Multi-AZ
# This variable controls whether Multi-AZ deployment is enabled for RDS.
rds_multi_az_enabled = true

# RDS Backup S3 Bucket Name
# This variable specifies the name of the S3 bucket used for RDS backups.
rds_backup_s3_bucket_name = "my-preprod-rds-backup-bucket"

enable_waf = true