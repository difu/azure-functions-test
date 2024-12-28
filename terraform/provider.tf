  provider "azurerm" {
    subscription_id = var.subscription_id
    features {
      resource_group {
        prevent_deletion_if_contains_resources = false
      }
    }
  }

  variable "subscription_id" {
    description = "The subscription ID for the Azure provider"
    type        = string
  }