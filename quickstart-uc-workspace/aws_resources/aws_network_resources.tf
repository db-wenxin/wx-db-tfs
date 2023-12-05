// AWS VPC 
# pylint: disable=unused-import
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  create_vpc             = var.create_new_vpc
  name                   = "${var.resource_prefix}-data-plane-VPC"
  cidr                   = var.vpc_cidr_range
  azs                    = var.availability_zones
  private_subnet_suffix  = "private_subnet"
  private_subnets        = var.private_subnets_cidr
  public_subnet_suffix   = "public_subnet"
  public_subnets         = var.public_subnets_cidr
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
}

resource "aws_security_group" "sample_sg" {
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "Allow all TCP from itself"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }
  ingress {
    description = "Allow all UDP from itself"
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    self        = true
  }

  # egress {
  #   description = "Allow all TCP to itself"
  #   from_port   = 0
  #   to_port     = 65535
  #   protocol    = "tcp"
  #   self        = true
  # }

  # egress {
  #   description = "Allow all UDP to itself"
  #   from_port   = 0
  #   to_port     = 65535
  #   protocol    = "udp"
  #   self        = true
  # }
  egress {
    description = "Allow all Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "vpc_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  #version = "5.1.2"
  vpc_id             = module.vpc.vpc_id
  security_group_ids = [aws_security_group.sample_sg.id]

  endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = module.vpc.private_route_table_ids
      tags = {
        Name = "${var.resource_prefix}-s3-gateway-endpoint"
      }
    },
    sts = {
      service             = "sts"
      private_dns_enabled = true
      subnet_ids          = length(module.vpc.private_subnets) > 0 ? slice(module.vpc.private_subnets, 0, min(2, length(module.vpc.private_subnets))) : []
      tags = {
        Name = "${var.resource_prefix}-sts-interface-endpoint"
      }
    },
    kinesis-streams = {
      service             = "kinesis-streams"
      private_dns_enabled = true
      subnet_ids          = length(module.vpc.private_subnets) > 0 ? slice(module.vpc.private_subnets, 0, min(2, length(module.vpc.private_subnets))) : []
      tags = {
        Name = "${var.resource_prefix}-kinesis-interface-endpoint"
      }
    }
  }
}

// https://docs.databricks.com/en/resources/supported-regions.html
resource "aws_vpc_endpoint" "backend_rest" {
  vpc_id              = module.vpc.vpc_id
  service_name        = var.workspace_rest_service
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.sample_sg.id]
  subnet_ids          = module.vpc.private_subnets
  private_dns_enabled = true // try to directly set this to true in the first apply
  depends_on          = [module.vpc.private_subnets]
  tags = {
    Name = "${var.resource_prefix}-databricks-backend-rest"
  }
}

resource "aws_vpc_endpoint" "backend_relay" {
  vpc_id              = module.vpc.vpc_id
  service_name        = var.backend_relay
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.sample_sg.id]
  subnet_ids          = module.vpc.private_subnets
  private_dns_enabled = true
  depends_on          = [module.vpc.private_subnets]
  tags = {
    Name = "${var.resource_prefix}-databricks-backend-relay"
  }
}