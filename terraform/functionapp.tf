resource "azurerm_function_app" "linuxfunction" {
  name = "linuxfunctionapp-difu"
  resource_group_name = azurerm_resource_group.functiontest.name
  location = azurerm_resource_group.functiontest.location
  storage_account_name = azurerm_storage_account.storageacct.name
  storage_account_access_key = azurerm_storage_account.storageacct.primary_access_key
  app_service_plan_id = azurerm_service_plan.serviceplan.id
  site_config {
    linux_fx_version = "python|3.9"
  }

  identity {
    type = "SystemAssigned"
  }
  version                    = "~4"
  app_settings = {
    "AzureWebJobsStorage"      = azurerm_storage_account.storageacct.primary_connection_string
    "WEBSITE_RUN_FROM_PACKAGE" = "https://${azurerm_storage_account.storageacct.name}.blob.core.windows.net/function-code/${azurerm_storage_blob.function_code_blob.name}"
    "FUNCTIONS_WORKER_RUNTIME" = "python"
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.ai_function_app.instrumentation_key

  }
}

resource "azurerm_application_insights" "ai_function_app" {
  name                = "functions-app-insights"
  location            = azurerm_resource_group.functiontest.location
  resource_group_name = azurerm_resource_group.functiontest.name
  application_type    = "web"
}