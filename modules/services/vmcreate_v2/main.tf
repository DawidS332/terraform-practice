resource "azurerm_resource_group" "plexrg" {
  name = "${var.vm_name}-rsg"
  location = "North Europe"
}

resource "local_file" "sshkeytxt" {
  filename = "sshkey.pem"
  content = tls_private_key.example_ssh.private_key_pem
}

