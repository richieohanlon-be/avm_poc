

# If the RG already exists, you can keep it as data source; otherwise use resource.
data "azurerm_resource_group" "rg" {
  name = "rg-storage-iac-statefiles-1"
}


module "vnet1" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = ">= 0.2.0"

  name          = "demo-vnet"
  address_space = ["10.0.0.0/24"]
  location      = data.azurerm_resource_group.rg.location
  parent_id     = data.azurerm_resource_group.rg.id

  subnets = {
    subnet1 = {
      name           = "subnet-frontend"
      address_prefix = "10.0.0.0/26"
    }
    subnet2 = {
      name           = "subnet-backend"
      address_prefix = "10.0.0.64/26"
    }
  }
}
