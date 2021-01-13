#Outputs the public IP of the VM
output "PublicIP" {
  value = azurerm_public_ip.publicip.ip_address
}
