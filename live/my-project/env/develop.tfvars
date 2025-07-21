# develop.tfvars

# Réseau (Network)
# Internet Gateway, NAT Gateways, and route tables.
vpc_cidr            = "10.0.0.0/16"          # CIDR block for the VPC
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"] # CIDR blocks for public subnets
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"] # CIDR blocks for private subnets
vpc_id  = "vpc-0123456789abcdef0" # Placeholder VPC ID, typically dynamically created or looked up


# Projet (Project)
project     = "HolisticX" # Name of the project
environment = "develop"    # Current deployment environment

# Taille de l'infrastructure (Infrastructure Size)
# This variable influences the sizing of resources (e.g., instance types) via the 'variables' module.
size = "small"

# EC2 SSH
ssh_key_name     = "my-dev-key" # SSH key pair name for EC2 instances
allowed_ssh_cidr = ["0.0.0.0/0"] # CIDR blocks allowed to SSH into instances (should be restricted in production)

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
  keycloak = {
    name                  = "keycloak"
    cpu                   = 256
    memory                = 512
    desired_count         = 1
    port                  = 8084
    lifecycle_policy_path = "policies/keycloak-lifecycle.json"
  }
}
# NOT IMPORTANT FOR DEVELOP
###

# ALB target for API Gateway
# This variable defines the DNS name of the Application Load Balancer.
alb_dns_name = "alb-dev.myproject.local" # Replace with actual dev ALB DNS

# API Gateway routes
# This map defines the path-based routing for API Gateway, mapping paths to target URLs (ALB endpoints).
api_routes = {
  "agenticx" = {
    path       = "/agenticx"
    target_url = "http://${alb_dns_name}/agenticx"
  },
  "backoffice" = {
    path       = "/backoffice"
    target_url = "http://${alb_dns_name}/backoffice"
  },

  "nextjs" = {
    path       = "/nextjs"
    target_url = "http://${alb_dns_name}/nextjs"
  },
  "spring-gateway" = {
    path       = "/gateway"
    target_url = "http://${alb_dns_name}/gateway"
  },
  "keycloak" = {
    path       = "/keycloak"
    target_url = "http://${alb_dns_name}/keycloak"
  },
}

# RDS Database
# These variables configure the PostgreSQL RDS instance via the 'rds' module (modules/rds/main.tf).
db_names    = ["agenticx_db", "backoffice_db", "keycloak_db"] # Names of the databases
db_username = "myuser"     # Master username for the database
db_password = "CHANGE_ME_TO_A_SECURE_PASSWORD" # Master password (sensitive)

# ACM Certificate
# This variable is used by the 'alb' module (modules/alb/main.tf) for HTTPS certificate.
domain_name = "dev.my-cool-app.com" # Domain name for the ACM certificate

# RDS Multi-AZ
# This variable controls whether Multi-AZ deployment is enabled for RDS.
rds_multi_az_enabled = false

# RDS Backup S3 Bucket Name
# This variable specifies the name of the S3 bucket used for RDS backups.
# It is used by the 'iam' module (modules/iam/main.tf) for IAM policy and by the 'rds' module (modules/rds/main.tf) to create the bucket.
rds_backup_s3_bucket_name = "my-dev-rds-backup-bucket" # Replace with your desired S3 bucket name for RDS backups
