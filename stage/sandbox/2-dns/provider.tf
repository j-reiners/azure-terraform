terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.29.0"
    }

    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "4.30.0"
    }
  }
}

provider "kubernetes" {
  config_path    = "/home/jan/kubeconfig"
}

provider "cloudflare" {
  api_token = var.cloudflare_token
}