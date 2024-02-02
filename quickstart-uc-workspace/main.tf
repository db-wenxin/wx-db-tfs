resource "null_resource" "previous" {}

resource "time_sleep" "wait_10_seconds" {
  depends_on      = [null_resource.previous]
  create_duration = "10s"
}

// S3, IAM, Network resources
module "aws_resources" {
  source = "./aws_resources"
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

// DB workspace
module "workspace_creation" {
  source = "./workspace_creation"
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
  cross_account_role_arn        = module.aws_resources.cloud_provider_aws_cross_acct_role_arn
  security_group_ids            = module.aws_resources.cloud_provider_network_security_groups
  subnet_ids                    = module.aws_resources.cloud_provider_network_subnets
  vpc_id                        = module.aws_resources.cloud_provider_network_vpc
  storage_config_bucket_name    = module.aws_resources.cloud_provider_aws_dbfs_bucket_name
  backend_rest                  = module.aws_resources.cloud_provider_backend_rest_vpce
  backend_relay                 = module.aws_resources.cloud_provider_backend_relay_vpce
  depends_on                    = [module.aws_resources, time_sleep.wait_10_seconds]
}

// Assign users to workspace
module "workspace_users_assignment" {
  source = "./db_assign_account_users"
  providers = {
    databricks = databricks.mws
  }
  client_id                 = var.client_id
  client_secret             = var.client_secret
  databricks_account_id     = var.databricks_account_id
  workspace_id              = module.workspace_creation.workspace_id
  existing_acct_level_users = var.existing_acct_level_users
  depends_on                = [module.aws_resources, module.workspace_creation]
}
