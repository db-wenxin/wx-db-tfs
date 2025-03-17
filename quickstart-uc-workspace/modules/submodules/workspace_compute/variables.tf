# variable "pat_token" {
#   // To get a personal access token: https://docs.databricks.com/en/administration-guide/access-control/tokens.html
#   type        = string
#   description = "A personal access token for your Databricks account."
#   sensitive   = true
# }

variable "client_id" {
  type      = string
  sensitive = true
}

variable "client_secret" {
  type      = string
  sensitive = true
}
