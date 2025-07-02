# Réseau
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]

# Projet
project     = "my-project"
environment = "develop"         # Environment name, e.g., "uat", "prod",

# Taille de l'infrastructure
size = "small"

# EC2
ssh_key_name     = "my-dev-key"
allowed_ssh_cidr = ["0.0.0.0/0"] # Restrict access to a specific CIDR block, e.g., your corporate network

# SonarQube
sonarqube_ami_id = "ami-12345678" # Replace with actual AMI ID

# ClickHouse
clickhouse_ami_id = "ami-87654321" # Replace with actual AMI ID
