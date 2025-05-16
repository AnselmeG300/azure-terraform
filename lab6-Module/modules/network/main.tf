# Create a Virtual Network
resource "azurerm_virtual_network" "iform-vnet" {
  name                = "my-iform-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]

 tags = {
    environment = var.environment
  }
}

# Create a Subnet in the Virtual Network
resource "azurerm_subnet" "iform-subnet" {
  name                 = "my-iform-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.iform-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
  
}

# Create a Network Interface
resource "azurerm_network_interface" "iform-vnic" {
  name                = "my-iform-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "my-iform-nic-ip"
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