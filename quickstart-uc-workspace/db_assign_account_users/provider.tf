terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

# // Account level provider
# provider "databricks" {
#   alias         = "mws"
#   host          = "https://accounts.cloud.databricks.com"
#   account_id    = var.databricks_account_id
#   client_id     = var.client_id
#   client_secret = var.client_secret
# }
