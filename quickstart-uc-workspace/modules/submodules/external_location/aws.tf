data "aws_caller_identity" "current" {}
#Create a new sample bucket for the new external location
resource "aws_s3_bucket" "external_location_bucket" {
  # Set to true non-prod env
  force_destroy = true
  bucket        = "${var.s3_prefix}-${var.s3_bucket_name}"
}

resource "aws_s3_bucket_public_access_block" "external" {
  bucket                  = aws_s3_bucket.external_location_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "ssekms" {
  bucket = aws_s3_bucket.external_location_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.sample_kms_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

#Create sample KMS key for external location.
resource "aws_kms_key" "sample_kms_key" {
  description = "KMS key for ${var.s3_prefix} external location"
  policy = data.aws_iam_policy_document.sample_kms_policy.json
}

data "aws_iam_policy_document" "sample_kms_policy" {
  version = "2012-10-17"
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["${data.aws_caller_identity.current.account_id}"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
}

#Create IAM resources for external location
resource "aws_iam_role" "external_data_access" {
  name               = "${var.s3_prefix}-${var.iam_role_name}"
  assume_role_policy = data.databricks_aws_unity_catalog_assume_role_policy.passrole_for_uc.json
  
  inline_policy {
    name = "${var.s3_prefix}_sample_policy_storage_credentail_role"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          "Effect" : "Allow"
          "Action" : [
            "s3:GetObject",
            "s3:GetObjectVersion",
            "s3:PutObject",
            "s3:PutObjectAcl",
            "s3:DeleteObject",
            "s3:ListBucket",
            "s3:GetBucketLocation"
          ],
          "Resource" : [
            "arn:aws:s3:::${var.s3_prefix}-${var.s3_bucket_name}",
            "arn:aws:s3:::${var.s3_prefix}-${var.s3_bucket_name}/*"
          ]
        },
        {
          "Effect" : "Allow"
          "Action" : [
            "kms:Decrypt",
            "kms:Encrypt",
            "kms:GenerateDataKey*"
          ],
          "Resource" : [
            "${aws_kms_key.sample_kms_key.arn}"
          ]
        },
        {
          "Effect" : "Allow"
          "Action" : [
            "sts:AssumeRole"
          ],
          "Resource" : [
            "*"
          ],
          "Condition" : {
            "ArnEquals" : {
              "aws:PrincipalArn" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.s3_prefix}-${var.iam_role_name}"
            }
          }
        }
      ]
    })
  }
}

data "databricks_aws_unity_catalog_assume_role_policy" "passrole_for_uc" {
  aws_account_id = data.aws_caller_identity.current.account_id
  role_name      = "${var.s3_prefix}-${var.iam_role_name}"
  external_id    = var.databricks_account_id
}

# data "aws_iam_policy_document" "passrole_for_uc" {
#   statement {
#     effect  = "Allow"
#     actions = ["sts:AssumeRole"]
#     principals {
#       identifiers = ["arn:aws:iam::414351767826:role/unity-catalog-prod-UCMasterRole-14S5ZJVKOTYTL"]
#       type        = "AWS"
#     }
#     condition {
#       test     = "StringEquals"
#       variable = "sts:ExternalId"
#       values   = [var.databricks_account_id]
#     }
#   }
#   statement {
#     effect  = "Allow"
#     actions = ["sts:AssumeRole"]
#     principals {
#       identifiers = ["*"]
#       type        = "AWS"
#     }
#     condition {
#       test     = "StringEquals"
#       variable = "sts:ExternalId"
#       values   = [var.databricks_account_id]
#     }
#     condition {
#       test     = "StringEquals"
#       variable = "aws:PrincipalArn"
#       values   = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.iam_role_name}"]
#     }
#   }
# }


