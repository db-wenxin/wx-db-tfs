variable "existing_acct_level_users" {
  description = "Map of users and their permissions"
  type        = map(list(string))
  default = {
    "user1@example.com" = ["ADMIN"],
    "user2@example.com" = ["USER"]
    // Add more users and their permissions as needed
  }
}

variable "databricks_account_id" {
  type      = string
  sensitive = true
}

variable "client_id" {
  type      = string
  sensitive = true
}

variable "client_secret" {
  type      = string
  sensitive = true
}

variable "workspace_id" {
  type = string
}