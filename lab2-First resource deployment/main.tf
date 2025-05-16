# Resource Group
resource "azurerm_resource_group" "iform-rg" {
  name     = "my-iform-rg-${local.name}"
  location = "West Europe"
  tags = {
    environment = "my-iform-env"
  }
}

# Virtual Network
resource "azurerm_virtual_network" "iform-vnet" {
  name                = "my-iform-vnet-${local.name}"
  location            = azurerm_resource_group.iform-rg.location
  resource_group_name = azurerm_resource_group.iform-rg.name
  address_space       = local.address_space

  tags = {
    environment = "my-iform-env"
  }
}

# Subnet
resource "azurerm_subnet" "iform-subnet" {
  name                 = "my-iform-subnet-${local.name}"
  resource_group_name  = azurerm_resource_group.iform-rg.name
  virtual_network_name = azurerm_virtual_network.iform-vnet.name
  address_prefixes     = local.address_prefixes
}

# Public IP
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

# Network Security Group
resource "azurerm_network_security_group" "iform-nsg" {
  name                = "my-iform-nsg-${local.name}"
  location            = azurerm_resource_group.iform-rg.location
  resource_group_name = azurerm_resource_group.iform-rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
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

# Network Interface
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

# Associate NSG with NIC
resource "azurerm_network_interface_security_group_association" "iform-assoc" {
  network_interface_id      = azurerm_network_interface.iform-vnic.id
  network_security_group_id = azurerm_network_security_group.iform-nsg.id
}

# Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "iform-vm" {
  name                            = "my-iform-vm-${local.name}"
  location                        = azurerm_resource_group.iform-rg.location
  resource_group_name             = azurerm_resource_group.iform-rg.name
  network_interface_ids           = [azurerm_network_interface.iform-vnic.id]
  size                            = "Standard_B1s"
  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  admin_password                  = "Password1234!"
  disable_password_authentication = false

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_disk {
    name                 = "my-iform-os-disk-${local.name}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  tags = {
    environment = "my-iform-env"
  }
}

resource "azurerm_network_watcher" "example" {
  name                = "my-iform-watcher-${local.name}"
  location            = azurerm_resource_group.iform-rg.location
  resource_group_name = azurerm_resource_group.iform-rg.name
  tags = {
    environment = "my-iform-env" 
  }
}
