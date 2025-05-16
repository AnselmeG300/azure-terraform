# Image Ubuntu 20.04 LTS
data "azurerm_platform_image" "iform-image" {
  location  = var.location
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-focal"
  sku       = "20_04-lts"
}


# Create a Public IP for the VM
resource "azurerm_public_ip" "iform-ip" {
  name                = "my-iform-public-ip-${local.name}"
  location            = var.location
  resource_group_name = "my-iform-rg-${local.name}"
  allocation_method   = "Dynamic"
  sku                 = "Basic"
  tags = {
    environment = var.environment
  }
}

# Create a Virtual Machine
resource "azurerm_linux_virtual_machine" "iform-vm" {
  name                            = "my-iform-vm-${local.name}"
  location                        = var.location
  resource_group_name             = "my-iform-rg-${local.name}"
  network_interface_ids           = [var.network_interface_id]
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
    name                 = "my-iform-os-disk-${local.name}"
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  provisioner "file" {
    source      = "../scripts/install.sh"               # Local script
    destination = "/home/azureuser/install.sh"       # Remote path
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/azureuser/install.sh",
      "sudo /home/azureuser/install.sh"
    ]
  }

  # Connection block for provisioning
  connection {
    type     = "ssh"
    user     = "azureuser"
    password = "Password1234!"
    host     = self.public_ip_address  # Corrected reference to the public IP
  }

 tags = {
    environment = var.environment
  }
}
