

# If the RG already exists, you can keep it as data source; otherwise use resource.
data "azurerm_resource_group" "rg" {
  name = "rg-storage-iac-statefiles-1"
}


module "vm_sku" {
  source  = "Azure/avm-utl-sku-finder/azapi"
  version = "0.3.0"

  location      = data.azurerm_resource_group.rg.location
  cache_results = true
  vm_filters = {
    min_vcpus                      = 2
    max_vcpus                      = 2
    encryption_at_host_supported   = true
    accelerated_networking_enabled = true
    premium_io_supported           = true
    location_zone                  = 1
  }

}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.2"
}

module "regions" {
  source  = "Azure/avm-utl-regions/azurerm"
  version = "0.5.0"

  availability_zones_filter = true
}




module "small_vm" {

  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = ">= 0.8.0"


  location = data.azurerm_resource_group.rg.location
  name     = module.naming.virtual_machine.name_unique
  network_interfaces = {
    network_interface_1 = {
      name = module.naming.network_interface.name_unique
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "${module.naming.network_interface.name_unique}-ipconfig1"
          private_ip_subnet_resource_id = "/subscriptions/d1952367-cf47-4fd4-9ff1-c007f61e106d/resourceGroups/rg-storage-iac-statefiles-1/providers/Microsoft.Network/virtualNetworks/demo-vnet/subnets/subnet-backend"
        }
      }
    }
  }
  resource_group_name = data.azurerm_resource_group.rg.name
  zone                = 1
  enable_telemetry = false
  os_type          = "Linux"
  sku_size         = module.vm_sku.sku
  source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
  encryption_at_host_enabled = false
}