# Create a Managed Disk
resource "azurerm_managed_disk" "eazy-disk" {
  name                 = "my-eazy-disk"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = "Standard_LRS"
  disk_size_gb         = 50 # Taille du disque en Go
  create_option        = "Empty" # Le disque est créé vide, il peut être partitionné et formaté après l'attachement
  tags = {
    environment = var.environment
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "eazy-attach" {
  managed_disk_id    = azurerm_managed_disk.eazy-disk.id
  virtual_machine_id = var.eazy_vm_id
  lun                = "10"
  caching            = "ReadWrite"
}