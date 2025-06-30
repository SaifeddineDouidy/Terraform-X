#!/bin/bash
ENVIRONMENT=$1
if [ -z "$ENVIRONMENT" ]; then
  echo "Usage: $0 <workspace-name>"
  exit 1
fi
terraform init \
  -backend-config="bucket=my-terraform-state-bucket" \
  -backend-config="key=my-project/${ENVIRONMENT}.tfstate" \
  -backend-config="region=us-east-1" \
  -backend-config="dynamodb_table=my-terraform-locks"
if terraform workspace list | grep -qw "$ENVIRONMENT"; then
  terraform workspace select "$ENVIRONMENT"
else
  terraform workspace new "$ENVIRONMENT"
fi
echo "Using Terraform workspace: $(terraform workspace show)"