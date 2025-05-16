resource "azurerm_resource_group" "iform-rg" {
  name     = "my-iform-rg-${locals.name}"
  location = var.location
  tags = {
    environment = var.environment
  }
}
