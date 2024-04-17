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
   host                   = data.azurerm_kubernetes_cluster.aks1.kube_config[0].host
   client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks1.kube_config[0].client_certificate)
   client_key             = base64decode(data.azurerm_kubernetes_cluster.aks1.kube_config[0].client_key)
   cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks1.kube_config[0].cluster_ca_certificate)
 }
}