variable "aws_region" {
  type = string
}

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
variable "uc_bucketname" {
  description = "Name of the UC bucket"
  type        = string
}

variable "unity_admin_group" {
  description = "Name of the admin group. This group will be set as the owner of the Unity Catalog metastore"
  type        = string
}

variable "vpc_cidr_range" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "resource_prefix" {
  type = string
}

variable "resource_owner" {
  description = "Email addresses of the AWS resource owner"
  type        = string
}

variable "create_new_vpc" {
  type = bool
}
variable "public_subnets_cidr" {
  type = list(string)
}

variable "private_subnets_cidr" {
  type = list(string)
}

variable "workspace_rest_service" {
  description = "Region-specific VPC endpoint name for workspace and REST API."
  type        = string
}

variable "backend_relay" {
  description = "Region-specific VPC endpoint name for secure cluster connectivity relay."
  type        = string
}

variable "aws_account_id" {
  type = string
}

variable "databricks_account_id" {
  type = string
}

variable "client_id" {
  type      = string
  sensitive = true
}

variable "client_secret" {
  type      = string
  sensitive = true
}

variable "pricing_tier" {
  type    = string
  default = "ENTERPRISE"
}

variable "workspace_deployment_name" {
  description = "Deployment name cannot be used until a deployment name prefix is defined. Please contact your Databricks representative. Once a new deployment prefix is added/updated, it only will affect the new workspaces created."
  type        = string
}

variable "metastore_id" {
  type = string
}

variable "default_catalog_name" {
  type    = string
  default = "hive_metastore"
}

variable "existing_acct_level_users" {
  description = "Map of users and their permissions"
  type        = map(list(string))
  default = {
    "user1@example.com" = ["ADMIN"],
    "user2@example.com" = ["USER"]
    // Add more users and their permissions as needed
  }
}

variable "workspace_allow_public_access" {
  type = bool
}
variable "external_s3_bucketname" {
  type        = string
  description = "The S3 bucket you want to register as the new external location."
}
variable "external_iam_rolename" {
  type        = string
  description = "The IAM role name you want to give to the new IAM role created for storage credential."
}

variable "enable_audit_log_alerting" {
  type        = bool
  description = "Enable audit log alert."
}

variable "git_provider" {
  type = string
}

variable "git_branch" {
  type = string
}

variable "git_url" {
  type = string
}
variable "git_username" {
  type = string
}

variable "git_personal_access_token" {
  type      = string
  sensitive = true
}

variable "git_folder_path" {
  type    = string
  default = "/Repos/github/sandbox_sample"
}