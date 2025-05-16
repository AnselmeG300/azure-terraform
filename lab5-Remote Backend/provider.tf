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
    storage_account_name = "iformstorageanselme"
    container_name       = "tfstate"
    key                  = "backend.tfstate"
    subscription_id                 = ""
    client_id = ""
    client_secret = ""
    tenant_id = ""
  }
}

provider "azurerm" {
  features {
  }
  resource_provider_registrations = "none"
  subscription_id                 = ""
  client_id = ""
  client_secret = ""
  tenant_id = ""
}