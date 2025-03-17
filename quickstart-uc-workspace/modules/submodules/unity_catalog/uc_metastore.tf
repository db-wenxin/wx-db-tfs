# This template create databricks metastore and related AWS resources such as IAM, S3 and KMS.
# Unity Catalog Trust Policy
data "aws_caller_identity" "current" {}
resource "null_resource" "previous" {}

resource "time_sleep" "wait_30_seconds" {
  depends_on      = [null_resource.previous]
  create_duration = "30s"
}

data "aws_iam_policy_document" "passrole_for_unity_catalog" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      # https:#docs.databricks.com/en/data-governance/unity-catalog/manage-external-locations-and-credentials.html
      identifiers = ["arn:aws:iam::414351767826:role/unity-catalog-prod-UCMasterRole-14S5ZJVKOTYTL"]
      type        = "AWS"
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.databricks_account_id]
    }
  }
  statement {
    sid     = "ExplicitSelfRoleAssumption"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws_account_id}:root"]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:PrincipalArn"
      values   = ["arn:aws:iam::${var.aws_account_id}:role/${var.resource_prefix}-unity-catalog"]
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.databricks_account_id]
    }
  }
}

# Unity Catalog IAM Role
resource "aws_iam_role" "unity_catalog_role" {
  name               = "${var.resource_prefix}-unity-catalog"
  assume_role_policy = data.aws_iam_policy_document.passrole_for_unity_catalog.json
  tags = {
    Name = "${var.resource_prefix}-unity-catalog"
  }
}

# Unity Catalog IAM Policy
data "aws_iam_policy_document" "unity_catalog_iam_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = [
      "arn:aws:s3:::${var.uc_bucketname}/*",
      "arn:aws:s3:::${var.uc_bucketname}"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey*"
    ]
    resources = [aws_kms_key.example_bucket_cmk.arn]
  }
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::${var.aws_account_id}:role/${var.resource_prefix}-unity-catalog"]
  }
}

resource "aws_iam_role_policy" "unity_catalog" {
  name   = "${var.resource_prefix}-unity-catalog-policy"
  role   = aws_iam_role.unity_catalog_role.id
  policy = data.aws_iam_policy_document.unity_catalog_iam_policy.json
}

# Unity Catalog AWS CMK - example aws custom managed key for s3 encryption
resource "aws_kms_key" "example_bucket_cmk" {
  description = "This is an example CMK for UC bucket encryption. Managed by TF"
  policy      = data.aws_iam_policy_document.example_bucket_cmk.json
}

resource "aws_kms_alias" "uc_cmk_alias" {
  name          = "alias/${var.resource_prefix}-uc-cmk"
  target_key_id = aws_kms_key.example_bucket_cmk.key_id
}

data "aws_iam_policy_document" "example_bucket_cmk" {
  version = "2012-10-17"
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws_account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
}

# resource "aws_kms_key_policy" "example_policy" {
#   key_id = aws_kms_key.example_bucket_cmk.id
#   policy = jsonencode(
#     {
#       Id = "Simplified Policy Example"
#       Statement = [
#         {
#           "Sid" : "Enable IAM User Permissions",
#           "Effect" : "Allow",
#           "Principal" : {
#             "AWS" : "arn:aws:iam::${var.aws_account_id}:root"
#           },
#           "Action" : "kms:*",
#           "Resource" : "*"
#         }
#       ]
#     }
#   )
# }

# Unity Catalog S3
resource "aws_s3_bucket" "unity_catalog_bucket" {
  bucket = var.uc_bucketname
  # set force_destroy = true for testing purposes
  force_destroy = true
  tags = {
    Name = var.uc_bucketname
  }
}

resource "aws_s3_bucket_versioning" "unity_catalog_versioning" {
  bucket = aws_s3_bucket.unity_catalog_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "unity_catalog" {
  bucket = aws_s3_bucket.unity_catalog_bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "unity_catalog" {
  bucket                  = aws_s3_bucket.unity_catalog_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  depends_on              = [aws_s3_bucket.unity_catalog_bucket]
}

# Metastore https:#registry.terraform.io/providers/databricks/databricks/latest/docs/guides/unity-catalog
resource "databricks_metastore" "sample_metastore" {
  name   = "wenxin-sampleuc-${var.resource_prefix}"
  region = var.aws_region
  # Skip the s3 allocation so each catalog must have a storage_root
  #storage_root  = "s3:#${var.uc_bucketname}/"
  force_destroy = true
}

# Metastore Data Access
## Since we skipped the s3 allocation, this resource is not required.
# resource "databricks_metastore_data_access" "this" {
#   # The owner by default will be the service principal of the automation.
#   metastore_id = databricks_metastore.sample_metastore.id
#   name         = aws_iam_role.unity_catalog_role.name
#   aws_iam_role {
#     role_arn = aws_iam_role.unity_catalog_role.arn
#   }
#   is_default = true
#   depends_on = [
#     databricks_metastore.sample_metastore, aws_iam_role.unity_catalog_role, time_sleep.wait_30_seconds
#   ]
#   force_destroy = true
#   owner         = "admins"
# }
