variable "location" {
  type        = string
  description = "The location where the resources will be created"
  default     = "West Europe"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
  default     = "my-eazy-rg"
}
variable "environment" {
  type        = string
  description = "The environment for the resources"
  default     = "eazy-env"
  
}