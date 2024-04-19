terraform {
  backend "http" {
    address = "https://gitlab.quambel.de/api/v4/projects/4/terraform/state/sandbox-kubernetes"
    lock_address = "https://gitlab.quambel.de/api/v4/projects/4/terraform/state/sandbox-kubernetes/lock"
    unlock_address = "https://gitlab.quambel.de/api/v4/projects/4/terraform/state/sandbox-kubernetes/lock"
    lock_method = "POST"
    unlock_method = "DELETE"
  }
}