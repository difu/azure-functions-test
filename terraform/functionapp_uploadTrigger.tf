variable "source_dir_uploadTrigger" {
  default = "../function/BlobUploadTrigger/"
}

variable "output_zip_uploadTrigger" {
  default = "./build/function_uploadTrigger.zip"
}

resource "null_resource" "build_zip_uploadTrigger" {
  # Triggers rebuild when files in the source directory change
  triggers = {
  checksum = join(
    "",
    [for file_path in fileset(var.source_dir_uploadTrigger, "**/*") : md5(file("${var.source_dir_uploadTrigger}/${file_path}"))]
  )  }

  provisioner "local-exec" {
    command = <<EOT
      mkdir -p ./build
      zip -r -j ${var.output_zip_uploadTrigger} ${var.source_dir_uploadTrigger}
    EOT
  }
  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      rm -rf ./build
    EOT
  }
}

# Storage Blob Trigger Function Code Deployment
resource "azurerm_storage_blob" "function_upload_trigger_code_blob" {
  name                   = "function_upload_trigger.zip"
  storage_account_name   = azurerm_storage_account.storageacct.name
  storage_container_name = azurerm_storage_container.function_upload_code.name
  type                   = "Block"
  source                 = var.output_zip_uploadTrigger
}

resource "azurerm_function_app" "linuxfunction_upload_trigger" {
  name = "linuxfunctionapp-uploadTrigger"
  resource_group_name = azurerm_resource_group.functiontest.name
  location = azurerm_resource_group.functiontest.location
  storage_account_name = azurerm_storage_account.storageacct.name
  storage_account_access_key = azurerm_storage_account.storageacct.primary_access_key
  app_service_plan_id = azurerm_service_plan.serviceplan.id
  os_type = "linux"
  site_config {
    linux_fx_version = "python|3.9"
  }

  identity {
    type = "SystemAssigned"
  }
  version                    = "~4"
  app_settings = {
    "AzureWebJobsStorage"      = azurerm_storage_account.storageacct.primary_connection_string
    "WEBSITE_RUN_FROM_PACKAGE" = "https://${azurerm_storage_account.storageacct.name}.blob.core.windows.net/${azurerm_storage_container.function_upload_code.name}/${azurerm_storage_blob.function_upload_trigger_code_blob.name}"
    "FUNCTIONS_WORKER_RUNTIME" = "python"
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.ai_function_app.instrumentation_key

  }
  depends_on = [azurerm_application_insights.ai_function_app]
}

resource "azurerm_application_insights" "ai_function_app" {
  name                = "functions-app-insights"
  location            = azurerm_resource_group.functiontest.location
  resource_group_name = azurerm_resource_group.functiontest.name
  application_type    = "web"
}