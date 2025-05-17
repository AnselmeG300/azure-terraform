# This file is used to configure the provider and backend for the Terraform project.
# It specifies the required version of Terraform and the azurerm provider.
terraform {
  required_version = ">=1.11.4"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.26.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tf-backend-rg-anselme"
    storage_account_name = "iformstorage23anselme"
    container_name       = "tfstate"
    key                  = "backend.tfstate"
    subscription_id                 = "your-subscription-id"
  client_id = "your-client-id"
  client_secret = "your-client-secret"
  tenant_id = "your-tenant-id"
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