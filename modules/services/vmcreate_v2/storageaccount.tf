# Create storage account for boot diagnostics
resource "azurerm_storage_account" "this" {
  name                     = "diag${random_id.this.hex}"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Generate random text for a unique storage account name
resource "random_id" "this" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.this.name
  }

  byte_length = 8
}