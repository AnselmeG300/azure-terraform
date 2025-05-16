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
variable "public_ip_id" {
  type        = string
  description = "The ID of the public IP to associate with the instance"
  default     = ""
  
}
variable "nsg_id" {
  type        = string
  description = "The ID of the network security group to associate with the instance"
  default     = ""
  
}
variable "environment" {
  type        = string
  description = "The environment for the resources"
  default     = "iform-env"
  
}