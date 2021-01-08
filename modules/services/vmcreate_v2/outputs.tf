#Outputs the public IP of the VM
output "PublicIP" {
  value = azurerm_public_ip.myterraformpublicip.ip_address
}

output "base64" {
  value = base64encode("${path.module}/cloud-config.yaml")
 
}