/**
 * Outputs for Account-level resources (using databricks.mws provider)
 */

# Workspace information
output "workspace_id" {
  description = "ID of the created workspace"
  value       = databricks_mws_workspaces.serverless_workspace.workspace_id
}

output "workspace_url" {
  description = "URL of the created workspace"
  value       = databricks_mws_workspaces.serverless_workspace.workspace_url
}

output "workspace_name" {
  description = "Name of the created workspace"
  value       = databricks_mws_workspaces.serverless_workspace.workspace_name
}

# Network information - conditional based on network configuration
output "vpc_id" {
  description = "ID of the VPC created for the workspace (if network configuration is enabled)"
  value       = var.create_network_config ? module.vpc[0].vpc_id : null
}

output "subnet_ids" {
  description = "IDs of the subnets created for the workspace (if network configuration is enabled)"
  value = var.create_network_config ? {
    private = module.vpc[0].private_subnets
    public  = module.vpc[0].public_subnets
  } : null
}

output "security_group_ids" {
  description = "IDs of the security groups created for the workspace (if network configuration is enabled)"
  value = var.create_network_config ? {
    workspace     = aws_security_group.workspace_sg[0].id
    vpc_endpoints = aws_security_group.vpc_endpoints[0].id
  } : null
}

# # NCC information
# output "network_connectivity_config_id" {
#   description = "ID of the Network Connectivity Configuration"
#   value       = databricks_mws_network_connectivity_config.ncc.network_connectivity_config_id
# }

# output "ncc_binding_id" {
#   description = "ID of the NCC binding to workspace"
#   value       = databricks_mws_ncc_binding.ncc_binding.id
# } 