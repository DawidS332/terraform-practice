# Create virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "${var.vm_name}-vm"
  location              = azurerm_resource_group.plexrg.location
  resource_group_name   = azurerm_resource_group.plexrg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = "Standard_D2s_v3"

  os_disk {
    name                 = "${var.vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.os.publisher
    offer     = var.os.offer
    sku       = var.os.sku
    version   = var.os.version
  }

  computer_name                   = "terralinux"
  admin_username                  = var.admin_user
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_user
    public_key = tls_private_key.example_ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storageaccount.primary_blob_endpoint
  }

  custom_data = base64encode(templatefile("${path.module}/cloud-config.yaml",{}))
}
