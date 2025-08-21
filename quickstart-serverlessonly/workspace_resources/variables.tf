/**
 * Variables for Workspace-level resources (databricks.workspace provider)
 */

# Workspace ID from the account-level module
variable "workspace_id" {
  type        = string
  description = "ID of the created workspace"
}

# Workspace configuration
variable "workspace_deployment_name" {
  type        = string
  description = "Deployment name for the workspace"
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
# }

variable "admin_users" {
  type        = list(string)
  description = "List of users to be granted admin privileges on the catalog"
}

# User variables
variable "existing_acct_level_users" {
  description = "Map of existing account-level users and their permissions to be added to the workspace"
  type        = map(list(string))
}

# Git configuration
variable "create_default_repo" {
  type        = bool
  description = "Whether to create a default Git repository"
}

variable "git_provider" {
  type        = string
  description = "Git provider (e.g., github, gitlab, bitbucket)"
}

variable "git_url" {
  type        = string
  description = "URL of the Git repository"
}

variable "git_folder_path" {
  type        = string
  description = "Path where to create the repository in Databricks"
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