// Create the Databricks root s3 bucket for workspace

resource "aws_s3_bucket" "root_storage_bucket" {
  bucket        = "${var.resource_prefix}-${var.aws_region}-dbfs-bucket"
  force_destroy = true
}

# resource "aws_s3_bucket_versioning" "root_bucket_versioning" {
#   bucket = aws_s3_bucket.root_storage_bucket.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

resource "aws_s3_bucket_public_access_block" "root_storage_bucket" {
  bucket                  = aws_s3_bucket.root_storage_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  depends_on              = [aws_s3_bucket.root_storage_bucket]
}
// A simple access policy for AWS S3 buckets, so that Databricks can access data in it.
data "databricks_aws_bucket_policy" "this" {
  bucket = aws_s3_bucket.root_storage_bucket.bucket
}

resource "aws_s3_bucket_policy" "root_bucket_policy" {
  bucket     = aws_s3_bucket.root_storage_bucket.id
  policy     = data.databricks_aws_bucket_policy.this.json
  depends_on = [aws_s3_bucket_public_access_block.root_storage_bucket]
}