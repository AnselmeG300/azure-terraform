resource "azurerm_public_ip" "iform-ip" {
  name                = "my-iform-public-ip-${locals.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  sku = "Basic"

 tags = {
    environment = var.environment
  }
}
