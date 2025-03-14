variable "git_provider" {
  type = string
}

variable "git_branch" {
  type = string
}

variable "git_url" {
  type = string
}
variable "git_username" {
  type = string
}

variable "git_personal_access_token" {
  type      = string
  sensitive = true
}

variable "git_folder_path" {
  type    = string
  default = "/Repos/github/sandbox_sample"
}