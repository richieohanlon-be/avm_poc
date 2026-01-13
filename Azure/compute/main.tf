

# If the RG already exists, you can keep it as data source; otherwise use resource.
data "azurerm_resource_group" "rg" {
  name = "rg-storage-iac-statefiles-1"
}

# -------------------------------
# App Service Plan via AVM module
# -------------------------------
module "asp" {
  source = "git::https://github.com/richieohanlon-be/terraform-azurerm-avm-res-web-serverfarm"
  #./modules/avm-res-web-serverfarm" # local path
  #source  = "Azure/avm-res-web-serverfarm/azurerm"
  #version = "0.7.0"

  name                = "asp-test-roh-1"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  # Match your original settings
  #kind     = "Linux" # AVM module accepts 'linux' or 'windows' via inputs
  os_type                = "Linux" # aligns with azurerm_service_plan settings
  sku_name               = "S1"
  zone_balancing_enabled = false
  # Optional: tags, locks, diagnostics, role assignments…
  # tags = { env = "test" }
}

# ---------------------------
# Linux Web App via AVM module
# ---------------------------
 module "linux_webapp" {
#   source = "./modules/avm-res-web-site"
source = "Azure/avm-res-web-site/azurerm"
version = "0.18.0" # e
   name                     = "app-test-roh-1"
   kind                     = "webapp" # Web App (not Function App)
   os_type                  = "Linux"  # Linux web app
   location                 = data.azurerm_resource_group.rg.location
   resource_group_name      = data.azurerm_resource_group.rg.name
   service_plan_resource_id = module.asp.resource_id # module output


#   # Public network access (AVM interface maps to underlying app settings)
   public_network_access_enabled = true

#   # Site config maps to AVM's 'site_config' object
   site_config = {
     # Add settings as needed, kept empty to mirror your current minimal config
   }

#   # Optional: enable Application Insights via AVM interface
#   # application_insights = {
#   #   workspace_resource_id = azurerm_log_analytics_workspace.example.id
#   # }

#   # Optional: diagnostics, role assignments, private endpoints, tags, locks…
#   # tags = { env = "test" }
 }



# module "linux_webapp2" {
#   #source = "Azure/avm-res-web-site/azurerm"
#   source = "https://sarogavmpochost.blob.core.windows.net/avm"
#   #source = "./modules/avm-res-web-site"
#   #version = "0.18.0" # example: pin to latest on registry

#   name                     = "app-test-roh-2"
#   kind                     = "webapp" # Web App (not Function App)
#   os_type                  = "Linux"  # Linux web app
#   location                 = data.azurerm_resource_group.rg.location
#   resource_group_name      = data.azurerm_resource_group.rg.name
#   service_plan_resource_id = module.asp.resource_id # module output


#   # Public network access (AVM interface maps to underlying app settings)
#   public_network_access_enabled = true

#   # Site config maps to AVM's 'site_config' object
#   site_config = {
#     # Add settings as needed, kept empty to mirror your current minimal config
#   }

#   # Optional: enable Application Insights via AVM interface
#   # application_insights = {
#   #   workspace_resource_id = azurerm_log_analytics_workspace.example.id
#   # }

#   # Optional: diagnostics, role assignments, private endpoints, tags, locks…
#   # tags = { env = "test" }
# }
