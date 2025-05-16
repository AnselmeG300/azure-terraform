locals {
  regions = {
    eastus  = "rg-eastus"
    eastus2 = "rg-eastus2"
    westus  = "rg-westus"
  }
}

resource "azurerm_resource_group" "iform-rg" {
  for_each = local.regions
  name     = each.value
  location = each.key
}

# Create a Virtual Network
resource "azurerm_virtual_network" "iform-vnet" {
  for_each            = local.regions
  name                = "my-iform-vnet${each.key}"
  location            = azurerm_resource_group.iform-rg[each.key].location
  resource_group_name = azurerm_resource_group.iform-rg[each.key].name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "my-iform-env"
  }
}

# Create a Subnet in the Virtual Network
resource "azurerm_subnet" "iform-subnet" {
  for_each            = local.regions
  name                 = "my-iform-subnet"
  resource_group_name  = azurerm_resource_group.iform-rg[each.key].name
  virtual_network_name = azurerm_virtual_network.iform-vnet[each.key].name
  address_prefixes     = ["10.0.2.0/24"]
}


# Create a Network Security Group and rule
resource "azurerm_network_security_group" "iform-nsg" {
  for_each = local.regions
  name                = "my-iform-nsg-${each.key}"
  location            = azurerm_resource_group.iform-rg[each.key].location
  resource_group_name = azurerm_resource_group.iform-rg[each.key].name

  tags = {
    environment = "my-iform-env"
  }
}

resource "azurerm_public_ip" "eazy" {
  for_each = local.regions
  name                = "my-iform-public-ip-${each.key}"
  location            = azurerm_resource_group.iform-rg[each.key].location
  resource_group_name = azurerm_resource_group.iform-rg[each.key].name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = "my-iform-region-${each.key}"
  }
}

# Create a Network Interface
resource "azurerm_network_interface" "iform-vnic" {
  for_each = local.regions
  name                = "my-iform-nic"
  location            = azurerm_resource_group.iform-rg[each.key].location
  resource_group_name = azurerm_resource_group.iform-rg[each.key].name

  ip_configuration {
    name                          = "my-iform-nic-ip"
    subnet_id                     = azurerm_subnet.iform-subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.eazy[each.key].id
  }

  tags = {
    environment = "my-iform-env"
  }
}

# Create a Network Interface Security Group association
resource "azurerm_network_interface_security_group_association" "iform-assoc" {
  for_each = local.regions
  network_interface_id      = azurerm_network_interface.iform-vnic[each.key].id
  network_security_group_id = azurerm_network_security_group.iform-nsg[each.key].id
}

# Create a Virtual Machine
resource "azurerm_linux_virtual_machine" "iform-vm" {
  for_each = local.regions
  name                            = "my-iform-vm"
  location                        = azurerm_resource_group.iform-rg[each.key].location
  resource_group_name             = azurerm_resource_group.iform-rg[each.key].name
  network_interface_ids           = [azurerm_network_interface.iform-vnic[each.key].id]
  size                            = "Standard_B1s"
  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  admin_password                  = "Password1234!"
  disable_password_authentication = false

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  
  os_disk {
    name                 = "my-iform-os-disk"
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
	
  tags = {
    environment = "my-iform-env"
  }
}