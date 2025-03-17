# Output the repository ID to be referenced by other modules
output "repo_id" {
  description = "ID of the created Databricks repository"
  value       = databricks_repo.default_repo.id
}

# Output the Git provider information
output "git_provider" {
  description = "Git provider used for the repository"
  value       = databricks_repo.default_repo.git_provider
}

# Output the branch information
output "branch" {
  description = "Git branch being used for the repository"
  value       = databricks_repo.default_repo.branch
}
