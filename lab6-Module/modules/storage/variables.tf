variable "location" {
  type        = string
  description = "The location where the resources will be created"
  default     = "West Europe"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
  default     = "my-iform-rg"
}

variable "environment" {
  type        = string
  description = "The environment for the resources"
  default     = "iform-env"
  
}
variable "eazy_vm_id" {
  type        = string
  description = "The ID of the VM to attach the disk to"
  default     = ""
  
}