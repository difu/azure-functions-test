resource "azurerm_storage_account" "storageacct" {
  name                     = "functionstoraceaccount"
  resource_group_name      = azurerm_resource_group.functiontest.name
  location                 = azurerm_resource_group.functiontest.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
  name                  = "my-container"
  storage_account_name  = azurerm_storage_account.storageacct.name
  container_access_type = "private"
}