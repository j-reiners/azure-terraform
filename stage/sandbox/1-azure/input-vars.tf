variable "client_secret" {
  description = "client secret azure rm"
  type        = string
  sensitive = true
}

variable "github_token" {
  description = "access token github"
  type        = string
  sensitive = true
}

variable "es_admin_password" {
  description = "elasticsearch admin password"
  type        = string
  sensitive = true
}