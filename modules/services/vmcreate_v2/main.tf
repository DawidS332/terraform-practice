#Resource Section

resource "azurerm_resource_group" "createrg" {
  name = "${var.vm_name}-rsg"
  location = "North Europe"
}

#Create Vnet for VM
resource "azurerm_virtual_network" "network" {
    name                = "${var.vm_name}-network"
    address_space       = ["10.2.0.0/16"]
    location            = azurerm_resource_group.createrg.location
    resource_group_name = azurerm_resource_group.createrg.name

}

#Create Network Security Group
resource "azurerm_network_security_group" "myterraformnsg" {
    name                = "${var.vm_name}-nsg"
    location            = azurerm_resource_group.createrg.location
    resource_group_name = azurerm_resource_group.createrg.name

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
resource "azurerm_public_ip" "myterraformpublicip" {
  name                = "${var.vm_name}-publicIP"
  location            = azurerm_resource_group.createrg.location
  resource_group_name = azurerm_resource_group.createrg.name
  allocation_method   = "Dynamic"
}

# Create network interface
resource "azurerm_network_interface" "terranic" {
  name                = "${var.vm_name}-NIC"
  location            = azurerm_resource_group.createrg.location
  resource_group_name = azurerm_resource_group.createrg.name
  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.terrasubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
  }
}

#Create subnet
resource "azurerm_subnet" "terrasubnet" {
    name                 = "${var.vm_name}-subnet"
    resource_group_name  = azurerm_resource_group.createrg.name
    virtual_network_name = azurerm_virtual_network.network.name
    address_prefixes       = ["10.2.0.0/24"]

}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.createrg.name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.createrg.name
  location                 = azurerm_resource_group.createrg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "myterraformvm" {
  name                  = "${var.vm_name}-vm"
  location              = azurerm_resource_group.createrg.location
  resource_group_name   = azurerm_resource_group.createrg.name
  network_interface_ids = [azurerm_network_interface.terranic.id]
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
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }

  custom_data = base64encode(templatefile("${path.module}/cloud-config.yaml",{}))
}

resource "local_file" "sshkeytxt" {
  filename = "sshkey.pem"
  content = tls_private_key.example_ssh.private_key_pem
}

data "azurerm_public_ip" "vmIPad" {
  name = azurerm_public_ip.myterraformpublicip.name
  resource_group_name = azurerm_resource_group.createrg.name
  #depends_on = [ azurerm_linux_virtual_machine.myterraformvm ]
}

#hello