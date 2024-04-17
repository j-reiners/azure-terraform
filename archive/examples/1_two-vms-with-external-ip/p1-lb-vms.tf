### VMs
locals {
  virtual_machines = {
    "vm1" = {
      hostname = "apps1-azure", zone = "us-central1-a"
    },
    "vm2" = {
      hostname = "apps2-azure", zone = "us-central1-b"
    }
  }
}

resource "azurerm_public_ip" "p1_lb_vms_public_ip" {
  for_each            = local.virtual_machines
  name                = "p1_lb_${each.key}"
  resource_group_name = azurerm_resource_group.p1_lb.name
  location            = azurerm_resource_group.p1_lb.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "p1_lb_vms_nic" {
  for_each            = local.virtual_machines
  name                = "p1-lb-_${each.key}"
  location            = azurerm_resource_group.p1_lb.location
  resource_group_name = azurerm_resource_group.p1_lb.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.p1_lb_subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.p1_lb_vms_public_ip[each.key].id
  }
}

resource "azurerm_network_interface_security_group_association" "p1_lb_vms_allow_ssh" {
  for_each            = local.virtual_machines
  network_interface_id      = azurerm_network_interface.p1_lb_vms_nic[each.key].id
  network_security_group_id = azurerm_network_security_group.allow_ssh.id
}

resource "azurerm_linux_virtual_machine" "p1_lb_vms" {
  for_each            = local.virtual_machines
  name                = "p1-lb-${each.key}"
  resource_group_name = azurerm_resource_group.p1_lb.name
  location            = azurerm_resource_group.p1_lb.location
  size                = "Standard_B2ats_v2"
  admin_username      = "jan"
  computer_name       = each.value.hostname

  network_interface_ids = [
    azurerm_network_interface.p1_lb_vms_nic[each.key].id
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