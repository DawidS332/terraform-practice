# Configure the Azure Providers

provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=2.41.0"
  features {}
}


resource "azurerm_resource_group" "plexrg" {
  name = "${var.vm_name}-rsg"
  location = "North Europe"
}

resource "local_file" "sshkeytxt" {
  filename = "sshkey.pem"
  content = tls_private_key.example_ssh.private_key_pem
}

