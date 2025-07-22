# develop.tfvars

# Réseau (Network)
# Internet Gateway, NAT Gateways, and route tables.
vpc_cidr            = "10.0.0.0/16"          # CIDR block for the VPC
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"] # CIDR blocks for public subnets
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"] # CIDR blocks for private subnets

keycloak_public_subnet_cidrs  = ["10.0.5.0/24"]
keycloak_private_subnet_cidrs = ["10.0.6.0/24"]


# Projet (Project)
project     = "HolisticX" # Name of the project
environment = "develop"    # Current deployment environment

# Taille de l'infrastructure (Infrastructure Size)
# This variable influences the sizing of resources (e.g., instance types) via the 'variables' module.
# size = "small"

# EC2 SSH
# allowed_ssh_cidr = ["0.0.0.0/0"] # CIDR blocks allowed to SSH into instances (should be restricted in production)

# ECS Fargate services configuration (each service’s CPU, memory, etc.)
ecs_services = {
  agenticx = {
    name                  = "agenticx"
    cpu                   = 256
    memory                = 512
    desired_count         = 1
    port                  = 8081
    lifecycle_policy_path = "policies/agenticx-lifecycle.json"
  },
  backoffice = {
    name                  = "backoffice"
    cpu                   = 256
    memory                = 512
    desired_count         = 1
    port                  = 8082
    lifecycle_policy_path = "policies/backoffice-lifecycle.json"
  },
  spring-gateway = {
    name                  = "spring-gateway"
    cpu                   = 256
    memory                = 512
    desired_count         = 1
    port                  = 8080
    lifecycle_policy_path = "policies/agenticx-lifecycle.json"
  },
  nextjs = {
    name                  = "nextjs"
    cpu                   = 256
    memory                = 512
    desired_count         = 1
    port                  = 8085
    lifecycle_policy_path = "policies/nextjs-lifecycle.json"
  },
  consul = {
    name                  = "consul"
    cpu                   = 256
    memory                = 512
    desired_count         = 1
    port                  = 8500 # Default Consul HTTP API port
    lifecycle_policy_path = "policies/consul-lifecycle.json" # Assuming you have one or will create one
  }
}


# RDS Database
# These variables configure the PostgreSQL RDS instance via the 'rds' module (modules/rds/main.tf).
db_names    = ["agenticx_db", "backoffice_db"] # Names of the databases
db_username = "myuser"     # Master username for the database

# ACM Certificate
# This variable is used by the 'alb' module (modules/alb/main.tf) for HTTPS certificate.
domain_name = "holisticx.com" # Domain name for the ACM certificate

# RDS Multi-AZ
# This variable controls whether Multi-AZ deployment is enabled for RDS.
rds_multi_az_enabled = false

# RDS Backup S3 Bucket Name
# This variable specifies the name of the S3 bucket used for RDS backups.
# It is used by the 'iam' module (modules/iam/main.tf) for IAM policy and by the 'rds' module (modules/rds/main.tf) to create the bucket.
rds_backup_s3_bucket_name = "my-dev-rds-backup-bucket" # Replace with your desired S3 bucket name for RDS backups

keycloak_db_username = "keycloakuser"

enable_waf = false
