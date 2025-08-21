// Wait on Credential Due to Race Condition
resource "null_resource" "previous" {}
resource "time_sleep" "wait_30_seconds" {
  depends_on      = [null_resource.previous]
  create_duration = "30s"
}

#################################################################################
# The Owner of following resources will be SP instead of indivudual account user #
##################################################################################
resource "databricks_storage_credential" "external" {
  provider = databricks.workspace
  force_destroy = true
  force_update  = true
  name     = "${var.s3_prefix}-${aws_iam_role.external_data_access.name}"
  aws_iam_role {
    role_arn = aws_iam_role.external_data_access.arn
  }
  comment    = "Sample resource managed by TF"
  depends_on = [time_sleep.wait_30_seconds]
}

resource "databricks_grant" "storage_credential_sample_permission" {
  provider           = databricks.workspace
  storage_credential = databricks_storage_credential.external.id
  principal          = "account users" # For all users in the account-level
  privileges         = ["CREATE_EXTERNAL_TABLE"]
}

resource "databricks_external_location" "some" {
  provider        = databricks.workspace
  read_only       = false
  skip_validation = true
  force_destroy   = true
  name            = "${var.s3_prefix}_external_sample"
  url             = "s3://${aws_s3_bucket.external_location_bucket.id}/${var.s3_prefix}"
  credential_name = databricks_storage_credential.external.id
  comment         = "Sample resource managed by TF"
  depends_on      = [time_sleep.wait_30_seconds, databricks_storage_credential.external]
}

resource "databricks_grant" "ext_location_sample_permission" {
  provider          = databricks.workspace
  external_location = databricks_external_location.some.id
  principal         = "account users"
  privileges        = ["READ_FILES"]
}