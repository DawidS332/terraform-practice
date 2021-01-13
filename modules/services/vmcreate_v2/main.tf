#Resource Section

resource "azurerm_resource_group" "resourcegroup" {
  name = "${var.vm_name}-rsg"
  location = "North Europe"
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.resourcegroup.name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "storageaccount" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.resourcegroup.name
  location                 = azurerm_resource_group.resourcegroup.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "sshkeytxt" {
  filename = "sshkey.pem"
  content = tls_private_key.example_ssh.private_key_pem
}

