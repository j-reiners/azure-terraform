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

# Create Network Security Group and rules
resource "azurerm_network_security_group" "allow_http" {
  name                = "allow_http"
  location            = azurerm_resource_group.p1_lb.location
  resource_group_name = azurerm_resource_group.p1_lb.name

  security_rule {
    name                       = "web"
    priority                   = 1008
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.1.0/24"
  }
}