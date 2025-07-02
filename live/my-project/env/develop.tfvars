# Réseau
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]

# Projet et Environnement
project     = "my-project"
environment = "Dev"

# Taille de l'infrastructure
# Cela déterminera instance_type = t4g.small, 1 noeud EKS, etc.
# via le module variables
size = "small"

service = "project-x"

# EC2
ssh_key_name     = "my-dev-key"       # la clé SSH générée sur AWS
allowed_ssh_cidr = ["0.0.0.0/0"]        # autorisé dans les environnements dev uniquement
