terraform {
  required_version = ">=1.11.4"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.26.0"
    }
  }
}
provider "azurerm" {
  features {
  }
  resource_provider_registrations = "none"
  subscription_id                 = "your-subscription-id"
  client_id = "your-client-id"
  client_secret = "your-client-secret"
  tenant_id = "your-tenant-id"
}