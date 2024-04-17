resource "azurerm_public_ip" "p1_lb_loadbalancer_public_ip" {
  name                = "p1_lb_loadbalancer"
  resource_group_name = azurerm_resource_group.p1_lb.name
  location            = azurerm_resource_group.p1_lb.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# allow http
# Associate the Network Security Group to the subnet
resource "azurerm_subnet_network_security_group_association" "loadbalancer1" {
  subnet_id                 = azurerm_subnet.p1_lb_subnet1.id
  network_security_group_id = azurerm_network_security_group.allow_http.id
}

# Create Public Load Balancer
resource "azurerm_lb" "loadbalancer1" {
  name                = "loadbalancer1"
  location            = azurerm_resource_group.p1_lb.location
  resource_group_name = azurerm_resource_group.p1_lb.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "loadbalancer1"
    public_ip_address_id = azurerm_public_ip.p1_lb_loadbalancer_public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "loadbalancer1" {
  loadbalancer_id      = azurerm_lb.loadbalancer1.id
  name                 = "test-pool"
}

resource "azurerm_lb_probe" "loadbalancer1" {
  loadbalancer_id     = azurerm_lb.loadbalancer1.id
  name                = "test-probe"
  port                = 80
}

resource "azurerm_lb_rule" "loadbalancer1" {
  loadbalancer_id                = azurerm_lb.loadbalancer1.id
  name                           = "test-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  disable_outbound_snat          = true
  frontend_ip_configuration_name = "loadbalancer1"
  probe_id                       = azurerm_lb_probe.loadbalancer1.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.loadbalancer1.id]
}

resource "azurerm_lb_outbound_rule" "loadbalancer1" {
  name                    = "test-outbound"
  loadbalancer_id         = azurerm_lb.loadbalancer1.id
  protocol                = "Tcp"
  backend_address_pool_id = azurerm_lb_backend_address_pool.loadbalancer1.id

  frontend_ip_configuration {
    name = "loadbalancer1"
  }
}