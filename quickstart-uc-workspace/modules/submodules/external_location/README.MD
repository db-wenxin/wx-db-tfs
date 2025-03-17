# Sample Terraform - Create a new external location

This is a sample Terraform code that creates a new Databricks external location and related AWS resources. The authentication details for the AWS provider (using environment variables) are not included in this example. [A PAT (Personal Authentication Token)](https://docs.databricks.com/en/security/auth-authz/api-access-permissions.html) is needed to authenticate the Databricks provider. To create a new PAT for your Databricks workspace as the admin user:
1. Go to the workspace "User Settings" page.
2. Click the "Developer" tab.
3. Click the "Manage" button next to Access tokens to open the token permissions editor.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.25.0 |
| <a name="provider_databricks.ws"></a> [databricks.ws](#provider\_databricks.ws) | 1.30.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.external_data_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.external_data_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_kms_key.sample_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.external_location_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.external](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [databricks_external_location.some](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/external_location) | resource |
| [databricks_storage_credential.external](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/storage_credential) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.passrole_for_uc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sample_kms_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_databricks_account_id"></a> [databricks\_account\_id](#input\_databricks\_account\_id) | Find your account ID at https://accounts.cloud.databricks.com | `string` | n/a | yes |
| <a name="input_iam_role_name"></a> [iam\_role\_name](#input\_iam\_role\_name) | The IAM role name you want to give to the new IAM role created for storage credential. | `string` | n/a | yes |
| <a name="input_pat_token"></a> [pat\_token](#input\_pat\_token) | A personal access token for your Databricks account. | `string` | n/a | yes |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | The S3 bucket you want to register as the new external location. | `string` | n/a | yes |
| <a name="input_s3_prefix"></a> [s3\_prefix](#input\_s3\_prefix) | The S3 prefix to be used for the Databricks external location URL. If set to empty, the S3 bucket's root path will be used instead. | `string` | `""` | no |
| <a name="input_workspace_url"></a> [workspace\_url](#input\_workspace\_url) | Url of your workspace. | `string` | n/a | yes |


## Folder Structure
```
├── README.MD
├── aws.tf
├── disclaimer.md
├── external_location.tf
├── provider.tf
├── test.auto.tfvars.example
└── variables.tf
```
## Outputs
n/a