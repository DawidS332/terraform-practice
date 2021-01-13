# Create network interface
resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_name}-NIC"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name
  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

#Create subnet
resource "azurerm_subnet" "subnet" {
    name                 = "${var.vm_name}-subnet"
    resource_group_name  = azurerm_resource_group.resourcegroup.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes       = ["10.2.0.0/24"]
}

#Create Network Security Group
resource "azurerm_network_security_group" "nsg" {
    name                = "${var.vm_name}-nsg"
    location            = azurerm_resource_group.resourcegroup.location
    resource_group_name = azurerm_resource_group.resourcegroup.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "plex_external"
        priority                   = 100
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "32400"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

# Create public IPs
resource "azurerm_public_ip" "publicip" {
  name                = "${var.vm_name}-publicIP"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name
  allocation_method   = "Dynamic"
}

#Create Vnet for VM
resource "azurerm_virtual_network" "vnet" {
    name                = "${var.vm_name}-vnet"
    address_space       = ["10.2.0.0/16"]
    location            = azurerm_resource_group.resourcegroup.location
    resource_group_name = azurerm_resource_group.resourcegroup.name
}
