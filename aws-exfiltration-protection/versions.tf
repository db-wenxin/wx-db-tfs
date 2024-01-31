terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.35.0"
    }

    aws = {
      source = "hashicorp/aws"
    }
  }
}
