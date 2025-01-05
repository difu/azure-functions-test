resource "azurerm_role_assignment" "functionUpload_to_storage" {
  # principal_id   = azurerm_function_app.linuxfunction_upload_trigger.identity[0].principal_id
  principal_id = module.uploadTriggerFunction.principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope          = azurerm_storage_account.storageacct.id
}