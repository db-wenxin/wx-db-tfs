/**
 * Provider configuration for account-level resources 
 */

terraform {
  required_providers {
    databricks = {
      source                = "databricks/databricks"
      version               = ">=1.77.0"
      configuration_aliases = [databricks.mws]
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.0.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">=0.9.0"
    }
  }
} 