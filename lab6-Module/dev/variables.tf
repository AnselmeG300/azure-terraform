variable "location" {
  type        = string
  description = "The location where the resources will be created"
  default     = "West Europe"
}


variable "nsg_name" {
  type        = string
  description = "The name of the network security group"
  default     = "my-iform-nsg-${local.name}"

}
variable "instance_template" {
  type        = string
  description = "Template for the webserver"
  default     = "Standard_D2_v2"
}

variable "environment" {
  type        = string
  description = "The environment for the resources"
  default     = "iform-env"

}