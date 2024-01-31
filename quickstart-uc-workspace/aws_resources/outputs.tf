output "cloud_provider_network_vpc" {
  value = module.vpc.vpc_id
}

output "cloud_provider_network_subnets" {
  value = module.vpc.private_subnets
}

output "cloud_provider_network_security_groups" {
  value = [aws_security_group.sample_sg.id]
}

output "cloud_provider_aws_dbfs_bucket_name" {
  value = aws_s3_bucket.root_storage_bucket.id
}

output "cloud_provider_aws_cross_acct_role_arn" {
  value = aws_iam_role.cross_account_role.arn
}

output "cloud_provider_backend_relay_vpce" {
  value = aws_vpc_endpoint.backend_relay.id
}

output "cloud_provider_backend_rest_vpce" {
  value = aws_vpc_endpoint.backend_rest.id
}