terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.98.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  client_id       = "bf9cf562-a4e8-47ce-a1e4-efb9ac9223db"
  client_secret   = var.client_secret
  tenant_id       = "b8fd94a7-4d48-458b-b80a-273abc64f531"
  subscription_id = "311159a2-3ede-41c1-a42e-3aa4ca99f856"
}