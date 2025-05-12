# AWS Region configuration
variable "aws_region" {
  type        = string
  description = "AWS region where resources will be created"
}

# AWS account configuration
variable "aws_account_id" {
  type        = string
  description = "AWS Account ID"
}

# Resource configuration
variable "resource_owner" {
  description = "Email addresses of the AWS resource owner"
  type        = string
}

variable "resource_prefix" {
  type        = string
  description = "Prefix for resource names"
  default     = ""
}

# Databricks authentication
variable "databricks_account_id" {
  type        = string
  description = "Databricks Account ID"
}

variable "client_id" {
  type        = string
  sensitive   = true
  description = "Client ID for Databricks service principal"
}

variable "client_secret" {
  type        = string
  sensitive   = true
  description = "Client Secret for Databricks service principal"
}

# User and permission variables
variable "databricks_users" {
  description = <<EOT
  List of Databricks users to be added at account-level for Unity Catalog.
  Enter with square brackets and double quotes
  e.g ["first.last@domain.com", "second.last@domain.com"]
  EOT
  type        = list(string)
}

variable "databricks_account_admins" {
  description = <<EOT
  List of Admins to be added at account-level for Unity Catalog.
  Enter with square brackets and double quotes
  e.g ["first.admin@domain.com", "second.admin@domain.com"]
  EOT
  type        = list(string)
}

# Unity Catalog variables
variable "unity_admin_group" {
  description = "Name of the admin group. This group will be set as the owner of the Unity Catalog metastore"
  type        = string
}

variable "metastore_id" {
  type        = string
  description = "ID of the metastore to use"
}

# Network configuration
variable "create_new_vpc" {
  type        = bool
  description = "Whether to create a new VPC or use existing one"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "workspace_rest_service" {
  description = "Region-specific VPC endpoint name for workspace and REST API."
  type        = string
}

variable "backend_relay" {
  description = "Region-specific VPC endpoint name for secure cluster connectivity relay."
  type        = string
}

# User assignment
variable "existing_acct_level_users" {
  description = "Map of users and their permissions"
  type        = map(list(string))
  default = {
    "user1@example.com" = ["ADMIN"],
    "user2@example.com" = ["USER"]
  }
}

# Git configuration
variable "git_provider" {
  type        = string
  description = "Git provider (e.g., github, gitlab, bitbucket)"
}

variable "git_branch" {
  type        = string
  description = "Branch of the Git repository"
}

variable "git_url" {
  type        = string
  description = "URL of the Git repository"
}

variable "git_username" {
  type        = string
  description = "Username for Git authentication"
}

variable "git_personal_access_token" {
  type        = string
  sensitive   = true
  description = "Personal access token for Git authentication"
}

# Audit logging configuration
variable "enable_audit_log_alerting" {
  type        = bool
  description = "Enable audit log alert."
  default     = false
}


# ----  Dev workspace specific variables  ---- #
variable "dev_default_catalog_name" {
  type        = string
  description = "Default catalog name"
}
variable "dev_workspace_url" {
  type        = string
  description = "URL of the Dev workspace (leave empty for new workspaces, set after first run)"
  default     = ""
}

variable "dev_resource_prefix" {
  type        = string
  description = "Resource prefix for Dev workspace"
}

variable "dev_workspace_deployment_name" {
  type        = string
  description = "Deployment name for Dev workspace"
}

variable "dev_vpc_cidr_range" {
  type        = string
  description = "CIDR range for Dev VPC"
  default     = "10.1.0.0/16"
}

variable "dev_public_subnets_cidr" {
  type        = list(string)
  description = "CIDR blocks for Dev public subnets"
  default     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
}

variable "dev_private_subnets_cidr" {
  type        = list(string)
  description = "CIDR blocks for Dev private subnets"
  default     = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]
}

variable "dev_workspace_allow_public_access" {
  type        = bool
  description = "Whether to allow public access to the Dev workspace"
  default     = false
}

variable "dev_pricing_tier" {
  type        = string
  description = "Pricing tier for Dev workspace"
  default     = "STANDARD"
}

variable "dev_external_s3_bucketname" {
  type        = string
  description = "S3 bucket for Dev external location"
  default     = ""
}

variable "dev_external_iam_rolename" {
  type        = string
  description = "IAM role for Dev external location"
  default     = ""
}

variable "dev_git_folder_path" {
  type        = string
  description = "Git folder path for Dev workspace"
  default     = "/Repos/github/dev-sandbox"
}

variable "dev_create_external_location" {
  type        = bool
  description = "Whether to create external location for Dev workspace"
  default     = false
}

# # ----  Prod workspace specific variables  ---- #
variable "prod_default_catalog_name" {
  type        = string
  description = "Default catalog name"
}

variable "prod_workspace_url" {
  type        = string
  description = "URL of the Prod workspace (leave empty for new workspaces, set after first run)"
  default     = ""
}

variable "prod_resource_prefix" {
  type        = string
  description = "Resource prefix for Prod workspace"
}

variable "prod_workspace_deployment_name" {
  type        = string
  description = "Deployment name for Prod workspace"
}

variable "prod_vpc_cidr_range" {
  type        = string
  description = "CIDR range for Prod VPC"
  default     = "10.3.0.0/16"
}

variable "prod_public_subnets_cidr" {
  type        = list(string)
  description = "CIDR blocks for Prod public subnets"
  default     = ["10.3.1.0/24", "10.3.2.0/24", "10.3.3.0/24"]
}

variable "prod_private_subnets_cidr" {
  type        = list(string)
  description = "CIDR blocks for Prod private subnets"
  default     = ["10.3.4.0/24", "10.3.5.0/24", "10.3.6.0/24"]
}

variable "prod_workspace_allow_public_access" {
  type        = bool
  description = "Whether to allow public access to the Prod workspace"
  default     = true
}

variable "prod_pricing_tier" {
  type        = string
  description = "Pricing tier for Prod workspace"
  default     = "ENTERPRISE"
}

variable "prod_external_s3_bucketname" {
  type        = string
  description = "S3 bucket for Prod external location"
  default     = ""
}

variable "prod_external_iam_rolename" {
  type        = string
  description = "IAM role for Prod external location"
  default     = ""
}

variable "prod_git_folder_path" {
  type        = string
  description = "Git folder path for Prod workspace"
  default     = "/Repos/github/prod-sandbox"
}