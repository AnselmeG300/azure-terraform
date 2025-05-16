provider "azurerm" {
  features {
  }
  resource_provider_registrations = "none"
  subscription_id                 = "your-subscription-id"
  client_id = "your-client-id"
  client_secret = "your-client-secret"
  tenant_id = "your-tenant-id"
}

# Création du Resource Group pour le backend
resource "azurerm_resource_group" "tf_backend" {
  name     = "tf-backend-rg-${local.name}"
  location = "westeurope"
}

# Création du Storage Account pour stocker l'état Terraform
resource "azurerm_storage_account" "tf_state" {
  name                     = "iformstorage23${local.name}" # unique
  resource_group_name      = azurerm_resource_group.tf_backend.name
  location                 = azurerm_resource_group.tf_backend.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Création du Storage Container pour stocker les fichiers d'état
resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.tf_state.id
  container_access_type = "private"
}

output "resource_group_name" {
  value = azurerm_resource_group.tf_backend.name
}

output "storage_account_name" {
  value = azurerm_storage_account.tf_state.name
}

output "container_name" {
  value = azurerm_storage_container.tfstate.name
}
