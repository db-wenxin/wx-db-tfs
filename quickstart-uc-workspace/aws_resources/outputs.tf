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