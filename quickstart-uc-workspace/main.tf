resource "null_resource" "previous" {
  depends_on = [module.aws_resources, module.workspace_creation]
}
#Use sleep to avoid explicit dependencies between workspace and user assignment resources.
resource "time_sleep" "wait_30_seconds" {
  depends_on      = [null_resource.previous]
  create_duration = "30s"
}
resource "time_sleep" "wait_60_seconds" {
  depends_on      = [null_resource.previous]
  create_duration = "60s"
}

# S3, IAM, Network resources
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
## Recommend to create UC resources in a saperated repo/pipeline.
# Create new UC Metastore
# module "unity_catalog" {
#   source = "./unity_catalog"
#   providers = {
#     aws        = aws
#     databricks = databricks.mws
#   }
#   aws_region            = var.aws_region
#   aws_account_id        = var.aws_account_id
#   databricks_account_id = var.databricks_account_id
#   resource_prefix       = var.resource_prefix
#   resource_owner        = var.resource_owner
#   uc_bucketname         = var.uc_bucketname
# }
# DB workspace
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
  metastore_id                  = var.metastore_id #module.unity_catalog.metastore_id 
  workspace_allow_public_access = var.workspace_allow_public_access
  default_catalog_name          = var.default_catalog_name
  cross_account_role_arn        = module.aws_resources.cloud_provider_aws_cross_acct_role_arn
  security_group_ids            = module.aws_resources.cloud_provider_network_security_groups
  subnet_ids                    = module.aws_resources.cloud_provider_network_subnets
  vpc_id                        = module.aws_resources.cloud_provider_network_vpc
  storage_config_bucket_name    = module.aws_resources.cloud_provider_aws_dbfs_bucket_name
  backend_rest                  = module.aws_resources.cloud_provider_backend_rest_vpce
  backend_relay                 = module.aws_resources.cloud_provider_backend_relay_vpce
}
# Initialize the workspace provider once the workspace is up and running.
# This is one of possible ways to intilize workspace provider 
# To declare a configuration alias within a module in order to receive an alternate provider configuration 
#   from the parent module, add the configuration_aliases argument to that provider's required_providers entry.
#   https://developer.hashicorp.com/terraform/language/providers/configuration

provider "databricks" {
  alias         = "workspace"
  host          = module.workspace_creation.workspace_url
  client_id     = var.client_id
  client_secret = var.client_secret
}

# # Assign users to workspace
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
  depends_on                = [time_sleep.wait_60_seconds, module.workspace_creation]
}

# Use this to define default_catalog in newer provder versions
# This resource could be only used with workspace-level provider
resource "databricks_default_namespace_setting" "default_catalog" {
  depends_on = [module.workspace_creation]
  provider   = databricks.workspace
  namespace {
    value = var.default_catalog_name
  }
}

# Create extenal location example
module "external_location_sample" {
  source = "./external_location"
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
  depends_on            = [module.workspace_users_assignment, time_sleep.wait_30_seconds]
}
# Create a workspace resource to automatically assign users' repo to the workspace
module "default_user_repo" {
  source = "./databricks_repo"
  providers = {
    databricks = databricks.workspace
  }
  git_provider          = var.git_provider
  git_url               = var.git_url
  git_branch            = var.git_branch
  git_folder_path       = var.git_folder_path
  git_username          = var.git_username
  git_personal_access_token = var.git_personal_access_token
  depends_on            = [module.workspace_users_assignment, time_sleep.wait_30_seconds]
}

# # Create workspace-level cluster and compute resources
# module "create_sample_cluster" {
#   source = "./workspace_compute"
#   providers = {
#     aws                  = aws
#     databricks.mws       = databricks.mws
#     databricks.workspace = databricks.workspace
#   }
#   client_id     = var.client_id
#   client_secret = var.client_secret
#   #NOTE: Without this 'depends_on' configuration, data resources such as 'databricks_spark_version' will fail during the planning stage.
#   depends_on = [module.workspace_creation, time_sleep.wait_60_seconds]
# }

# Create a sample static job with multiple tasks
# module "create_static_job" {
#   providers = {
#     databricks = databricks.workspace
#   } 
#   source     = "./databricks_job_task_sample"
#   depends_on = [module.workspace_creation, time_sleep.wait_60_seconds]
# }

# module "audit_log_alerting" {
#   source       = "./system_tables_audit_log/"
#   count        = var.enable_audit_log_alerting ? 1 : 0
#   providers    = { databricks = databricks.workspace }
#   alert_emails = var.databricks_account_admins
# }
