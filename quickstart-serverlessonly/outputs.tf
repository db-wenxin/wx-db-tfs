/**
 * Main outputs for Databricks Serverless Workspace Terraform Configuration
 * Combines outputs from both account-level and workspace-level modules
 */

# Workspace information from account_resources module
output "workspace_id" {
  description = "ID of the created workspace"
  value       = module.account_resources.workspace_id
}

output "workspace_url" {
  description = "URL of the created workspace"
  value       = module.account_resources.workspace_url
}

output "workspace_name" {
  description = "Name of the created workspace"
  value       = module.account_resources.workspace_name
}

# Network information from account_resources module - conditional based on network configuration
output "vpc_id" {
  description = "ID of the VPC created for the workspace (if network configuration is enabled)"
  value       = module.account_resources.vpc_id
}

output "subnet_ids" {
  description = "IDs of the subnets created for the workspace (if network configuration is enabled)"
  value       = module.account_resources.subnet_ids
}

output "security_group_ids" {
  description = "IDs of the security groups created for the workspace (if network configuration is enabled)"
  value       = module.account_resources.security_group_ids
}

# Git repository information from workspace_resources module (if created)
output "default_repo_id" {
  description = "ID of the default Git repository (if created)"
  value       = module.workspace_resources.default_repo_id
} 