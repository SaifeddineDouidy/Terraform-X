# Réseau
vpc_cidr            = "10.3.0.0/16"
public_subnet_cidrs = ["10.3.1.0/24", "10.3.2.0/24"]

# Projet
project     = "my-project"

# Taille de l'infrastructure
size = "large"

# EC2
ssh_key_name     = "my-prod-key"
allowed_ssh_cidr = ["192.168.0.0/24"] # Restrict access to a specific CIDR block, e.g., your corporate network

# ClickHouse
clickhouse_ami_id = "ami-87654321" # Replace with actual AMI ID
clickhouse_instance_type = "t3.large"