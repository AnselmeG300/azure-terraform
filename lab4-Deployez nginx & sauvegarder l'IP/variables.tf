variable "web_server_port" {
  type        = number
  description = "The port the server will use for HTTP requests"
  default     = 80
}

variable "ssh_server_port" {
  type        = number
  description = "The port the server will use for ssh requests"
  default     = 22
}

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
  default     = "my-iform-rg"
}