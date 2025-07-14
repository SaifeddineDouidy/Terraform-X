# develop.tfvars

# Réseau
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]

# Projet
project     = "my-project"
environment = "develop"

# Taille de l'infrastructure
size = "small"

# EC2 SSH
ssh_key_name     = "my-dev-key"
allowed_ssh_cidr = ["0.0.0.0/0"]

# SonarQube
sonarqube_ami_id = "ami-12345678"

# ClickHouse
clickhouse_ami_id = "ami-87654321"

# ECS Fargate services configuration (each service’s CPU, memory, etc.)
ecs_services = [
  {
    name          = "agenticx"
    cpu           = 256
    memory        = 512
    desired_count = 1
    port          = 8080
  },
  {
    name          = "backoffice"
    cpu           = 256
    memory        = 512
    desired_count = 1
    port          = 8080
  },
  {
    name          = "quality-control"
    cpu           = 256
    memory        = 512
    desired_count = 1
    port          = 8080
  },
  {
    name          = "keycloak"
    cpu           = 256
    memory        = 512
    desired_count = 1
    port          = 8080
  },
  {
    name          = "consul"
    cpu           = 128
    memory        = 256
    desired_count = 1
    port          = 8500
  },
  {
    name          = "nextjs"
    cpu           = 256
    memory        = 512
    desired_count = 1
    port          = 8080
  }
]

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
