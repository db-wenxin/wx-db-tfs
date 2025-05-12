# Create Dev workspace with all resources
module "databricks_workspace_dev" {
  source = "./modules/databricks_workspace_full_creation"

  providers = {
    aws            = aws
    databricks.mws = databricks.mws
  }

  # AWS and resource configuration
  aws_region      = var.aws_region
  aws_account_id  = var.aws_account_id
  resource_owner  = var.resource_owner
  resource_prefix = var.dev_resource_prefix

  # Databricks authentication
  databricks_account_id = var.databricks_account_id
  client_id             = var.client_id
  client_secret         = var.client_secret

  # Workspace configuration
  workspace_deployment_name     = var.dev_workspace_deployment_name
  workspace_allow_public_access = var.dev_workspace_allow_public_access
  pricing_tier                  = var.dev_pricing_tier
  workspace_url                 = var.dev_workspace_url # Empty for new workspaces

  # Network configuration
  create_new_vpc         = var.create_new_vpc
  vpc_cidr_range         = var.dev_vpc_cidr_range
  availability_zones     = var.availability_zones
  public_subnets_cidr    = var.dev_public_subnets_cidr
  private_subnets_cidr   = var.dev_private_subnets_cidr
  workspace_rest_service = var.workspace_rest_service
  backend_relay          = var.backend_relay

  # Unity Catalog
  metastore_id         = var.metastore_id
  unity_admin_group    = var.unity_admin_group
  default_catalog_name = var.dev_default_catalog_name
  # User assignment
  existing_acct_level_users = var.existing_acct_level_users
  databricks_users          = var.databricks_users
  databricks_account_admins = var.databricks_account_admins

  # External location
  external_s3_bucketname = var.dev_external_s3_bucketname
  external_iam_rolename  = var.dev_external_iam_rolename

  # Git repository
  create_default_repo       = true
  git_provider              = var.git_provider
  git_url                   = var.git_url
  git_branch                = var.git_branch
  git_folder_path           = var.dev_git_folder_path
  git_username              = var.git_username
  git_personal_access_token = var.git_personal_access_token

  # # Audit logging
  # enable_audit_log_alerting = var.enable_audit_log_alerting
}

# Create Prod workspace with all resources
module "databricks_workspace_prod" {
  source = "./modules/databricks_workspace_full_creation"

  providers = {
    aws            = aws
    databricks.mws = databricks.mws
  }

  # AWS and resource configuration
  aws_region      = var.aws_region
  aws_account_id  = var.aws_account_id
  resource_owner  = var.resource_owner
  resource_prefix = var.prod_resource_prefix

  # Databricks authentication
  databricks_account_id = var.databricks_account_id
  client_id             = var.client_id
  client_secret         = var.client_secret

  # Workspace configuration
  workspace_deployment_name     = var.prod_workspace_deployment_name
  workspace_allow_public_access = var.prod_workspace_allow_public_access
  pricing_tier                  = var.prod_pricing_tier
  workspace_url                 = var.prod_workspace_url # Empty for new workspaces

  # Network configuration
  create_new_vpc         = var.create_new_vpc
  vpc_cidr_range         = var.prod_vpc_cidr_range
  availability_zones     = var.availability_zones
  public_subnets_cidr    = var.prod_public_subnets_cidr
  private_subnets_cidr   = var.prod_private_subnets_cidr
  workspace_rest_service = var.workspace_rest_service
  backend_relay          = var.backend_relay

  # Unity Catalog
  metastore_id         = var.metastore_id
  default_catalog_name = var.prod_default_catalog_name
  unity_admin_group    = var.unity_admin_group

  # User assignment
  existing_acct_level_users = var.existing_acct_level_users
  databricks_users          = var.databricks_users
  databricks_account_admins = var.databricks_account_admins

  # External location
  external_s3_bucketname = var.prod_external_s3_bucketname
  external_iam_rolename  = var.prod_external_iam_rolename

  # Git repository
  create_default_repo       = true
  git_provider              = var.git_provider
  git_url                   = var.git_url
  git_branch                = var.git_branch
  git_folder_path           = var.prod_git_folder_path
  git_username              = var.git_username
  git_personal_access_token = var.git_personal_access_token

}

# # Prod workspace outputs - all outputs in a single block
# output "prod_workspace" {
#   description = "Complete information about the Prod workspace"
#   value = {
#     workspace_id        = module.databricks_workspace_prod.workspace_id
#     workspace_url       = module.databricks_workspace_prod.workspace_url
#     workspace_name      = module.databricks_workspace_prod.workspace_name
#     vpc_id              = module.databricks_workspace_prod.vpc_id
#     subnet_ids          = module.databricks_workspace_prod.subnet_ids
#     security_group_ids  = module.databricks_workspace_prod.security_group_ids
#     storage_bucket      = module.databricks_workspace_prod.storage_bucket_name
#     default_repo_id     = module.databricks_workspace_prod.default_repo_id
#     cross_account_role  = module.databricks_workspace_prod.cross_account_role_arn
#     deployment_complete = module.databricks_workspace_prod.workspace_deployment_complete
#   }
# }

# # ----  Prod workspace specific variables  ---- #
# variable "prod_default_catalog_name" {
#   type        = string
#   description = "Default catalog name"
# }

# variable "prod_workspace_url" {
#   type        = string
#   description = "URL of the Prod workspace (leave empty for new workspaces, set after first run)"
#   default     = ""
# }

# variable "prod_resource_prefix" {
#   type        = string
#   description = "Resource prefix for Prod workspace"
# }

# variable "prod_workspace_deployment_name" {
#   type        = string
#   description = "Deployment name for Prod workspace"
# }

# variable "prod_vpc_cidr_range" {
#   type        = string
#   description = "CIDR range for Prod VPC"
#   default     = "10.3.0.0/16"
# }

# variable "prod_public_subnets_cidr" {
#   type        = list(string)
#   description = "CIDR blocks for Prod public subnets"
#   default     = ["10.3.1.0/24", "10.3.2.0/24", "10.3.3.0/24"]
# }

# variable "prod_private_subnets_cidr" {
#   type        = list(string)
#   description = "CIDR blocks for Prod private subnets"
#   default     = ["10.3.4.0/24", "10.3.5.0/24", "10.3.6.0/24"]
# }

# variable "prod_workspace_allow_public_access" {
#   type        = bool
#   description = "Whether to allow public access to the Prod workspace"
#   default     = true
# }

# variable "prod_pricing_tier" {
#   type        = string
#   description = "Pricing tier for Prod workspace"
#   default     = "ENTERPRISE"
# }

# variable "prod_external_s3_bucketname" {
#   type        = string
#   description = "S3 bucket for Prod external location"
#   default     = ""
# }

# variable "prod_external_iam_rolename" {
#   type        = string
#   description = "IAM role for Prod external location"
#   default     = ""
# }

# variable "prod_git_folder_path" {
#   type        = string
#   description = "Git folder path for Prod workspace"
#   default     = "/Repos/github/prod-sandbox"
# }