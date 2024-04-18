terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.98.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = "2.13.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.29.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

provider "helm" {
  # Configuration options
  kubernetes {
   config_path    = "/home/jan/kubeconfig"
 }
}

provider "kubernetes" {
  config_path    = "/home/jan/kubeconfig"
}
