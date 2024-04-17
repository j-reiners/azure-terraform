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
  address_prefixes     = ["10.0.2.0/24"]
}

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

### VM1
resource "azurerm_public_ip" "p1_lb_vm1" {
  name                = "p1_lb_vm1"
  resource_group_name = azurerm_resource_group.p1_lb.name
  location            = azurerm_resource_group.p1_lb.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "p1_lb_vm1" {
  name                = "p1-lb-vm1"
  location            = azurerm_resource_group.p1_lb.location
  resource_group_name = azurerm_resource_group.p1_lb.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.p1_lb_subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.p1_lb_vm1.id
  }
}

resource "azurerm_network_interface_security_group_association" "p1_lb_vm1_ssh" {
  network_interface_id      = azurerm_network_interface.p1_lb_vm1.id
  network_security_group_id = azurerm_network_security_group.allow_ssh.id
}

resource "azurerm_linux_virtual_machine" "p1_lb_vm1" {
  name                = "p1-lb-vm1"
  resource_group_name = azurerm_resource_group.p1_lb.name
  location            = azurerm_resource_group.p1_lb.location
  size                = "Standard_B2ats_v2"
  admin_username      = "jan"
  computer_name       = "apps1-azure"

  network_interface_ids = [
    azurerm_network_interface.p1_lb_vm1.id
  ]

  admin_ssh_key {
    username   = "jan"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9hVXpFbqkSmU4+bsBV00hKrTwwLAZjzoEg4SCNuL7cjipP5Cs2uoEljJNulhn1POKT5tpSUZ8CWone+ELHLBUV0/a7h5sxHTgV9gf4axhw3cRSThxGccLoenQj9WTLgi9qOyHCBlDujyand4si0k9tDuQMfxHyQ4gvfoyNr0yZviq/JO4hkeET9BxFfLSnYgdEeL0W41Nus3zAU9QQEAQL/5LgHi6E1QLPpHfqmNoJ3DtijD3zOCRZya2dk5xGO1xmUb9WkB8CFC5MbsSk1qw0uDt5qt67G1BqgzPaeZ3iOn7ktYiwKSugpghi+cys25XNKOfEv5Po78SlgKVmBHpWaxhkQJQ5SX73tG748tYYhLzMXeNqISJNmdlCkh4nkYdetJQyXkjTNctX1Op63P/AAf9WEh8fOmBChoWe0KpndQulRJTjOFcL4WK2xoTlcn+oMl05sim5rm2jXvEAcUM6VA/iXSYxncLji3wDgoTM1V6ECasAZTiRjTl6HyxS3kbquFRcMhtgYYytqsgUgz87ZDEs3cnTU0OUypc9HGbYe42DLpEUMuR7dtF7kVkmCV+Jiva5Kbc86dwMr0S+KnV1muKp24E3mChLSxUCWOVw5qOno6z9nu/JCHHcV+ln/sIjLiS1m4VsSMExwiD2uJ7BzhkQxaEnIW7+38IXBcAYw== jan@elitebook"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

output "p1_lb_vm1_public_ip" {
  value = azurerm_public_ip.p1_lb_vm1.ip_address
}


## VM2
resource "azurerm_public_ip" "p1_lb_vm2" {
  name                = "p1_lb_vm2"
  resource_group_name = azurerm_resource_group.p1_lb.name
  location            = azurerm_resource_group.p1_lb.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "p1_lb_vm2" {
  name                = "p1-lb-vm2"
  location            = azurerm_resource_group.p1_lb.location
  resource_group_name = azurerm_resource_group.p1_lb.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.p1_lb_subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.p1_lb_vm2.id
  }
}

resource "azurerm_network_interface_security_group_association" "p1_lb_vm2_ssh" {
  network_interface_id      = azurerm_network_interface.p1_lb_vm2.id
  network_security_group_id = azurerm_network_security_group.allow_ssh.id
}

resource "azurerm_linux_virtual_machine" "p1_lb_vm2" {
  name                = "p1-lb-vm2"
  resource_group_name = azurerm_resource_group.p1_lb.name
  location            = azurerm_resource_group.p1_lb.location
  size                = "Standard_B2ats_v2"
  admin_username      = "jan"
  computer_name       = "apps2-azure"

  network_interface_ids = [
    azurerm_network_interface.p1_lb_vm2.id
  ]

  admin_ssh_key {
    username   = "jan"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9hVXpFbqkSmU4+bsBV00hKrTwwLAZjzoEg4SCNuL7cjipP5Cs2uoEljJNulhn1POKT5tpSUZ8CWone+ELHLBUV0/a7h5sxHTgV9gf4axhw3cRSThxGccLoenQj9WTLgi9qOyHCBlDujyand4si0k9tDuQMfxHyQ4gvfoyNr0yZviq/JO4hkeET9BxFfLSnYgdEeL0W41Nus3zAU9QQEAQL/5LgHi6E1QLPpHfqmNoJ3DtijD3zOCRZya2dk5xGO1xmUb9WkB8CFC5MbsSk1qw0uDt5qt67G1BqgzPaeZ3iOn7ktYiwKSugpghi+cys25XNKOfEv5Po78SlgKVmBHpWaxhkQJQ5SX73tG748tYYhLzMXeNqISJNmdlCkh4nkYdetJQyXkjTNctX1Op63P/AAf9WEh8fOmBChoWe0KpndQulRJTjOFcL4WK2xoTlcn+oMl05sim5rm2jXvEAcUM6VA/iXSYxncLji3wDgoTM1V6ECasAZTiRjTl6HyxS3kbquFRcMhtgYYytqsgUgz87ZDEs3cnTU0OUypc9HGbYe42DLpEUMuR7dtF7kVkmCV+Jiva5Kbc86dwMr0S+KnV1muKp24E3mChLSxUCWOVw5qOno6z9nu/JCHHcV+ln/sIjLiS1m4VsSMExwiD2uJ7BzhkQxaEnIW7+38IXBcAYw== jan@elitebook"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

output "p1_lb_vm2_public_ip" {
  value = azurerm_public_ip.p1_lb_vm2.ip_address
}