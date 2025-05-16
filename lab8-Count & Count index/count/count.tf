# This file is used to configure the provider and backend for the Terraform project.
# It specifies the required version of Terraform and the azurerm provider.
terraform {
  required_version = ">=1.11.4"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.26.0"
    }
  }
}
provider "azurerm" {
  features {
  }
  resource_provider_registrations = "none"
  subscription_id                 = "your-subscription-id"
  client_id = "your-client-id"
  client_secret = "your-client-secret"
  tenant_id = "your-tenant-id"
}
resource "azurerm_resource_group" "rg" {
  name     = "iform-rg"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-tp2"
  address_space       = local.address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-tp2"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Liste des noms de VM
locals {
  vm_names = ["vm1", "vm2", "vm3"]
}

resource "azurerm_network_interface" "nic" {
  count               = length(local.vm_names)
  name                = "${local.vm_names[count.index]}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  count                 = length(local.vm_names)
  name                  = local.vm_names[count.index]
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  size                  = "Standard_B1s"
  admin_username        = "azureuser"

  disable_password_authentication = false
  admin_password                  = "Anselme@2024!"  # ⚠️ À sécuriser pour usage réel

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "${local.vm_names[count.index]}-osdisk"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20_04-lts"
    version   = "latest"
  }
}
