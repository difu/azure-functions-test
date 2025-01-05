output "principal_id" {
  value = azurerm_function_app.linuxfunction.identity[0].principal_id
}

output "unique_function_app_name" {
  value = azurerm_function_app.linuxfunction.name
}