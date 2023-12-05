// Description - TBD
variable "aws_region" {
  type = string
}

variable "resource_owner" {
  type = string
}

variable "resource_prefix" {
  type = string
}

variable "aws_account_id" {
  type = string
}

variable "databricks_account_id" {
  type = string
}

variable "client_id" {
  type      = string
  sensitive = true
}

variable "client_secret" {
  type      = string
  sensitive = true
}

variable "uc_bucketname" {
  type = string
}