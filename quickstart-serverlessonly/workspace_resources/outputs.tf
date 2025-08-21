/**
 * Outputs for Workspace-level resources (using databricks.workspace provider)
 */

# Catalog information
# output "catalog_name" {
#   description = "Name of the created Unity Catalog catalog (if created)"
#   value       = var.create_default_catalog ? databricks_catalog.this[0].name : var.default_catalog_name
# }

# Git repository information (if created)
output "default_repo_id" {
  description = "ID of the default Git repository (if created)"
  value       = var.create_default_repo ? databricks_repo.default_repo[0].id : null
} 