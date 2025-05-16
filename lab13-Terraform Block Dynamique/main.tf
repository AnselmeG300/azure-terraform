resource "azurerm_resource_group" "iform-rg" {
  name     = "my-iform-rg-${local.name}"
  location = "West Europe"
}

# Create a Virtual Network
resource "azurerm_virtual_network" "iform-vnet" {
  name                = "my-iform-vnet-${local.name}"
  location            = azurerm_resource_group.iform-rg.location
  resource_group_name = azurerm_resource_group.iform-rg.name
  address_space       = local.address_space

  tags = {
    environment = "my-iform-env"
  }
}

# Create a Subnet in the Virtual Network
resource "azurerm_subnet" "iform-subnet" {
  name                 = "my-iform-subnet-${local.name}"
  resource_group_name  = azurerm_resource_group.iform-rg.name
  virtual_network_name = azurerm_virtual_network.iform-vnet.name
  address_prefixes     = local.address_prefixes
}

# Create a Public IP
resource "azurerm_public_ip" "iform-ip" {
  name                = "my-iform-public-ip-${local.name}"
  location            = azurerm_resource_group.iform-rg.location
  resource_group_name = azurerm_resource_group.iform-rg.name
  allocation_method   = "Dynamic"
  sku = "Basic"

  tags = {
    environment = "my-iform-env"
  }
}

# Create a Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = "my-iform-nsg-${local.name}"
  location            = azurerm_resource_group.iform-rg.location
  resource_group_name = azurerm_resource_group.iform-rg.name

  dynamic "security_rule" {
    for_each = var.allowed_ports
    content {
      name                       = "Allow-Port-${security_rule.value}"
      priority                   = 100 + index(var.allowed_ports, security_rule.value)
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "${security_rule.value}"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
  lifecycle {
    prevent_destroy = false
  }
   tags = {
    environment = "my-iform-env"
  }
}

# Create a Network Interface
resource "azurerm_network_interface" "iform-vnic" {
  name                = "my-iform-nic-${local.name}"
  location            = azurerm_resource_group.iform-rg.location
  resource_group_name = azurerm_resource_group.iform-rg.name

  ip_configuration {
    name                          = "my-iform-nic-ip-${local.name}"
    subnet_id                     = azurerm_subnet.iform-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.iform-ip.id
  }

  tags = {
    environment = "my-iform-env"
  }
}

# Create a Network Interface Security Group association
resource "azurerm_network_interface_security_group_association" "iform-assoc" {
  network_interface_id      = azurerm_network_interface.iform-vnic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create a Virtual Machine
resource "azurerm_linux_virtual_machine" "iform-vm" {
  name                            = "my-iform-vm-${local.name}"
  location                        = azurerm_resource_group.iform-rg.location
  resource_group_name             = azurerm_resource_group.iform-rg.name
  network_interface_ids           = [azurerm_network_interface.iform-vnic.id]
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
   provisioner "local-exec" {
     command = "echo ${azurerm_linux_virtual_machine.iform-vm.name}:  ${azurerm_public_ip.iform-ip.ip_address} >> ip_address.txt"
	}
	
  tags = {
    environment = "my-iform-env"
  }
}

resource "azurerm_virtual_machine_extension" "vm-extension" {
  name                 = "hostname"
  virtual_machine_id   = azurerm_linux_virtual_machine.iform-vm.id
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