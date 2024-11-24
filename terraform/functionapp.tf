resource "azurerm_function_app" "linuxfunction" {
  name = "linuxfunctionapp-difu"
  resource_group_name = azurerm_resource_group.functiontest.name
  location = azurerm_resource_group.functiontest.location
  storage_account_name = azurerm_storage_account.storageacct.name
  storage_account_access_key = azurerm_storage_account.storageacct.primary_access_key
  // service_plan_id = azurerm_service_plan.serviceplan.id
  app_service_plan_id = azurerm_service_plan.serviceplan.id
  site_config {}

  identity {
    type = "SystemAssigned"
  }
}