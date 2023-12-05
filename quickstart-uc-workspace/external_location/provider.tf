terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
}

// Workspace-level provider 
// https://docs.databricks.com/en/dev-tools/terraform/index.html
provider "databricks" {
  alias      = "ws"
  host       = var.workspace_url
  account_id = var.databricks_account_id
  token      = var.pat_token
}

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
