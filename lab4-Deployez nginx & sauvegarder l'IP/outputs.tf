output "public_ip" {
  value = azurerm_public_ip.iform-ip.ip_address
}

output "vm_id" {
  value = azurerm_linux_virtual_machine.iform-vm.id
}

# Ajoute ceci SEULEMENT si tu as "zones = [\"1\"]" dans la VM
# output "availability_zone" {
#   value = azurerm_linux_virtual_machine.iform-vm.zone
# }

resource "null_resource" "write_info" {
  depends_on = [azurerm_linux_virtual_machine.iform-vm, azurerm_public_ip.iform-ip]

  provisioner "local-exec" {
    command = <<EOT
      echo IP: ${azurerm_public_ip.iform-ip.ip_address} > infos_vm.txt
      echo ID: ${azurerm_linux_virtual_machine.iform-vm.id} >> infos_vm.txt
      echo Zone de disponibilité: ${azurerm_linux_virtual_machine.iform-vm.zone} >> infos_vm.txt
    EOT
  }
}
