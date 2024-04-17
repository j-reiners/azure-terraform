terraform {
  backend "http" {
    address = "https://gitlab.quambel.de/api/v4/projects/4/terraform/state/sandbox-kickstart"
    lock_address = "https://gitlab.quambel.de/api/v4/projects/4/terraform/state/sandbox-kickstart/lock"
    unlock_address = "https://gitlab.quambel.de/api/v4/projects/4/terraform/state/sandbox-kickstart/lock"
    lock_method = "POST"
    unlock_method = "DELETE"
  }
}