resource "azurerm_resource_group" "iform-rg" {
  name     = "my-iform-rg-${local.name}"
  location = var.location
}



resource "azurerm_virtual_network" "iform-vnet" {
  name                = "my-iform-vnet-${local.name}"
  location            = azurerm_resource_group.iform-rg.location
  resource_group_name = azurerm_resource_group.iform-rg.name
  address_space       = local.address_space

  tags = {
    environment = "my-iform-env"
  }
}

resource "azurerm_subnet" "iform-subnet" {
  name                 = "my-iform-subnet-${local.name}"
  resource_group_name  = azurerm_resource_group.iform-rg.name
  virtual_network_name = azurerm_virtual_network.iform-vnet.name
  address_prefixes     = local.address_prefixes
}

resource "azurerm_public_ip" "iform-ip" {
  name                = "my-iform-public-ip-${local.name}"
  location            = azurerm_resource_group.iform-rg.location
  resource_group_name = azurerm_resource_group.iform-rg.name
  allocation_method   = "Static"
  sku                 = "Basic"

  tags = {
    environment = "my-iform-env"
  }
}

resource "azurerm_network_security_group" "iform-nsg" {
  name                = "my-iform-nsg-${local.name}"
  location            = azurerm_resource_group.iform-rg.location
  resource_group_name = azurerm_resource_group.iform-rg.name

  security_rule {
    name                       = "Allow-HTTP"
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
    name                       = "Allow-SSH"
    priority                   = 1002
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

resource "azurerm_network_interface_security_group_association" "iform-assoc" {
  network_interface_id      = azurerm_network_interface.iform-vnic.id
  network_security_group_id = azurerm_network_security_group.iform-nsg.id
}

resource "azurerm_linux_virtual_machine" "iform-vm" {
  name                            = "my-iform-vm-${local.name}"
  location                        = azurerm_resource_group.iform-rg.location
  resource_group_name             = azurerm_resource_group.iform-rg.name
  network_interface_ids           = [azurerm_network_interface.iform-vnic.id]
  size                            = var.instance_template
  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  admin_password                  = var.admin_password
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

  tags = {
    environment = "my-iform-env"
  }
}

resource "azurerm_storage_account" "iform-sa" {
  name                     = "iformstorage${local.name}"
  resource_group_name      = azurerm_resource_group.iform-rg.name
  location                 = azurerm_resource_group.iform-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "iform-container" {
  name                  = "iform-container"
  storage_account_id    = azurerm_storage_account.iform-sa.id
  container_access_type = "private"
}
