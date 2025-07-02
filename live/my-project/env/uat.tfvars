# Réseau
vpc_cidr            = "10.1.0.0/16"
public_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24"]

# Projet
project     = "my-project" # Replace with your actual project name
environment = "uat"         # Environment name, e.g., "uat", "prod",

# Taille de l'infrastructure
size = "small"

# EC2
ssh_key_name     = "my-uat-key" # Replace with your actual SSH key name
allowed_ssh_cidr = ["102.120.45.0/24"] # Restrict access to a specific CIDR block, e.g., your corporate network

# SonarQube
sonarqube_ami_id = "ami-12345678" # Replace with actual AMI ID

# ClickHouse
clickhouse_ami_id = "ami-87654321"

lifecycle_policy = "{\n  \"rules\": [\n    {\n      \"rulePriority\": 1,\n      \"description\": \"Expire untagged images older than 14 days\",\n      \"selection\": {\n        \"tagStatus\": \"untagged\",\n        \"countType\": \"sinceImagePushed\",\n        \"countUnit\": \"days\",\n        \"countNumber\": 14\n      },\n      \"action\": {\n        \"type\": \"expire\"\n      }\n    }\n  ]\n}"