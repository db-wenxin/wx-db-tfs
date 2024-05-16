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

# Workspace-level provider not required in this module
# https://docs.databricks.com/en/dev-tools/terraform/index.html
# provider "databricks" {
#   alias         = "workspace"
#   host          = var.workspace_url
#   client_id     = var.client_id
#   client_secret = var.client_secret
# }
