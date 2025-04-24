output "public_ip" {
  value = azurerm_public_ip.eazy-ip.ip_address
}

output "vm_id" {
  value = azurerm_linux_virtual_machine.eazy-vm.id
}

# Ajoute ceci SEULEMENT si tu as "zones = [\"1\"]" dans la VM
# output "availability_zone" {
#   value = azurerm_linux_virtual_machine.eazy-vm.zone
# }

# resource "null_resource" "write_info" {
#   depends_on = [azurerm_linux_virtual_machine.eazy-vm]

#   provisioner "local-exec" {
#     command = <<-EOT
#       echo "IP: ${azurerm_public_ip.eazy-ip.ip_address}" > infos_ec2.txt
#       echo "ID: ${azurerm_linux_virtual_machine.eazy-vm.id}" >> infos_ec2.txt
#       # echo "Zone de disponibilité: ${azurerm_linux_virtual_machine.eazy-vm.zone}" >> infos_ec2.txt
#     EOT
#   }
# }
