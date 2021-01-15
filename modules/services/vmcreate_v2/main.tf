resource "azurerm_resource_group" "this" {
  name = "${var.vm_name}-rsg"
  location = "North Europe"
}

resource "local_file" "sshkeytxt" {
  filename = "sshkey.pem"
  content = tls_private_key.this.private_key_pem
}

