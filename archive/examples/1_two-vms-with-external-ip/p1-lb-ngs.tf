resource "azurerm_network_security_group" "allow_ssh" {
  name                = "allow_ssh"
  location            = azurerm_resource_group.p1_lb.location
  resource_group_name = azurerm_resource_group.p1_lb.name

  security_rule {
    name                       = "allow_ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}