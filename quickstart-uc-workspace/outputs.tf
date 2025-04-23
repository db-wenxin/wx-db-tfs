# Dev workspace outputs - all outputs in a single block
output "dev_workspace" {
  description = "Complete information about the Dev workspace"
  value = {
    workspace_id        = module.databricks_workspace_dev.workspace_id
    workspace_url       = module.databricks_workspace_dev.workspace_url
    workspace_name      = module.databricks_workspace_dev.workspace_name
    vpc_id              = module.databricks_workspace_dev.vpc_id
    subnet_ids          = module.databricks_workspace_dev.subnet_ids
    security_group_ids  = module.databricks_workspace_dev.security_group_ids
    storage_bucket      = module.databricks_workspace_dev.storage_bucket_name
    default_repo_id     = module.databricks_workspace_dev.default_repo_id
    cross_account_role  = module.databricks_workspace_dev.cross_account_role_arn
    deployment_complete = module.databricks_workspace_dev.workspace_deployment_complete
  }
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