# Create a Virtual Network
resource "azurerm_virtual_network" "iform-vnet" {
  name                = "my-iform-vnet-${locals.name}"
  location            = var.location
  resource_group_name = "my-iform-rg-${locals.name}"
  address_space       = local.address_space

 tags = {
    environment = var.environment
  }
}

# Create a Subnet in the Virtual Network
resource "azurerm_subnet" "iform-subnet" {
  name                 = "my-iform-subnet-${locals.name}"
  resource_group_name  = "my-iform-rg-${locals.name}"
  virtual_network_name = azurerm_virtual_network.iform-vnet.name
  address_prefixes     = locals.address_prefixes
  
}

# Create a Network Interface
resource "azurerm_network_interface" "iform-vnic" {
  name                = "my-iform-nic-${locals.name}"
  location            = var.location
  resource_group_name = "my-iform-rg-${locals.name}"

  ip_configuration {
    name                          = "my-iform-nic-ip-${locals.name}"
    subnet_id                     = azurerm_subnet.iform-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_id
  }

 tags = {
    environment = var.environment
  }
}

# Create a Network Interface Security Group association
resource "azurerm_network_interface_security_group_association" "iform-assoc" {
  network_interface_id      = azurerm_network_interface.iform-vnic.id
  network_security_group_id = var.nsg_id
}