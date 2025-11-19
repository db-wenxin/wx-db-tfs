/**
 * Account-level resources for Databricks Serverless Workspace
 * Uses databricks.mws provider
 */
# Network configuration for serverless workspace - created only if var.create_network_config is true
resource "databricks_mws_networks" "serverless_network" {
  count              = var.create_network_config ? 1 : 0
  provider           = databricks.mws
  account_id         = var.databricks_account_id
  network_name       = "${var.resource_prefix}-network"
  vpc_id             = module.vpc[0].vpc_id
  subnet_ids         = module.vpc[0].private_subnets
  security_group_ids = [aws_security_group.workspace_sg[0].id]
}

# VPC and subnets for the workspace - created only if var.create_network_config is true
module "vpc" {
  count   = var.create_network_config ? 1 : 0
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "${var.resource_prefix}-vpc"
  cidr = var.vpc_cidr_range

  azs             = var.availability_zones
  private_subnets = var.private_subnets_cidr
  public_subnets  = var.public_subnets_cidr

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_vpn_gateway     = false

  # DNS settings
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Terraform   = "true"
    Owner       = var.resource_owner
    Environment = "serverless"
  }
}

# Create VPC endpoints using separate resources - created only if var.create_network_config is true
resource "aws_vpc_endpoint" "s3" {
  count             = var.create_network_config ? 1 : 0
  vpc_id            = module.vpc[0].vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = flatten([module.vpc[0].private_route_table_ids, module.vpc[0].public_route_table_ids])

  tags = {
    Name = "${var.resource_prefix}-s3-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "workspace_svc" {
  count               = var.create_network_config ? 1 : 0
  vpc_id              = module.vpc[0].vpc_id
  service_name        = var.workspace_rest_service
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc[0].private_subnets
  security_group_ids  = [aws_security_group.vpc_endpoints[0].id]
  private_dns_enabled = true

  tags = {
    Name = "${var.resource_prefix}-workspace-svc-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "relay_svc" {
  count               = var.create_network_config ? 1 : 0
  vpc_id              = module.vpc[0].vpc_id
  service_name        = var.backend_relay
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc[0].private_subnets
  security_group_ids  = [aws_security_group.vpc_endpoints[0].id]
  private_dns_enabled = true

  tags = {
    Name = "${var.resource_prefix}-relay-svc-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "kinesis_streams" {
  count               = var.create_network_config ? 1 : 0
  vpc_id              = module.vpc[0].vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.kinesis-streams"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc[0].private_subnets
  security_group_ids  = [aws_security_group.vpc_endpoints[0].id]
  private_dns_enabled = true

  tags = {
    Name = "${var.resource_prefix}-kinesis-vpc-endpoint"
  }
}

# Security group for workspace - created only if var.create_network_config is true
resource "aws_security_group" "workspace_sg" {
  count       = var.create_network_config ? 1 : 0
  name        = "${var.resource_prefix}-workspace-sg"
  description = "Security group for Databricks workspace"
  vpc_id      = module.vpc[0].vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "${var.resource_prefix}-workspace-sg"
    Terraform   = "true"
    Owner       = var.resource_owner
    Environment = "serverless"
  }
}

# Security group for VPC endpoints - created only if var.create_network_config is true
resource "aws_security_group" "vpc_endpoints" {
  count       = var.create_network_config ? 1 : 0
  name        = "${var.resource_prefix}-vpc-endpoints-sg"
  description = "Security group for Databricks VPC endpoints"
  vpc_id      = module.vpc[0].vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_range]
    description = "Allow HTTPS from the VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "${var.resource_prefix}-vpc-endpoints-sg"
    Terraform   = "true"
    Owner       = var.resource_owner
    Environment = "serverless"
  }
}

# Direct creation of a serverless workspace
resource "databricks_mws_workspaces" "serverless_workspace" {
  provider        = databricks.mws
  account_id      = var.databricks_account_id
  workspace_name  = var.workspace_deployment_name
  deployment_name = var.workspace_deployment_name

  # Serverless workspace configuration
  # This is the key setting for serverless workspace
  compute_mode = "SERVERLESS"

  # Network configuration - conditional based on var.create_network_config
  network_id = var.create_network_config ? databricks_mws_networks.serverless_network[0].network_id : null

  # Optional workspace settings
  aws_region   = var.aws_region
  pricing_tier = var.pricing_tier
  custom_tags = {
    "workspace_level_tag" = "sample_workspace_level_tag"
    Owner = var.resource_owner
  }
  # Per documentation, for no public IP, use network security
  depends_on = [
    databricks_mws_networks.serverless_network
  ]
}

# Network Connectivity Configuration (NCC) -- pending for testing
# resource "databricks_mws_network_connectivity_config" "ncc" {
#   provider   = databricks.mws
#   name       = "ncc-for-${var.workspace_deployment_name}"
#   region     = var.aws_region
#   account_id = var.databricks_account_id
# }
# resource "time_sleep" "wait_30_seconds" {
#   depends_on = [
#     databricks_mws_network_connectivity_config.ncc,
#     databricks_mws_workspaces.serverless_workspace
#   ]
#   create_duration = "30s"
# }

# resource "databricks_mws_ncc_binding" "ncc_binding" {
#   provider                       = databricks.mws
#   network_connectivity_config_id = databricks_mws_network_connectivity_config.ncc.network_connectivity_config_id
#   workspace_id                   = databricks_mws_workspaces.serverless_workspace.workspace_id
#   depends_on = [time_sleep.wait_30_seconds]
# }
