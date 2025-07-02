# Réseau
vpc_cidr            = "10.1.0.0/16"
public_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24"]

# Projet
project     = "my-project"

# Taille de l'infrastructure
size = "medium"

# EC2
ssh_key_name     = "my-uat-key"
allowed_ssh_cidr = ["102.120.45.0/24"] # Restrict access to a specific CIDR block, e.g., your corporate network

# SonarQube
sonarqube_ami_id = "ami-12345678" # Replace with actual AMI ID
sonarqube_instance_type = "t2.medium"

# ClickHouse
clickhouse_ami_id = "ami-87654321"
clickhouse_instance_type = "t2.medium" # Replace with actual AMI ID