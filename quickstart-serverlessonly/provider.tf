/**
 * Main provider configuration for Databricks Serverless Workspace
 */

terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = ">=1.77.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.0.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">=0.9.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">=3.2.0"
    }
  }
  required_version = ">=1.0.0"
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

# Databricks account-level provider
provider "databricks" {
  alias         = "mws"
  host          = "https://accounts.cloud.databricks.com"
  account_id    = var.databricks_account_id
  client_id     = var.client_id
  client_secret = var.client_secret
}
