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

  depends_on = [azurerm_resource_group.iform-rg] # Assure que le réseau virtuel dépend du groupe de ressources
}

# Create a Subnet in the Virtual Network
resource "azurerm_subnet" "iform-subnet" {
  name                 = "my-iform-subnet-${local.name}"
  resource_group_name  = azurerm_resource_group.iform-rg.name
  virtual_network_name = azurerm_virtual_network.iform-vnet.name
  address_prefixes     = local.address_prefixes

  depends_on = [azurerm_virtual_network.iform-vnet] # Assure que le sous-réseau dépend du réseau virtuel
}

# Create a Network Security Group and rule
resource "azurerm_network_security_group" "iform-nsg" {
  name                = "my-iform-nsg-${local.name}"
  location            = azurerm_resource_group.iform-rg.location
  resource_group_name = azurerm_resource_group.iform-rg.name

  tags = {
    environment = "my-iform-env"
  }

  depends_on = [azurerm_resource_group.iform-rg] # Assure que le NSG dépend du groupe de ressources
}

# Create a Public IP for the Network Interface
resource "azurerm_public_ip" "eazy" {
  name                = "my-iform-public-ip-${local.name}"
  location            = azurerm_resource_group.iform-rg.location
  resource_group_name = azurerm_resource_group.iform-rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"

  depends_on = [azurerm_resource_group.iform-rg] # Assure que l'IP publique dépend du groupe de ressources
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
    public_ip_address_id          = azurerm_public_ip.eazy.id
  }

  tags = {
    environment = "my-iform-env"
  }

  depends_on = [azurerm_subnet.iform-subnet, azurerm_public_ip.eazy] # Assure que l'interface réseau dépend du sous-réseau et de l'IP publique
}

# Create a Network Interface Security Group association
resource "azurerm_network_interface_security_group_association" "iform-assoc" {
  network_interface_id      = azurerm_network_interface.iform-vnic.id
  network_security_group_id = azurerm_network_security_group.iform-nsg.id

  depends_on = [azurerm_network_interface.iform-vnic, azurerm_network_security_group.iform-nsg] # Assure l'association entre NSG et NIC
}

# Create a Virtual Machine
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
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    name                 = "my-iform-os-disk-${local.name}"
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = {
    environment = "my-iform-env"
  }

  depends_on = [azurerm_network_interface.iform-vnic] # Assure que la VM dépend de l'interface réseau
}
