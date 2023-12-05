// Example of assigning existing account-level users to the workspace
data "databricks_user" "existing_users" {
  for_each  = var.existing_acct_level_users
  user_name = each.key
}

resource "databricks_mws_permission_assignment" "add_users_to_workspace" {
  for_each     = data.databricks_user.existing_users
  workspace_id = var.workspace_id
  principal_id = each.value.id
  permissions  = var.existing_acct_level_users[each.key]
}