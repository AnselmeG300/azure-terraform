resource "azurerm_network_watcher" "iform-watcher" {
  name                = "my-iform-watcher-${local.name}"
  location            = var.location
  resource_group_name = "my-iform-rg-${local.name}"
  tags = {
    environment = var.environment
  }
}
#update des modules pour le dev et le prod
module "rg" {
  source              = "../modules/rg"
  location            = var.location
  resource_group_name = "my-iform-rg-${local.name}"
  environment         = var.environment
}
module "ip" {
  source              = "../modules/ip"
  location            = module.rg.rg_location
  resource_group_name = module.rg.rg_name
  environment         = var.environment

}

module "nsg" {
  source              = "../modules/nsg"
  location            = module.rg.rg_location
  resource_group_name = module.rg.rg_name
  nsg_name            = var.nsg_name
  environment         = var.environment
}
module "network" {
  source              = "../modules/network"
  location            = module.rg.rg_location
  resource_group_name = module.rg.rg_name
  public_ip_id        = module.ip.public_ip_id
  nsg_id              = module.nsg.nsg_id
  environment         = var.environment
}


module "instance" {
  source               = "../modules/instance"
  location             = module.rg.rg_location
  resource_group_name  = module.rg.rg_name
  network_interface_id = module.network.network_interface_id
  instance_template    = var.instance_template
  eazy_disk_id         = module.storage.eazy_disk_id
  environment          = var.environment

}
module "storage" {
  source              = "../modules/storage"
  location            = module.rg.rg_location
  resource_group_name = module.rg.rg_name
  eazy_vm_id          = module.instance.intance_id
  environment         = var.environment
}

