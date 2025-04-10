resource "azurerm_storage_account" "storageacct" {
  name                     = "functionstoraceaccount"
  resource_group_name      = azurerm_resource_group.functiontest.name
  location                 = azurerm_resource_group.functiontest.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
  name                  = "userblobs"
  storage_account_id    = azurerm_storage_account.storageacct.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "function_upload_code" {
  name                  = "function-upload-code"
  storage_account_id    = azurerm_storage_account.storageacct.id
  container_access_type = "private"
}
