resource "azurerm_service_plan" "serviceplan" {
  name                = "function-appserviceplan"
  location            = azurerm_resource_group.functiontest.location
  resource_group_name = azurerm_resource_group.functiontest.name
  os_type = "Linux"
  sku_name = "Y1"
}