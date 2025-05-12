/**
 * Workspace-level resources for Databricks Serverless Workspace
 * Uses databricks.workspace provider
 */

# Unity Catalog metastore assignment
resource "databricks_metastore_assignment" "serverless_metastore" {
  provider     = databricks.workspace
  workspace_id = var.workspace_id
  metastore_id = var.metastore_id
}

# User and group assignment from existing_acct_level_users
resource "databricks_user" "workspace_users" {
  for_each  = var.existing_acct_level_users
  provider  = databricks.workspace
  user_name = each.key
  force     = true
}

# Assign users to workspace with their permissions
resource "databricks_mws_permission_assignment" "add_users_to_workspace" {
  for_each     = databricks_user.workspace_users
  provider     = databricks.mws
  workspace_id = var.workspace_id
  principal_id = each.value.id
  permissions  = var.existing_acct_level_users[each.key]
}

# Create a Git repository if needed
resource "databricks_git_credential" "git_credential" {
  count    = var.create_default_repo ? 1 : 0
  provider = databricks.workspace

  git_username          = var.git_username
  git_provider          = var.git_provider
  personal_access_token = var.git_personal_access_token
}

resource "databricks_repo" "default_repo" {
  count    = var.create_default_repo ? 1 : 0
  provider = databricks.workspace
  url      = var.git_url
  path     = var.git_folder_path
  depends_on = [
    databricks_git_credential.git_credential
  ]
} 