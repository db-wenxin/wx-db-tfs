provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Owner     = var.resource_owner
      Resource  = var.prefix
      Terraform = "Yes"
    }
  }
}

// initialize provider in "MWS" mode to provision new workspace
provider "databricks" {
  alias         = "mws"
  host          = "https://accounts.cloud.databricks.com"
  account_id    = var.databricks_account_id
  client_id     = var.client_id
  client_secret = var.client_secret
  # username   = var.databricks_account_username
  # password   = var.databricks_account_password
}
