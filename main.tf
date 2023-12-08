terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  client_id       = "XXX"
  client_secret   = "XXX"
  subscription_id = "XXX"
  tenant_id       = "XXX"
}

# Define the Azure Storage Account resource
resource "azurerm_storage_account" "az_aic_tf_storage_account" {
  name                     = "aictfstorageaccount"
  resource_group_name      = "aicore-terraform-storage-rg"
  location                 = "UK South"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on = [azurerm_resource_group.az_aic_tf_st_rg]
}