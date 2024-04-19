data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "aks1" {
  name = var.resource_group_name

  depends_on = [
    azurerm_kubernetes_cluster.aks1
  ]
}

resource "azurerm_key_vault" "aks1" {
  name                          = var.vault_name
  location                      = data.azurerm_resource_group.aks1.location
  resource_group_name           = data.azurerm_resource_group.aks1.name
  enabled_for_disk_encryption   = true
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days    = 7
  purge_protection_enabled      = false

  sku_name = "standard"
}

resource "azurerm_key_vault_access_policy" "aks1_terraform" {
  key_vault_id = azurerm_key_vault.aks1.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  certificate_permissions = [
    "Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"
  ]

  key_permissions = [
    "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"
  ]

  secret_permissions = [
    "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
  ]

  storage_permissions = [
    "Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"
  ]

  depends_on = [ 
    azurerm_key_vault.aks1
  ]
}

// kubernetes cluster
resource "azurerm_key_vault_access_policy" "aks1_kubernetes" {
  key_vault_id = azurerm_key_vault.aks1.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_kubernetes_cluster.aks1.key_vault_secrets_provider[0].secret_identity[0].object_id

  # cluster access to secrets should be read-only
  secret_permissions = [
    "Get", "List"
  ]
}

locals {
  key_vault_secrets = [{
    name   = "github-token"
    value  = var.github_token
    key_vault_id = azurerm_key_vault.aks1.id
  },
  {
    name   = "es-admin-password"
    value  = var.es_admin_password
    key_vault_id = azurerm_key_vault.aks1.id
  }]
}

module "key_vault_secret" {
  for_each = { for secret in local.key_vault_secrets :  secret.name => secret}
  source = "../../../modules/key_vault_secret"

  providers = {
    azurerm = azurerm
  }

  name          = each.value.name
  value         = each.value.value
  key_vault_id  = azurerm_key_vault.aks1.id
}