terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.80.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "<>"
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-storage-iac-statefiles-1"
    storage_account_name = "sarohavmpoc1" # must be globally unique
    container_name       = "poc"
    key                  = "network/network_terraform.tfstate" # path/name of the blob
    # Optional (recommended modern auth):
    use_azuread_auth = true
  }
}
