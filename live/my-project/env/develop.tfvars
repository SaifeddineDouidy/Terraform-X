# develop.tfvars

# Réseau
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
service = "my-project-app"
vpc_id  = "vpc-0123456789abcdef0"


# Projet
project     = "my-project"
environment = "develop"

# Taille de l'infrastructure
size = "small"

# EC2 SSH
ssh_key_name     = "my-dev-key"
allowed_ssh_cidr = ["0.0.0.0/0"] # This should be actual IP addresses of those we wanna give ec2 access to

# SonarQube
sonarqube_ami_id = "ami-12345678"

# ClickHouse
clickhouse_ami_id = "ami-87654321"

# ECS Fargate services configuration (each service’s CPU, memory, etc.)
ecs_services = {
  agenticx = {
    name = "agenticx"
    cpu           = 256
    memory        = 512
    desired_count = 1
    port          = 8081
    lifecycle_policy_path = "policies/agenticx-lifecycle.json"
    secrets = {}
  }
  backoffice = {
    name = "backoffice"
    cpu           = 256
    memory        = 512
    desired_count = 1
    port          = 8082
    lifecycle_policy_path = "policies/backoffice-lifecycle.json"
    secrets = {}
  }
  quality-control = {
    name = "quality-control"
    cpu           = 256
    memory        = 512
    desired_count = 1
    port          = 8083
    lifecycle_policy_path = "policies/quality-control-lifecycle.json"
    secrets = {}
  }
  keycloak = {
    name = "keycloak"
    cpu           = 256
    memory        = 512
    desired_count = 1
    port          = 8084
    lifecycle_policy_path = "policies/keycloak-lifecycle.json"
    secrets = {}
  }
  consul = {
    name = "consul"
    cpu           = 128
    memory        = 256
    desired_count = 1
    port          = 8500
    lifecycle_policy_path = "policies/consul-lifecycle.json"
    secrets = {}
  }
  nextjs = {
    name = "nextjs"
    cpu           = 256
    memory        = 512
    desired_count = 1
    port          = 8085
    lifecycle_policy_path = "policies/nextjs-lifecycle.json"
    secrets = {}
  }
}


# ALB target for API Gateway
alb_dns_name = "alb-dev.myproject.local" # Replace with actual dev ALB DNS

api_routes = {
  "agenticx" = {
    path       = "/agenticx"
    target_url = "http://${alb_dns_name}/agenticx"
  },
  "backoffice" = {
    path       = "/backoffice"
    target_url = "http://${alb_dns_name}/backoffice"
  },
  "quality-control" = {
    path       = "/quality-control"
    target_url = "http://${alb_dns_name}/quality-control"
  },
  "keycloak" = {
    path       = "/keycloak"
    target_url = "http://${alb_dns_name}/keycloak"
  },
  "consul" = {
    path       = "/consul"
    target_url = "http://${alb_dns_name}/consul"
  },
  "nextjs" = {
    path       = "/nextjs"
    target_url = "http://${alb_dns_name}/nextjs"
  }
}

# RDS Database
db_name     = "mydatabase"
db_username = "myuser"
db_password = "CHANGE_ME_TO_A_SECURE_PASSWORD"

# DocumentDB
docdb_master_username = "docdbadmin"
docdb_master_password = "CHANGE_ME_TO_A_DIFFERENT_SECURE_PASSWORD"

# ACM Certificate
domain_name = "dev.my-cool-app.com" # CHANGE_ME to your actual domain

rds_multi_az_enabled = false
