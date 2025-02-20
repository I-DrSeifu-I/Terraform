#key vault used for local admin creds
data "azurerm_key_vault" "KVforLocaladmin" {
  name                = var.keyvaultname
  resource_group_name = var.keyvaultRG
}

#key vault secret for local admin password
data "azurerm_key_vault_secret" "KVsecret" {
  name         = var.keyvaultsecretname
  key_vault_id = data.azurerm_key_vault.KVforLocaladmin.id
}
