/**
 * Main Terraform Configuration for Databricks Serverless Workspace
 * This file orchestrates the account-level and workspace-level resources
 */

locals {
  // Determine if we should create network config based on var.create_network_config
  create_network = var.create_network_config
}

# Account-level resources module (using databricks.mws provider)
module "account_resources" {
  source = "./account_resources"

  providers = {
    databricks.mws = databricks.mws
  }

  # Pass necessary variables to the account_resources module
  aws_region                = var.aws_region
  aws_account_id            = var.aws_account_id
  resource_owner            = var.resource_owner
  resource_prefix           = var.resource_prefix
  databricks_account_id     = var.databricks_account_id
  workspace_deployment_name = var.workspace_deployment_name
  pricing_tier              = var.pricing_tier
  create_network_config     = var.create_network_config
  vpc_cidr_range            = var.vpc_cidr_range
  availability_zones        = var.availability_zones
  public_subnets_cidr       = var.public_subnets_cidr
  private_subnets_cidr      = var.private_subnets_cidr
  workspace_rest_service    = var.workspace_rest_service
  backend_relay             = var.backend_relay
}

# Configure workspace provider with workspace details
provider "databricks" {
  alias         = "workspace"
  host          = module.account_resources.workspace_url
  account_id    = var.databricks_account_id
  client_id     = var.client_id
  client_secret = var.client_secret
}

# Workspace-level resources module (using databricks.workspace provider)
module "workspace_resources" {
  source = "./workspace_resources"
  providers = {
    databricks.workspace = databricks.workspace
    databricks.mws       = databricks.mws
  }

  # Pass necessary variables to the workspace_resources module
  workspace_id              = module.account_resources.workspace_id
  workspace_deployment_name = var.workspace_deployment_name
  metastore_id              = var.metastore_id
  #default_catalog_name      = var.default_catalog_name
  #create_default_catalog    = var.create_default_catalog
  admin_users               = var.admin_users
  existing_acct_level_users = var.existing_acct_level_users
  create_default_repo       = var.create_default_repo
  git_provider              = var.git_provider
  git_url                   = var.git_url
  git_folder_path           = var.git_folder_path
  git_username              = var.git_username
  git_personal_access_token = var.git_personal_access_token

  # Ensure the workspace is created before workspace-level resources
  depends_on = [
    module.account_resources
  ]
} 