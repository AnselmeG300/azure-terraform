variable "location" {
  type        = string
  description = "The location where the resources will be created"
  default     = "West Europe"
}


variable "environment" {
  type        = string
  description = "The environment for the resources"
  default     = "iform-env"
  
}
variable "iform_vm_id" {
  type        = string
  description = "The ID of the VM to attach the disk to"
  default     = ""
  
}