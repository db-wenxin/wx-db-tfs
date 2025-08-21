/**
 * Variables for Account-level resources (databricks.mws provider)
 */

# AWS Region configuration
variable "aws_region" {
  type        = string
  description = "AWS region where resources will be created"
}

# AWS account configuration
variable "aws_account_id" {
  type        = string
  description = "AWS Account ID"
}

# Resource configuration
variable "resource_owner" {
  description = "Email address of the AWS resource owner"
  type        = string
}

variable "resource_prefix" {
  type        = string
  description = "Prefix for resource names"
}

# Databricks authentication
variable "databricks_account_id" {
  type        = string
  description = "Databricks Account ID"
}

# Workspace configuration
variable "workspace_deployment_name" {
  type        = string
  description = "Deployment name for the workspace"
}

variable "pricing_tier" {
  type        = string
  description = "Pricing tier for the workspace"
}

# Network configuration options
variable "create_network_config" {
  type        = bool
  description = "Whether to create network configuration for the workspace (false for no network, true for PrivateLink setup)"
}

# Network configuration
variable "vpc_cidr_range" {
  type        = string
  description = "CIDR range for the VPC"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "public_subnets_cidr" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
}

variable "private_subnets_cidr" {
  type        = list(string)
  description = "CIDR blocks for private subnets"
}

variable "workspace_rest_service" {
  description = "Region-specific VPC endpoint name for workspace and REST API"
  type        = string
}

variable "backend_relay" {
  description = "Region-specific VPC endpoint name for secure cluster connectivity relay"
  type        = string
} 