resource "azurerm_resource_group" "aks1" {
  name     = var.resource_group_name
  location = "germanywestcentral"
}