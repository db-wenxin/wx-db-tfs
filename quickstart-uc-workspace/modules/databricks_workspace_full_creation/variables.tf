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

# Workspace configuration
variable "workspace_deployment_name" {
  description = "Deployment name for the workspace"
  type        = string
}

variable "workspace_allow_public_access" {
  type        = bool
  description = "Whether to allow public access to the workspace"
  default     = false
}

variable "pricing_tier" {
  type        = string
  default     = "ENTERPRISE"
  description = "Pricing tier for the workspace"
}

# This variable is used to handle the chicken-egg problem with providers
# It can be empty for a new workspace or set to an existing workspace URL
variable "workspace_url" {
  type        = string
  description = "URL of an existing workspace (leave empty for new workspaces)"
  default     = ""
}

# Network configuration
variable "create_new_vpc" {
  type        = bool
  description = "Whether to create a new VPC or use existing one"
  default     = true
}

variable "vpc_cidr_range" {
  type        = string
  description = "CIDR range for the VPC"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "public_subnets_cidr" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
}

variable "private_subnets_cidr" {
  type        = list(string)
  description = "CIDR blocks for private subnets"
}

variable "workspace_rest_service" {
  description = "Region-specific VPC endpoint name for workspace and REST API."
  type        = string
}

variable "backend_relay" {
  description = "Region-specific VPC endpoint name for secure cluster connectivity relay."
  type        = string
}

# Unity Catalog variables
variable "metastore_id" {
  type        = string
  description = "ID of the metastore to use"
}

variable "default_catalog_name" {
  type        = string
  default     = "hive_metastore"
  description = "Default catalog name"
}

variable "unity_admin_group" {
  description = "Name of the admin group. This group will be set as the owner of the Unity Catalog metastore"
  type        = string
  default     = ""
}

# User assignment
variable "existing_acct_level_users" {
  description = "Map of users and their permissions"
  type        = map(list(string))
  default     = {}
}

variable "databricks_users" {
  description = "List of Databricks users to be added at account-level"
  type        = list(string)
  default     = []
}

variable "databricks_account_admins" {
  description = "List of Admins to be added at account-level"
  type        = list(string)
  default     = []
}

# External location configuration
variable "external_s3_bucketname" {
  type        = string
  description = "S3 bucket for external location"
  default     = ""
}

variable "external_iam_rolename" {
  type        = string
  description = "IAM role for external location"
  default     = ""
}

# Git repository configuration
variable "create_default_repo" {
  type        = bool
  description = "Whether to create a default Git repository"
  default     = false
}

variable "git_provider" {
  type        = string
  description = "Git provider (e.g., github, gitlab, bitbucket)"
  default     = ""
}

variable "git_url" {
  type        = string
  description = "URL of the Git repository"
  default     = ""
}

variable "git_branch" {
  type        = string
  description = "Branch of the Git repository"
  default     = "main"
}

variable "git_folder_path" {
  type        = string
  description = "Path to the folder in the Git repository"
  default     = ""
}

variable "git_username" {
  type        = string
  description = "Username for Git authentication"
  default     = ""
}

variable "git_personal_access_token" {
  type        = string
  sensitive   = true
  description = "Personal access token for Git authentication"
  default     = ""
}
