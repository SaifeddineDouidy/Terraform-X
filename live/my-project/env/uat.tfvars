# uat.tfvars

# Réseau
vpc_cidr            = "10.1.0.0/16"
public_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.3.0/24", "10.1.4.0/24"]

# Projet
project     = "my-project"
environment = "uat"

# Taille de l'infrastructure
size = "small"

# EC2 SSH
ssh_key_name     = "my-uat-key"
allowed_ssh_cidr = ["102.120.45.0/24"]

# SonarQube
sonarqube_ami_id = "ami-12345678"

# ClickHouse
clickhouse_ami_id = "ami-87654321"

# ECS Fargate services configuration (each service’s CPU, memory, etc.)
ecs_services = [
  {
    name          = "agenticx"
    cpu           = 512
    memory        = 1024
    desired_count = 1
    port          = 8080
  },
  {
    name          = "backoffice"
    cpu           = 512
    memory        = 1024
    desired_count = 1
    port          = 8080
  },
  {
    name          = "quality-control"
    cpu           = 512
    memory        = 1024
    desired_count = 1
    port          = 8080
  },
  {
    name          = "keycloak"
    cpu           = 512
    memory        = 1024
    desired_count = 1
    port          = 8080
  },
  {
    name          = "consul"
    cpu           = 256
    memory        = 512
    desired_count = 1
    port          = 8500
  },
  {
    name          = "nextjs"
    cpu           = 512
    memory        = 1024
    desired_count = 1
    port          = 8080
  }
]

# ALB target for API Gateway
alb_dns_name = "alb-uat.myproject.local" # Replace with actual UAT ALB DNS

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

