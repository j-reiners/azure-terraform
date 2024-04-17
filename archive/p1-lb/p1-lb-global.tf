resource "azurerm_resource_group" "p1_lb" {
  name     = "p1-lb"
  location = "germanywestcentral"
}

resource "azurerm_virtual_network" "p1_lb" {
  name                = "p1-lb"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.p1_lb.location
  resource_group_name = azurerm_resource_group.p1_lb.name
}

resource "azurerm_subnet" "p1_lb_subnet1" {
  name                 = "p1-lb-subnet1"
  resource_group_name  = azurerm_resource_group.p1_lb.name
  virtual_network_name = azurerm_virtual_network.p1_lb.name
  address_prefixes     = ["10.0.1.0/24"]
}