# quickstart-uc-workspace

## Introduction
This project provides a sample Terraform configuration to quickly set up and configure a Unity Catalog workspace. The configuration includes creating necessary AWS resources, the workspace, and assigning user permissions.

## Reference
- [Databricks official terraform-databricks-examples](https://github.com/databricks/terraform-databricks-examples/tree/main)
- [Security Reference Architectures (SRA)](https://github.com/databricks/terraform-databricks-sra)

## Usage

1. **Clone the project**
   ```bash
   git clone <repository-url>
   cd quickstart-uc-workspace
   ```
2. **Configure Terraform variables** 
    - Modify the values in the variables.tf or a terraform .tfvars file to suit your environment.

3. **Initialize Terraform**
   ```bash
    terraform init
   ```
4.	**Verify the plan output and apply the configuration**
   ```bash
    terraform plan
    terraform apply
   ```
## File Structure
```
quickstart-uc-workspace/
├── main.tf
├── variables.tf
├── provider.tf
├── aws_resources/
│   ├── outputs.tf
│   ├── aws_storage.tf
│   ├── aws_network_resources.tf
│   ├── aws_cross_acct_iam.tf
│   ├── variables.tf
│   ├── provider.tf
├── db_assign_account_users/
│   ├── assign_workspace_users.tf
│   ├── variables.tf
│   ├── provider.tf
├── db_create_account_users/
│   ├── create_account_group_user.tf
│   ├── variables.tf
│   ├── provider.tf
├── workspace_creation/
│   ├── outputs.tf
│   ├── variables.tf
│   ├── provider.tf
│   ├── workspace_creation.tf
├── external_location/
│   ├── external_location.tf
│   ├── variables.tf
│   ├── provider.tf
├── unity_catalog/
│   ├── outputs.tf
│   ├── variables.tf
│   ├── provider.tf
│   ├── uc_metastore.tf
├── workspace_compute/
│   ├── output.tf
│   ├── cluster.tf
│   ├── variables.tf
│   ├── provider.tf
├── databricks_job_task_sample/
│   ├── output.tf
│   ├── variables.tf
│   ├── static_tasks.tf
│   ├── provider.tf
│   ├── src/
│       ├── sample_notebook1.py
│       ├── sample_notebook2.py
│       ├── sample_notebook3.py
```

## File Descriptions Overview

 - main.tf: The main Terraform configuration file containing the primary resource definitions.
 - variables.tf: Defines Terraform variables.
 - provider.tf: Configures the Terraform provider information.
    - aws_resources/: TF module that contains configuration files related to AWS resources.
    - db_assign_account_users/: TF module that contains files for assigning workspace user permissions.
    - db_create_account_users/: TF module that contains configuration files for creating accounts and user groups.
    - workspace_creation/: TF module that contains configuration files for workspace creation.
    - external_location/: TF module that contains configuration files for external storage locations.
    - unity_catalog/: TF module that contains configuration files for Unity Catalog metastore.
    - workspace_compute/: TF module that contains configuration files for workspace compute resources.
    - databricks_job_task_sample/: TF module that contains sample configurations and scripts for Databricks job tasks.
