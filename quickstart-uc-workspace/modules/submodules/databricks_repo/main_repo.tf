resource "databricks_repo" "default_repo" {
  git_provider = var.git_provider
  url          = var.git_url
  branch       = var.git_branch
  path         = var.git_folder_path
}
resource "databricks_git_credential" "default_repo_cred" {
  git_username          = var.git_username
  git_provider          = var.git_provider
  personal_access_token = var.git_personal_access_token
}
