resource "azurerm_resource_group" "iform-rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_network_watcher" "iform-watcher" {
  name                = "my-iform-watcher"
  location            = azurerm_resource_group.iform-rg.location
  resource_group_name = azurerm_resource_group.iform-rg.name
  tags = {
    environment = "my-iform-env"
  }
}


# Create a Virtual Network
resource "azurerm_virtual_network" "iform-vnet" {
  name                = "my-iform-vnet"
  location            = azurerm_resource_group.iform-rg.location
  resource_group_name = azurerm_resource_group.iform-rg.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "my-iform-env"
  }
}

# Create a Subnet in the Virtual Network
resource "azurerm_subnet" "iform-subnet" {
  name                 = "my-iform-subnet"
  resource_group_name  = azurerm_resource_group.iform-rg.name
  virtual_network_name = azurerm_virtual_network.iform-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create a Public IP
resource "azurerm_public_ip" "iform-ip" {
  name                = "my-iform-public-ip"
  location            = azurerm_resource_group.iform-rg.location
  resource_group_name = azurerm_resource_group.iform-rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"

  tags = {
    environment = "my-iform-env"
  }
}

# Create a Network Security Group and rule
resource "azurerm_network_security_group" "iform-nsg" {
  name                = "my-iform-nsg"
  location            = azurerm_resource_group.iform-rg.location
  resource_group_name = azurerm_resource_group.iform-rg.name

  security_rule {
    name                       = "HTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = var.web_server_port
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = var.ssh_server_port
    source_address_prefix      = "*"
    destination_address_prefix = "*"
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
  name                = "my-iform-nic"
  location            = azurerm_resource_group.iform-rg.location
  resource_group_name = azurerm_resource_group.iform-rg.name

  ip_configuration {
    name                          = "my-iform-nic-ip"
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
  network_security_group_id = azurerm_network_security_group.iform-nsg.id
}

# Create a Virtual Machine
resource "azurerm_linux_virtual_machine" "iform-vm" {
  name                            = "my-iform-vm"
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
    name                 = "my-iform-os-disk"
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
  provisioner "file" {
    source      = "./scripts/install.sh"         # fichier local
    destination = "/home/azureuser/install.sh" # chemin distant
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/azureuser/install.sh",
      "sudo /home/azureuser/install.sh"
    ]
  }

  connection {
    type     = "ssh"
    user     = "azureuser"
    password = "Password1234!"
    host     = self.public_ip_address
  }

  tags = {
    environment = "my-iform-env"
  }
}


