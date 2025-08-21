# Databricks Multi-Workspace Terraform

## Introduction
This project offers a practical solution for deploying and managing multiple Databricks workspaces using Terraform. It addresses common challenges that arise when trying to automate Databricks deployments, particularly the circular dependency issues with provider configuration.

Many Terraform users encounter difficulties when creating multiple Databricks workspaces, especially when dealing with workspace-level resources that require different provider configurations. This solution provides a clean, modular approach that makes multi-workspace deployments more manageable without overly complex code structures.


## Key Features
- Deploy multiple Databricks workspaces (Dev, Prod) with separate AWS infrastructure
- Self-contained module architecture that handles the provider configuration challenge
- Unity Catalog integration for each workspace
- User permission management across workspaces
- External location and Git repository configuration
- Comprehensive variable management for workspace-specific settings

## Architecture
The project uses a comprehensive module approach with the `databricks_workspace_full_creation` module as the core building block. This module encapsulates all resources needed for a complete workspace:

```
databricks_workspace_full_creation
├── AWS Resources (VPC, Security Groups, Subnets, etc.)
├── Workspace Creation
├── Workspace Provider Configuration 
├── User Assignment
├── External Locations
└── Git Repository Configuration
```
### Why Not Use `for_each` with Locals?
A common pattern in Terraform is to use locals with `for_each` to create multiple similar resources. However, this approach fails with Databricks workspaces because:

1. Terraform doesn't allow using `for_each` with modules that configure their own providers
2. Workspace URLs are only known after creation, creating a circular dependency
3. Provider configurations must be known during Terraform init, before any resources are created

Our approach resolves these issues by:
1. Creating separate, explicit module calls for each workspace
2. Managing provider configuration within the module
3. Using a two-phase deployment with workspace URL variable updates between phases


## Module Structure
- **main.tf**: Contains the core workspace module calls
- **variables.tf**: Defines all variables for the root module
- **providers.tf**: Configures AWS and Databricks providers
- **outputs.tf**: Defines outputs for all workspaces
- **modules/databricks_workspace_full_creation**: Core module for workspace deployment
- **modules/submodules/**: Collection of submodules for specific functions:
  - aws_resources: AWS infrastructure
  - workspace_creation: Databricks workspace
  - db_assign_account_users: User management
  - external_location: S3 bucket integration
  - databricks_repo: Git repository configuration
  - unity_catalog: Metastore configuration
  - And other utility modules

## Reference
- [Databricks official terraform-databricks-examples](https://github.com/databricks/terraform-databricks-examples/tree/main)
- [Security Reference Architectures (SRA)](https://github.com/databricks/terraform-databricks-sra)