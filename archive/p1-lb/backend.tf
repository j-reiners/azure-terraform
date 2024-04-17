terraform {
  backend "http" {
    address = "https://gitlab.quambel.de/api/v4/projects/4/terraform/state/prod"
    lock_address = "https://gitlab.quambel.de/api/v4/projects/4/terraform/state/prod/lock"
    unlock_address = "https://gitlab.quambel.de/api/v4/projects/4/terraform/state/prod/lock"
    lock_method = "POST"
    unlock_method = "DELETE"
  }
}