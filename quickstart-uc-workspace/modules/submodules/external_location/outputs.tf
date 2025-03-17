# External location outputs
output "external_location_id" {
  description = "ID of the created external location"
  value       = databricks_external_location.some.id
}

output "external_location_name" {
  description = "Name of the created external location"
  value       = databricks_external_location.some.name
}

output "external_location_url" {
  description = "URL of the created external location"
  value       = databricks_external_location.some.url
}

output "storage_credential_id" {
  description = "ID of the storage credential created for external location"
  value       = databricks_storage_credential.external.id
}

output "storage_credential_name" {
  description = "Name of the storage credential created for external location"
  value       = databricks_storage_credential.external.name
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket used for external location"
  value       = aws_s3_bucket.external_location_bucket.id
}

output "iam_role_arn" {
  description = "ARN of the IAM role created for external location access"
  value       = aws_iam_role.external_data_access.arn
}