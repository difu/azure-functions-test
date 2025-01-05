terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

resource "random_integer" "random_number" {
  min = 10000
  max = 99999
}

resource "azurerm_function_app" "linuxfunction" {
  name = "${var.function_name}-${random_integer.random_number.result}"
  resource_group_name = var.resource_group.name
  location = var.resource_group.location
  storage_account_name = var.storage_account.name
  storage_account_access_key = var.storage_account.primary_access_key
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
    "AzureWebJobsStorage"      = var.storage_account.primary_access_key
    "WEBSITE_RUN_FROM_PACKAGE" = "https://${var.storage_account.name}.blob.core.windows.net/${var.storage_container_name}/${azurerm_storage_blob.function_upload_trigger_code_blob.name}"
    "FUNCTIONS_WORKER_RUNTIME" = "python"
    "APPINSIGHTS_INSTRUMENTATIONKEY" = var.instrumentation_key
  }
  # depends_on = [azurerm_application_insights.ai_function_app] # move this outside the module!!!!
}

resource "azurerm_service_plan" "serviceplan" {
  name                = "${var.function_name}-appserviceplan"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  os_type = "Linux"
  sku_name = "Y1"
}

# resource "azurerm_storage_container" "function_upload_code" {
#   name                  = "function-upload-code"
#   storage_account_id    = var.storage_account.id
#   container_access_type = "private"
# }

resource "azurerm_storage_blob" "function_upload_trigger_code_blob" {
  name                   = "${var.function_name}.zip"
  storage_account_name   = var.storage_account.name
  storage_container_name = var.storage_container_name
  type                   = "Block"
  source                 = "${var.function_name}.zip"
}

resource "null_resource" "build_zip_uploadTrigger" {
  # Triggers rebuild when files in the source directory change
  triggers = {
  checksum = join(
    "",
    [for file_path in fileset("${var.functions_path}/${var.function_name}", "**/*") : md5(file("${var.functions_path}/${var.function_name}/${file_path}"))]
  )  }

  provisioner "local-exec" {
    command = <<EOT
      mkdir -p ./build
      zip -r -j ${var.function_name}.zip ${var.functions_path}/${var.function_name}
    EOT
  }
  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      rm -rf ./build
    EOT
  }
}