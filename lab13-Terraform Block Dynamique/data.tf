data "azurerm_platform_image" "iform-image" {
  location  ="West Europe"
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-focal"
  sku       = "20_04-lts"
}
