resource "azurerm_storage_account" "storageacct" {
  name                     = "functionstoraceaccount"
  resource_group_name      = azurerm_resource_group.functiontest.name
  location                 = azurerm_resource_group.functiontest.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
  name                  = "uploadedblobs"
  storage_account_id    = azurerm_storage_account.storageacct.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "function_code" {
  name                  = "function-code"
  storage_account_id    = azurerm_storage_account.storageacct.id
  container_access_type = "private"
}

# Storage Blob Trigger Function Code Deployment
resource "azurerm_storage_blob" "function_code_blob" {
  name                   = "function.zip"
  storage_account_name   = azurerm_storage_account.storageacct.name
  storage_container_name = azurerm_storage_container.function_code.name
  type                   = "Block"
  source                 = "${path.module}/function_code.zip"
}