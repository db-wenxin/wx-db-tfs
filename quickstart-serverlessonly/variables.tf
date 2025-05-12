/**
 * Variables for Databricks Serverless Workspace Terraform Configuration
 */

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
  description = "Email address of the AWS resource owner"
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
  type        = string
  description = "Deployment name for the workspace"
}

variable "pricing_tier" {
  type        = string
  description = "Pricing tier for the workspace"
  default     = "ENTERPRISE"
}

# Network configuration options
variable "create_network_config" {
  type        = bool
  description = "Whether to create network configuration for the workspace (false for no network, true for PrivateLink setup)"
  default     = true
}

# Network configuration
variable "vpc_cidr_range" {
  type        = string
  description = "CIDR range for the VPC"
  default     = "10.4.0.0/16"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "public_subnets_cidr" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
  default     = ["10.4.1.0/24", "10.4.2.0/24"]
}

variable "private_subnets_cidr" {
  type        = list(string)
  description = "CIDR blocks for private subnets"
  default     = ["10.4.3.0/24", "10.4.4.0/24", "10.4.5.0/24"]
}

variable "workspace_rest_service" {
  description = "Region-specific VPC endpoint name for workspace and REST API"
  type        = string
}

variable "backend_relay" {
  description = "Region-specific VPC endpoint name for secure cluster connectivity relay"
  type        = string
}

# Unity Catalog variables
variable "metastore_id" {
  type        = string
  description = "ID of the Unity Catalog metastore to assign to the workspace"
}

# variable "default_catalog_name" {
#   type        = string
#   description = "Default catalog name for Unity Catalog"
# }

# variable "create_default_catalog" {
#   type        = bool
#   description = "Whether to create the default catalog and assign permissions"
#   default     = true
# }

variable "admin_users" {
  type        = list(string)
  description = "List of users to be granted admin privileges on the catalog"
  default     = []
}

# User variables
variable "databricks_users" {
  description = "List of Databricks users to be added to the workspace"
  type        = list(string)
  default     = []
}

# Workspace admin users
variable "existing_acct_level_users" {
  description = "Map of existing account-level users and their permissions to be added to the workspace"
  type        = map(list(string))
  default     = {}
}

# Git configuration
variable "create_default_repo" {
  type        = bool
  description = "Whether to create a default Git repository"
  default     = false
}

variable "git_provider" {
  type        = string
  description = "Git provider (e.g., github, gitlab, bitbucket)"
  default     = "gitHub"
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
  description = "Path where to create the repository in Databricks"
  default     = "/Repos/github/serverless-sandbox"
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