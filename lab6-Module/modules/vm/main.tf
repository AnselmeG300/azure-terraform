data "azurerm_platform_image" "iform-image" {
  location  = "West Europe"
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-focal"
  sku       = "18_04-lts"
}


resource "azurerm_virtual_machine_extension" "vm-extension" {
  name                 = "hostname"
  virtual_machine_id   = azurerm_linux_virtual_machine.tfiform-vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
    {
      "commandToExecute": "sudo apt-get install -y nginx ; sudo systemctl enable --now nginx"
    }
  SETTINGS

  tags = {
    environment = "my-terraform-env"
  }
}

resource "azurerm_network_interface" "tfiform-vnic" {
  name                = "my-iform-nic-${locals.name}"
  location            = azurerm_resource_group.tfiform-gp.location
  resource_group_name = azurerm_resource_group.tfiform-gp.name

  ip_configuration {
    name                          = "my-iform-nic-ip-${locals.name}"
    subnet_id                     = azurerm_subnet.tfiform-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tfiform.id
  }

  tags = {
    environment = "my-iform-env"
  }
}

resource "azurerm_linux_virtual_machine" "tfiform-vm" {
  name                            = "my-iform-vm-${locals.name}"
  location                        = var.rg-location
  resource_group_name             = var.rg-name
  network_interface_ids           = [azurerm_network_interface.tfiform-vnic.id]
  size                            = var.instance_template
  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  admin_password                  = "Password1234!"
  disable_password_authentication = false

    source_image_reference {
    publisher = data.azurerm_platform_image.iform-image.publisher
    offer     = data.azurerm_platform_image.iform-image.offer
    sku       = data.azurerm_platform_image.iform-image.sku
    version   = data.azurerm_platform_image.iform-image.version
  }
  
  os_disk {
    name                 = "my-iform-os-disk-${locals.name}"
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
   provisioner "local-exec" {
     command = "echo ${azurerm_linux_virtual_machine.tfiform-vm.name}:  ${azurerm_public_ip.tfiform-ip.ip_address} >> ip_address.txt"
	}
	
  tags = {
    environment = "my-iform-env"
  }
}