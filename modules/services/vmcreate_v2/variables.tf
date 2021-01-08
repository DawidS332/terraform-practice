variable "vm_name" {
  description = "local name of the Virtual Machine."
  type        = string
  default     = "myvm"
}

variable "os" {
  default = {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "18.04-LTS"
    version = "latest"
    id = ""   #Only use to specify whether VM is a windows image or not. If yes, set to true, else leave blank
  }
}

variable "admin_user" {
  type = string
  default = "azureuser"
  
}