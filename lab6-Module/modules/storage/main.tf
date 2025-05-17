# Create a Managed Disk
resource "azurerm_managed_disk" "iform-disk" {
  name                 = "my-iform-disk"
  location             = var.location
  resource_group_name  = "my-iform-rg-${local.name}"
  storage_account_type = "Standard_LRS"
  disk_size_gb         = 50 # Taille du disque en Go
  create_option        = "Empty" # Le disque est créé vide, il peut être partitionné et formaté après l'attachement
  tags = {
    environment = var.environment
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "iform-attach" {
  managed_disk_id    = azurerm_managed_disk.iform-disk.id
  virtual_machine_id = var.iform_vm_id
  lun                = "10"
  caching            = "ReadWrite"
}