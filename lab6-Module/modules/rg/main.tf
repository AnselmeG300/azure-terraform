resource "azurerm_resource_group" "iform-rg" {
  name     = "my-iform-rg-${local.name}"
  location = var.location
  tags = {
    environment = var.environment
  }
}
