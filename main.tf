# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=2.41.0"
  features {}
}

module "vmcreate_v2" {
  source  = "./modules/services/vmcreate_v2"
  vm_name = "terradebian"

}
