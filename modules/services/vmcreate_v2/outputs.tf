#Outputs the public IP of the VM
output "PublicIP" {
  value = azurerm_public_ip.publicip.ip_address
}

output "storID" {
  value = azurerm_storage_account.storageaccount.name
}