# Provider versions
terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.44.0"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# AWS Provider
provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Owner     = var.resource_owner
      Resource  = var.resource_prefix
      Terraform = "Yes"
    }
  }
}

# Databricks MWS Provider
provider "databricks" {
  alias         = "mws"
  host          = "https://accounts.cloud.databricks.com"
  account_id    = var.databricks_account_id
  client_id     = var.client_id
  client_secret = var.client_secret
}

# The workspace provider is defined in main.tf for dynamic provider configuration
