// Terraform Documentation: https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_workspaces
// Wait on Credential Due to Race Condition
resource "null_resource" "previous" {}
resource "time_sleep" "wait_15_seconds" {
  depends_on      = [null_resource.previous]
  create_duration = "15s"
}

// Credential Configuration
resource "databricks_mws_credentials" "credential_config" {
  account_id       = var.databricks_account_id
  role_arn         = var.cross_account_role_arn
  credentials_name = "${var.resource_prefix}-credential"
  depends_on       = [time_sleep.wait_15_seconds]
}

// Storage Configuration
resource "databricks_mws_storage_configurations" "storage_config" {
  account_id                 = var.databricks_account_id
  bucket_name                = var.storage_config_bucket_name
  storage_configuration_name = "${var.resource_prefix}-storage"
}

// Network Configuration
resource "databricks_mws_networks" "network_config" {
  account_id         = var.databricks_account_id
  network_name       = "${var.resource_prefix}-network"
  security_group_ids = var.security_group_ids
  subnet_ids         = var.subnet_ids
  vpc_id             = var.vpc_id
}

// Workspace Configuration
resource "databricks_mws_workspaces" "sample_workspace" {
  account_id               = var.databricks_account_id
  aws_region               = var.aws_region
  credentials_id           = databricks_mws_credentials.credential_config.credentials_id
  deployment_name          = var.workspace_deployment_name
  network_id               = databricks_mws_networks.network_config.network_id
  pricing_tier             = var.pricing_tier
  storage_configuration_id = databricks_mws_storage_configurations.storage_config.storage_configuration_id
  workspace_name           = var.resource_prefix
  #  depends_on               = [databricks_mws_networks.network_config]
}

/// 
resource "databricks_metastore_assignment" "this" {
  metastore_id         = var.metastore_id
  workspace_id         = databricks_mws_workspaces.sample_workspace.workspace_id
  default_catalog_name = var.default_catalog_name
}