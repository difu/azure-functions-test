  provider "azurerm" {
    subscription_id = var.subscription_id
    features {}
  }

  variable "subscription_id" {
    description = "The subscription ID for the Azure provider"
    type        = string
  }