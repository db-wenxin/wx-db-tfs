// Wait on Credential Due to Race Condition
resource "null_resource" "previous" {}
resource "time_sleep" "wait_20_seconds" {
  depends_on      = [null_resource.previous]
  create_duration = "20s"
}

#################################################################################
# The Owner of following resources will be SP instead of indivudual account user #
##################################################################################
resource "databricks_storage_credential" "external" {
  provider = databricks.workspace
  name     = aws_iam_role.external_data_access.name
  aws_iam_role {
    role_arn = aws_iam_role.external_data_access.arn
  }
  comment    = "Sample resource managed by TF"
  depends_on = [time_sleep.wait_20_seconds]
}

resource "databricks_external_location" "some" {
  provider        = databricks.workspace
  name            = "external_sample"
  url             = "s3://${aws_s3_bucket.external_location_bucket.id}/${var.s3_prefix}"
  credential_name = databricks_storage_credential.external.id
  comment         = "Sample resource managed by TF"
  depends_on      = [time_sleep.wait_20_seconds, databricks_storage_credential.external]
}
