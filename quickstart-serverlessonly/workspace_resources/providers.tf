/**
 * Provider configuration for workspace-level resources 
 */

terraform {
  required_providers {
    databricks = {
      source                = "databricks/databricks"
      version               = ">=1.77.0"
      configuration_aliases = [databricks.workspace, databricks.mws]
    }
  }
} 