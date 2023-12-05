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

# provider "aws" {
#   region = var.aws_region
#   default_tags {
#     tags = {
#       Owner     = var.resource_owner
#       Resource  = var.resource_prefix
#       Terraform = "Yes"
#     }
#   }
# }
