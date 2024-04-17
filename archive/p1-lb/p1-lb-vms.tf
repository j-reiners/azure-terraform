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

resource "azurerm_network_interface" "p1_lb_vms_nic" {
  for_each            = local.virtual_machines
  name                = "p1-lb-nic-${each.key}"
  location            = azurerm_resource_group.p1_lb.location
  resource_group_name = azurerm_resource_group.p1_lb.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.p1_lb_subnet1.id
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id = azurerm_public_ip.p1_lb_vms_public_ip[each.key].id
    primary = true
  }
}

# Associate Network Interface to the Backend Pool of the Load Balancer
resource "azurerm_network_interface_backend_address_pool_association" "my_nic_lb_pool" {
  for_each            = local.virtual_machines
  network_interface_id    = azurerm_network_interface.p1_lb_vms_nic[each.key].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.loadbalancer1.id
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

# Enable virtual machine extension and install Nginx
resource "azurerm_virtual_machine_extension" "my_vm_extension" {
  for_each            = local.virtual_machines
  name                 = "Nginx"
  virtual_machine_id   = azurerm_linux_virtual_machine.p1_lb_vms[each.key].id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
 {
  "commandToExecute": "sudo apt-get update && sudo apt-get install nginx -y && echo \"Hello World from $(hostname)\" > /var/www/html/index.html && sudo systemctl restart nginx"
 }
SETTINGS

}