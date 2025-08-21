# Workspace outputs
output "workspace_id" {
  description = "ID of the created Databricks workspace"
  value       = module.workspace_creation.workspace_id
}

output "workspace_url" {
  description = "URL of the created Databricks workspace"
  value       = module.workspace_creation.workspace_url
}

output "workspace_name" {
  description = "Name of the created Databricks workspace"
  value       = var.workspace_deployment_name
}

# AWS resources outputs
output "vpc_id" {
  description = "ID of the VPC used for the workspace"
  value       = module.aws_resources.cloud_provider_network_vpc
}

output "subnet_ids" {
  description = "IDs of the subnets used for the workspace"
  value       = module.aws_resources.cloud_provider_network_subnets
}

output "security_group_ids" {
  description = "IDs of the security groups used for the workspace"
  value       = module.aws_resources.cloud_provider_network_security_groups
}

output "cross_account_role_arn" {
  description = "ARN of the cross-account IAM role"
  value       = module.aws_resources.cloud_provider_aws_cross_acct_role_arn
}

output "storage_bucket_name" {
  description = "Name of the S3 bucket used for workspace storage"
  value       = module.aws_resources.cloud_provider_aws_dbfs_bucket_name
}

# Git repository outputs
output "default_repo_id" {
  description = "ID of the default Git repository (if created)"
  value       = var.create_default_repo ? module.default_user_repo[0].repo_id : null
}

# Deployment status
output "workspace_deployment_complete" {
  description = "Indicates if the workspace deployment is complete"
  value       = true
  depends_on = [
    module.workspace_creation,
    module.workspace_users_assignment,
    #databricks_default_namespace_setting.default_catalog
  ]
}