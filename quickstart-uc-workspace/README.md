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

### Solving the Provider Configuration Challenge
Databricks Terraform deployments face a fundamental challenge:

1. To create workspace-level resources (sqlwarehouse; catalog; external location), you need a workspace-level provider
2. The workspace-level provider needs the workspace URL --> **But** the workspace URL is only known after the workspace is created
This creates a circular dependency that can't be resolved with typical Terraform approaches.

Our solution uses a two-phase approach:
1. **Phase 1**: Create the workspace using the root account-level provider
2. **Update**: Add the workspace URL to the Terraform variables after the first run
3. **Phase 2**: The module uses its internal provider configuration to create workspace-level resources

This approach eliminates the need for complex `for_each` loops and locals maps that typically can't work with provider configurations.

### Why Not Use `for_each` with Locals?
A common pattern in Terraform is to use locals with `for_each` to create multiple similar resources. However, this approach fails with Databricks workspaces because:

1. Terraform doesn't allow using `for_each` with modules that configure their own providers
2. Workspace URLs are only known after creation, creating a circular dependency
3. Provider configurations must be known during Terraform init, before any resources are created

Our approach resolves these issues by:
1. Creating separate, explicit module calls for each workspace
2. Managing provider configuration within the module
3. Using a two-phase deployment with workspace URL variable updates between phases

## Usage

### Initial Setup
1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd databricks-multi-workspace
   ```

2. **Configure Variables**
   - Copy `test.auto.tfvars_example` to `terraform.auto.tfvars`
   - Update the variable values to match your environment

3. **Initialize Terraform**
   ```bash
   terraform init
   ```

4. **Deploy Phase 1: Create Workspaces**
   ```bash
   terraform validate && terraform plan
   terraform apply
   ```

### Adding a New Workspace
To add a new workspace (e.g., Staging):

1. Add new variables in `variables.tf` with a  new (eg: `staging_`) prefix
2. Add a new module call in `main.tf`:
   ```hcl
   module "databricks_workspace_staging" {
     source = "./modules/databricks_workspace_full_creation"
     # ... configuration for staging workspace
   }
   ```
3. Add outputs in `outputs.tf`
4. Update your `terraform.auto.tfvars` with the staging configuration

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