# Réseau
vpc_cidr            = "10.1.0.0/16"
public_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24"]

# Projet et Environnement
project     = "my-project"
environment = "Stage-UAT"  # Nom de l'environnement, utilisé pour le workspace Terraform

# Taille de l'infrastructure
# Cela donnera t2.medium + 2 noeuds EKS + DynamoDB 20 RCU/WCU
size = "medium"

service = "project-x"

# EC2
ssh_key_name     = "my-uat-key"
allowed_ssh_cidr = ["102.120.45.0/24"]  # restreint à ton IP ou VPN d’entreprise
