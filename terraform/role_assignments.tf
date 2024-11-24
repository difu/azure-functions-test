resource "azurerm_role_assignment" "function_to_storage" {
  principal_id   = azurerm_function_app.linuxfunction.identity[0].principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope          = azurerm_storage_account.storageacct.id
}