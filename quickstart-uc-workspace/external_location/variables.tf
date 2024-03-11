# variable "aws_region" {
#   type = string
# }

variable "databricks_account_id" {
  type        = string
  description = "Find your account ID at https://accounts.cloud.databricks.com"
  sensitive   = true
}

variable "workspace_url" {
  type        = string
  description = "Url of your workspace."
}

# variable "pat_token" {
#   // To get a personal access token: https://docs.databricks.com/en/administration-guide/access-control/tokens.html
#   type        = string
#   description = "A personal access token for your Databricks account."
#   sensitive   = true
# }

variable "s3_bucket_name" {
  type        = string
  description = "The S3 bucket you want to register as the new external location."
}

variable "iam_role_name" {
  type        = string
  description = "The IAM role name you want to give to the new IAM role created for storage credential."
}

variable "s3_prefix" {
  type        = string
  description = "The S3 prefix to be used for the Databricks external location URL. If set to empty, the S3 bucket's root path will be used instead."
  default     = ""
}

variable "client_id" {
  type      = string
  sensitive = true
}

variable "client_secret" {
  type      = string
  sensitive = true
}
