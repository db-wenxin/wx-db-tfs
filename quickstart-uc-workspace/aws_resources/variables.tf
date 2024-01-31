variable "aws_region" {
  type = string
}

variable "databricks_account_id" {
  description = "Account Id that could be found in the bottom left corner of Accounts Console."
  type        = string
}

variable "vpc_cidr_range" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "resource_prefix" {
  type = string
}

variable "create_new_vpc" {
  type = bool
}
variable "public_subnets_cidr" {
  type = list(string)
}

variable "private_subnets_cidr" {
  type = list(string)
}

variable "workspace_rest_service" {
  description = "Region-specific VPC endpoint name for workspace and REST API."
  type        = string
}

variable "backend_relay" {
  description = "Region-specific VPC endpoint name for secure cluster connectivity relay."
  type        = string
}

variable "resource_owner" {
  description = "Email addresses of the AWS resource owner"
  type        = string
}