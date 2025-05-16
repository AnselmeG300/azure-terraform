resource "azurerm_public_ip" "iform-ip" {
  name                = "my-iform-public-ip-${local.name}"
  location            = var.location
  resource_group_name = "my-iform-rg-${local.name}"
  allocation_method   = "Dynamic"
  sku = "Basic"

 tags = {
    environment = var.environment
  }
}
