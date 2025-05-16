terraform {
  required_version = ">=1.11.4"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.26.0"
    }
  }
}


resource "azurerm_resource_group" "tfiform-gp" {
  name     = "my-iform-rg-${locals.name}"
  location = "West Europe"
}