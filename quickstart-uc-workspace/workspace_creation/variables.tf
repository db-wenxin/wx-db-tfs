// Description - TBD
variable "aws_region" {
  type = string
}

variable "resource_owner" {
  description = "Email addresses of the AWS resource owner"
  type        = string
}
variable "resource_prefix" {
  type = string
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
variable "cross_account_role_arn" {
  type = string
}

variable "security_group_ids" {
  type = list(any)
}

variable "subnet_ids" {
  type = list(any)
}

variable "vpc_id" {
  type = string
}

variable "storage_config_bucket_name" {
  type = string
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
