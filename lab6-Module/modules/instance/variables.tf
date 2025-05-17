variable "instance_template" {
  type        = string
  description = "Template for the webserver"
  default     = "Standard_D2_v2"
}
variable "location" {
  type        = string
  description = "The location where the resources will be created"
  default     = "West Europe"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
  default     = "my-iform-rg-${local.name}"
}
variable "network_interface_id" {
  type        = string
  description = "The ID of the network interface to associate with the instance"
  default     = ""
}

variable "iform_disk_id" {
  type        = string
  description = "The ID of the disk to attach to the instance"
  default     = ""
  
}
variable "environment" {
  type        = string
  description = "The environment for the resources"
  default     = "iform-env"
  
}