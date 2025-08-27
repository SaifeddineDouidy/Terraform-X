# Terraform AWS Infrastructure Project

This repository contains Terraform code to provision a scalable and modular infrastructure on AWS, designed to run containerized microservices using ECS Fargate, RDS, and other core AWS services. The entire process is automated via a CI/CD pipeline with GitHub Actions.

## Prerequisites

Before you begin, ensure you have the following tools installed:

*   [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) (v1.12.1 or as specified in `github/workflows/terraform.yml`)
*   [AWS CLI](https://aws.amazon.com/cli/)
*   [Infracost](https://www.infracost.io/docs/user_group/v0.10/installation/) (Optional, for local cost estimation)

## Project Structure

The project is organized into two main directories:

-   `modules/`: Contains reusable Terraform modules for each piece of the infrastructure (e.g., `vpc`, `ecs_fargate`, `rds`). This promotes code reuse and maintainability.
-   `live/`: Contains the environment-specific configurations that consume the modules.
    -   `my-project/`: The root directory for a specific deployment (e.g., this project).
        -   `main.tf`, `variables.tf`, `outputs.tf`: The main Terraform configuration files.
        -   `backend.tf`: The configuration for the Terraform remote state backend.
        -   `env/`: Contains the variable definition files (`.tfvars`) for each environment.

## Initial Setup

Follow these steps to configure the project for your own AWS account.

### 1. Configure AWS Credentials

Ensure your AWS CLI is configured with credentials that have sufficient permissions to create the resources defined in this project. The simplest way is to configure your `~/.aws/credentials` file:

```ini
[default]
aws_access_key_id = YOUR_ACCESS_KEY
aws_secret_access_key = YOUR_SECRET_KEY
```

### 2. Configure the Terraform Backend

The Terraform state is stored remotely in an S3 bucket to ensure state persistence and enable collaboration.

1.  **Create an S3 Bucket and a DynamoDB Table:** In your AWS account, create a globally unique S3 bucket to store the `terraform.tfstate` file and a DynamoDB table for state locking (to prevent concurrent modifications).
2.  **Update `backend.tf`:** Open `live/my-project/backend.tf` and replace the placeholder values with the names of the resources you just created.

    ```terraform
    # live/my-project/backend.tf
    terraform {
      backend "s3" {
        bucket         = "your-terraform-state-bucket-name"  # <-- REPLACE
        key            = "my-project/terraform.tfstate"
        region         = "eu-north-1" # Or your preferred region
        dynamodb_table = "your-terraform-lock-table-name" # <-- REPLACE
        encrypt        = true
      }
    }
    ```

### 3. Create Your Environment Variables File

This project uses `.tfvars` files to manage environment-specific variables. An example file is provided.

1.  Navigate to the `live/my-project/env/` directory.
2.  Copy the example file to create your own `develop.tfvars` file:
    ```shell
    cp develop.tfvars.example develop.tfvars
    ```
3.  Open the new `develop.tfvars` file and replace the placeholder values with your own configurations (e.g., your domain name, desired database username, etc.).

**Important:** The `.gitignore` file is configured to ignore `*.tfvars` files. **Never commit files containing sensitive variables to your repository.**

## Local Usage

All Terraform commands should be run from the `live/my-project` directory.

```shell
cd live/my-project
```

### Initialize Terraform
This command initializes the backend, downloads providers, and modules.
```shell
terraform init
```

### Select a Workspace
We use Terraform workspaces to manage different environments.
```shell
# Select the 'develop' workspace (or create it with 'terraform workspace new develop')
terraform workspace select develop
```

### Plan Changes
This command creates an execution plan, showing you what changes will be made without actually applying them.
```shell
terraform plan -var-file="env/develop.tfvars"
```

### Apply Changes
After reviewing the plan, apply the changes to your AWS account.
```shell
terraform apply -var-file="env/develop.tfvars"
```

## CI/CD with GitHub Actions

The CI/CD pipeline is defined in `.github/workflows/terraform.yml`. It is configured to run on every push to the `main` branch.

The pipeline performs the following steps:
1.  **Checkout & Setup:** Checks out the code and sets up Terraform.
2.  **Authentication:** Configures AWS credentials using secrets stored in GitHub.
3.  **Validation:** Runs `terraform fmt`, `init`, and `validate` to ensure code quality and correctness.
4.  **Plan:** Generates a `terraform plan` for the `develop` environment.
5.  **Cost Estimation:** Runs `infracost` on the plan to estimate the monthly cost of the changes.

**Note:** The pipeline is currently configured for planning and validation only. The `terraform apply` step is not automated and must be run manually after reviewing the plan.