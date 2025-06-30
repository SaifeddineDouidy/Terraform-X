# Réseau
vpc_cidr            = "10.2.0.0/16"
public_subnet_cidrs = ["10.2.1.0/24", "10.2.2.0/24"]

# Projet et Environnement
project     = "my-project"
# environment sera injecté via le workspace Terraform (preprod ou prod)

# Taille de l'infrastructure
# Cela donnera t2.large ou t2.xlarge + 3 à 5 noeuds EKS + DynamoDB 50 à 100 RCU/WCU
size = "large"

# EC2
ssh_key_name     = "my-prod-key"
allowed_ssh_cidr = ["192.168.0.0/24"]  # restreint à une plage privée/VPN sécurisé
