# Databricks Serverless Workspace Terraform Project

This Terraform project creates a Databricks serverless workspace in AWS. Serverless workspaces are a new offering that eliminate the need for managing credentials and storage configurations.

## Key Features

- Creates a fully functional serverless Databricks workspace
- Offers two deployment options:
  - Option 1: No network configuration (simpler deployment)
  - Option 2: With PrivateLink setup for enhanced security
- Includes Network Connectivity Configuration (NCC) for improved network performance
- Assigns Unity Catalog metastore
- Creates and manages catalogs with proper permissions
- Sets up users and Git repositories
- Uses the latest Databricks provider (v1.77+)

## Modular Structure

The project is organized into modules to separate account-level resources (using the `databricks.mws` provider) from workspace-level resources (using the `databricks.workspace` provider). This makes maintenance easier and follows best practices.

### Directory Structure

```
quickstart-serverlessonly/
├── main.tf                 # Main module that connects the sub-modules
├── variables.tf            # Variables used by the main module
├── outputs.tf              # Outputs from both sub-modules
├── provider.tf             # Provider configurations
├── serverless.auto.tfvars  # Variable values
├── account_resources/      # Account-level resources (uses databricks.mws provider)
│   ├── main.tf             # Account-level resources configuration
│   ├── variables.tf        # Variables for account-level resources
│   ├── outputs.tf          # Outputs from account-level resources
│   └── providers.tf        # Provider configuration for account-level resources
└── workspace_resources/    # Workspace-level resources (uses databricks.workspace provider)
    ├── main.tf             # Workspace-level resources configuration
    ├── variables.tf        # Variables for workspace-level resources 
    ├── outputs.tf          # Outputs from workspace-level resources
    └── providers.tf        # Provider configuration for workspace-level resources
```

## Prerequisites

- Terraform 1.0.0+
- AWS CLI configured
- Databricks account with admin privileges
- Existing Unity Catalog metastore

## Architecture Overview

The serverless workspace has the following key components:

1. **Serverless Workspace** (Account-level): Created with `compute_mode = "SERVERLESS"` which eliminates the need for credentials and storage configurations
2. **Network Configuration** (Account-level, Optional): VPC with public and private subnets, with PrivateLink setup
3. **Security** (Account-level): Security groups for workspace and VPC endpoints (when network configuration is enabled)
4. **Unity Catalog** (Workspace-level): Assignment of existing metastore and creation of a default catalog
5. **User Management** (Workspace-level): Admin users with appropriate permissions
6. **Git Integration** (Workspace-level): Optional Git repository setup

## Deployment Options

This project offers two deployment options:

### Option 1: No Network Configuration

This is the simplest deployment option with minimal AWS resources. Set `create_network_config = false` in your tfvars file.

### Option 2: With PrivateLink Setup (Default)

This deploys a workspace with a secure PrivateLink network configuration. Set `create_network_config = true` (default) in your tfvars file.

## Quick Start

1. Clone this repository
2. Copy `serverless.auto.tfvars.example` to `serverless.auto.tfvars` and fill in your specific values
3. Choose your deployment option by editing the `create_network_config` setting
4. Initialize Terraform:
   ```shell
   terraform init
   ```
5. Plan your deployment:
   ```shell
   terraform plan
   ```
6. Apply the configuration:
   ```shell
   terraform apply
   ```

## Important Configuration Parameters

### Serverless Specific Configuration
The key setting that makes this a serverless workspace is:
```hcl
compute_mode = "SERVERLESS"
```

Unlike standard workspaces, serverless workspaces:
- Do not require credentials_id
- Do not require storage_configuration_id
- Simplify workspace management

### Required Variables

| Variable | Description |
|----------|-------------|
| `databricks_account_id` | Your Databricks Account ID |
| `client_id` | Service principal client ID |
| `client_secret` | Service principal client secret |
| `aws_region` | AWS region for deployment |
| `aws_account_id` | Your AWS account ID |
| `metastore_id` | Existing Unity Catalog metastore ID |
| `create_network_config` | Whether to create network configuration (true/false) |

## Unity Catalog Configuration

The workspace automatically assigns the specified metastore and can create a default catalog:

```hcl
create_default_catalog = true
default_catalog_name = "serverless_catalog"
```

Admin users are granted full permissions to the catalog:

```hcl
admin_users = ["admin1@example.com", "admin2@example.com"]
```

## Security Considerations

- Service principal credentials should not be stored in the `.tfvars` file for production environments
- Consider using AWS Secrets Manager or environment variables for sensitive information
- For enhanced security, use Option 2 (with PrivateLink setup)

## Terraform State Management

For production use, it's recommended to configure remote state storage using S3 and DynamoDB for state locking.

## Outputs

After successful deployment, you'll get the following outputs:
- Workspace ID and URL
- VPC and subnet IDs (if network configuration is enabled)
- Security group IDs (if network configuration is enabled)
- Catalog name
- Git repository ID (if created)

## Notes

- Serverless workspaces are billed differently than standard workspaces
- Check Databricks documentation for up-to-date pricing information

## License

This project is licensed under the MIT License - see the LICENSE file for details. 