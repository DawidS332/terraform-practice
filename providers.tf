# Configure the Azure Providers

provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=2.41.0"
  features {}
}
