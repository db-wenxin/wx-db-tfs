terraform {
  required_providers {
    databricks = {
      source                = "databricks/databricks"
      version               = ">=1.14.0"
      configuration_aliases = [databricks.mws, databricks.workspace]
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.0.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">=0.7.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">=3.1.0"
    }
  }
}

# The workspace provider is dynamically configured within the module
# This approach allows passing workspace_url from the parent but also handles
# the initial configuration when the workspace_url is not yet known
provider "databricks" {
  alias         = "workspace"
  host          = module.workspace_creation.workspace_url
  client_id     = var.client_id
  client_secret = var.client_secret

}