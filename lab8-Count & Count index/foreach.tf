
resource "azurerm_resource_group" "rg" {
  name     = "iform-rg-${local.name}"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-tp2-${local.name}"
  address_space       = local.address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-tp2-${local.name}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = local.address_prefixes
}

resource "azurerm_network_interface" "nic" {
  for_each = toset(["vm1", "vm2", "vm3"])

  name                = "${each.key}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each = azurerm_network_interface.nic

  name                  = each.key
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [each.value.id]
  size                  = "Standard_B1s"
  admin_username        = "azureuser"

  disable_password_authentication = false
  admin_password                  = "Anselme@2024!"  # à changer si besoin

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "${each.key}-osdisk"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20_04-lts"
    version   = "latest"
  }
}
