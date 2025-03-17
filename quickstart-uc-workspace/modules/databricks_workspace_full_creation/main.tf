# This module handles the complete creation of a Databricks workspace and its resources
# It addresses the chicken-and-egg provider configuration problem by using a two-phase approach
# internally within the module.
# Phase 1: Create AWS resources and the initial workspace
# AWS resources - VPC, subnets, IAM roles, etc.
module "aws_resources" {
  source = "../submodules/aws_resources"

  providers = {
    aws        = aws
    databricks = databricks.mws
  }

  create_new_vpc         = var.create_new_vpc
  aws_region             = var.aws_region
  vpc_cidr_range         = var.vpc_cidr_range
  availability_zones     = var.availability_zones
  resource_prefix        = var.resource_prefix
  public_subnets_cidr    = var.public_subnets_cidr
  private_subnets_cidr   = var.private_subnets_cidr
  workspace_rest_service = var.workspace_rest_service
  backend_relay          = var.backend_relay
  resource_owner         = var.resource_owner
  databricks_account_id  = var.databricks_account_id
}

# Create the workspace using the above AWS resources
module "workspace_creation" {
  source = "../submodules/workspace_creation"

  providers = {
    aws        = aws
    databricks = databricks.mws
  }

  client_id                     = var.client_id
  client_secret                 = var.client_secret
  aws_region                    = var.aws_region
  resource_owner                = var.resource_owner
  resource_prefix               = var.resource_prefix
  databricks_account_id         = var.databricks_account_id
  workspace_deployment_name     = var.workspace_deployment_name
  metastore_id                  = var.metastore_id
  workspace_allow_public_access = var.workspace_allow_public_access
  default_catalog_name          = var.default_catalog_name
  pricing_tier                  = var.pricing_tier

  # Real AWS resource values from aws_resources module
  cross_account_role_arn     = module.aws_resources.cloud_provider_aws_cross_acct_role_arn
  security_group_ids         = module.aws_resources.cloud_provider_network_security_groups
  subnet_ids                 = module.aws_resources.cloud_provider_network_subnets
  vpc_id                     = module.aws_resources.cloud_provider_network_vpc
  storage_config_bucket_name = module.aws_resources.cloud_provider_aws_dbfs_bucket_name
  backend_rest               = module.aws_resources.cloud_provider_backend_rest_vpce
  backend_relay              = module.aws_resources.cloud_provider_backend_relay_vpce

  depends_on = [module.aws_resources]
}

# Wait for workspace to be fully created
resource "time_sleep" "wait_for_workspace" {
  depends_on      = [module.workspace_creation]
  create_duration = "60s"
}

# Assign users to the workspace
module "workspace_users_assignment" {
  source = "../submodules/db_assign_account_users"

  providers = {
    databricks = databricks.mws
  }

  client_id                 = var.client_id
  client_secret             = var.client_secret
  databricks_account_id     = var.databricks_account_id
  workspace_id              = module.workspace_creation.workspace_id
  existing_acct_level_users = var.existing_acct_level_users

  depends_on = [time_sleep.wait_for_workspace]
}

# Phase 2: Create workspace-level resources using workspace provider
# Wait a bit longer to ensure workspace is fully operational
resource "time_sleep" "wait_before_workspace_resources" {
  depends_on      = [module.workspace_users_assignment]
  create_duration = "30s"
}

# Set default catalog
resource "databricks_default_namespace_setting" "default_catalog" {
  provider = databricks.workspace
  namespace {
    value = var.default_catalog_name
  }

  depends_on = [time_sleep.wait_before_workspace_resources]
}

# Create external location if enabled
module "external_location_sample" {
  source = "../submodules/external_location"

  providers = {
    aws                  = aws
    databricks.mws       = databricks.mws
    databricks.workspace = databricks.workspace
  }

  client_id             = var.client_id
  client_secret         = var.client_secret
  databricks_account_id = var.databricks_account_id
  s3_bucket_name        = var.external_s3_bucketname
  iam_role_name         = var.external_iam_rolename
  s3_prefix             = var.resource_prefix

  depends_on = [time_sleep.wait_before_workspace_resources]
}

# Create a default Git repository if enabled
module "default_user_repo" {
  count  = var.create_default_repo ? 1 : 0
  source = "../submodules/databricks_repo"

  providers = {
    databricks = databricks.workspace
  }

  git_provider              = var.git_provider
  git_url                   = var.git_url
  git_branch                = var.git_branch
  git_folder_path           = var.git_folder_path
  git_username              = var.git_username
  git_personal_access_token = var.git_personal_access_token

  depends_on = [time_sleep.wait_before_workspace_resources]
}
