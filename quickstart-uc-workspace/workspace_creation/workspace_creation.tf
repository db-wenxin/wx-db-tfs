// Terraform Documentation: https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_workspaces
// Wait on Credential Due to Race Condition
resource "null_resource" "previous" {}
resource "time_sleep" "wait_15_seconds" {
  depends_on      = [null_resource.previous]
  create_duration = "15s"
}

// Credential Configuration
resource "databricks_mws_credentials" "credential_config" {
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
// Backend REST VPC Endpoint Configuration
resource "databricks_mws_vpc_endpoint" "backend_rest" {
  account_id          = var.databricks_account_id
  aws_vpc_endpoint_id = var.backend_rest
  vpc_endpoint_name   = "${var.resource_prefix}-vpce-backend-${var.vpc_id}"
  region              = var.aws_region
}

// Backend Rest VPC Endpoint Configuration
resource "databricks_mws_vpc_endpoint" "backend_relay" {
  account_id          = var.databricks_account_id
  aws_vpc_endpoint_id = var.backend_relay
  vpc_endpoint_name   = "${var.resource_prefix}-vpce-relay-${var.vpc_id}"
  region              = var.aws_region
}
resource "databricks_mws_networks" "network_config" {
  account_id         = var.databricks_account_id
  network_name       = "${var.resource_prefix}-network"
  security_group_ids = var.security_group_ids
  subnet_ids         = var.subnet_ids
  vpc_id             = var.vpc_id
  vpc_endpoints {
    dataplane_relay = [databricks_mws_vpc_endpoint.backend_relay.vpc_endpoint_id]
    rest_api        = [databricks_mws_vpc_endpoint.backend_rest.vpc_endpoint_id]
  }
}

// Private Access Setting Configuration
resource "databricks_mws_private_access_settings" "sample_pas" {
  account_id                   = var.databricks_account_id
  private_access_settings_name = "${var.resource_prefix}-pas"
  region                       = var.aws_region
  public_access_enabled        = var.workspace_allow_public_access
  private_access_level         = "ENDPOINT"
  allowed_vpc_endpoint_ids     = [databricks_mws_vpc_endpoint.backend_rest.vpc_endpoint_id]
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
  //Workspaces using Private Link must specify the private_access_settings_id field
  private_access_settings_id = databricks_mws_private_access_settings.sample_pas.private_access_settings_id
  custom_tags = {
    "workspace_level_tag" = "wx_quick_launch"
  }
}

/// 
resource "databricks_metastore_assignment" "this" {
  metastore_id         = var.metastore_id
  workspace_id         = databricks_mws_workspaces.sample_workspace.workspace_id
  default_catalog_name = var.default_catalog_name
}