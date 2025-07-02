# My Terraform Project (test branch)

This project demonstrates a Terraform setup with:
- **modules/** for reusable components (network, compute, kubernetes, database)
- **live/** for environment-specific configs using workspaces (develop, uat, preprod, prod)

## Usage
```bash
cd live/my-project
./scripts/init.sh develop
terraform apply -var-file="env/develop.tfvars"
```
