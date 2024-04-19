resource "azurerm_kubernetes_cluster" "aks1" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.aks1.location
  resource_group_name = azurerm_resource_group.aks1.name
  dns_prefix          = "aks1"
#   automatic_channel_upgrade = none
  kubernetes_version = "1.27.9"
  # reuqires LTSRequiresPremiumTier
  #support_plan = "AKSLongTermSupport"

  default_node_pool {
    name       = "agentpool"
    // maximal aktuell 4 VMS erlaubt im free tier
    // 3 master automatishc dabei
    node_count = 1
    # vm_size    = "Standard_D2_v2"
    vm_size    = "Standard_E4as_v5"
  }

  identity {
    type = "SystemAssigned"
  }

  // aktiviert den namespace app-routing-system nginx ingress controller mit auto loadbalancer und ext-ip
  web_app_routing {
    dns_zone_id = ""
  }

  // aktiviert azure key vaul tprovider
  key_vault_secrets_provider {
    secret_rotation_enabled = false
  }

  linux_profile {
    admin_username = "jan"

    ssh_key {
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9hVXpFbqkSmU4+bsBV00hKrTwwLAZjzoEg4SCNuL7cjipP5Cs2uoEljJNulhn1POKT5tpSUZ8CWone+ELHLBUV0/a7h5sxHTgV9gf4axhw3cRSThxGccLoenQj9WTLgi9qOyHCBlDujyand4si0k9tDuQMfxHyQ4gvfoyNr0yZviq/JO4hkeET9BxFfLSnYgdEeL0W41Nus3zAU9QQEAQL/5LgHi6E1QLPpHfqmNoJ3DtijD3zOCRZya2dk5xGO1xmUb9WkB8CFC5MbsSk1qw0uDt5qt67G1BqgzPaeZ3iOn7ktYiwKSugpghi+cys25XNKOfEv5Po78SlgKVmBHpWaxhkQJQ5SX73tG748tYYhLzMXeNqISJNmdlCkh4nkYdetJQyXkjTNctX1Op63P/AAf9WEh8fOmBChoWe0KpndQulRJTjOFcL4WK2xoTlcn+oMl05sim5rm2jXvEAcUM6VA/iXSYxncLji3wDgoTM1V6ECasAZTiRjTl6HyxS3kbquFRcMhtgYYytqsgUgz87ZDEs3cnTU0OUypc9HGbYe42DLpEUMuR7dtF7kVkmCV+Jiva5Kbc86dwMr0S+KnV1muKp24E3mChLSxUCWOVw5qOno6z9nu/JCHHcV+ln/sIjLiS1m4VsSMExwiD2uJ7BzhkQxaEnIW7+38IXBcAYw== jan@elitebook"
    }
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }

  tags = {
    Environment = "sandbox"
  }
}

data "azurerm_kubernetes_cluster" "aks1" {
  name                = var.aks_cluster_name
  resource_group_name = azurerm_resource_group.aks1.name

  depends_on = [ 
    azurerm_kubernetes_cluster.aks1
  ]
}