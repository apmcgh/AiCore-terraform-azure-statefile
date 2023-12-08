# Use AZ CLI credentials to set-up the basic infrastructure:
# 1/ create a RG;
# 2/ create a SP with contributor rights on that RG;
# 3/ create a small storage account and containers (names in list variable);
#    with version tracking with the sole purpose to host state files (in that RG);
# 4/ securely manage SP credentials.


terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
  }
}


provider "azurerm" {
  features {}
}

provider "azuread" {
}


data "azurerm_client_config" "current" {}


# Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name != "" ? var.resource_group_name : "${var.project_name}RG"
  location = var.region
}

# Create Azure AD Application
resource "azuread_application" "app" {
  display_name = var.service_principal_name != "" ? var.service_principal_name : "${var.project_name}SP"
}

# Create Service Principal
resource "azuread_service_principal" "sp" {
  application_id = azuread_application.app.client_id
}

# Create a password for the Service Principal
resource "azuread_service_principal_password" "sp_password" {
  service_principal_id = azuread_service_principal.sp.id
  end_date             = "2099-01-01T01:02:03Z"
}

# Assign Contributor role to the Service Principal for the Resource Group
resource "azurerm_role_assignment" "sp_contributor" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.sp.id
}

# Create Storage Account
resource "azurerm_storage_account" "sa" {
  name                     = lower(var.storage_account_name != "" ? var.storage_account_name : "${var.project_name}SFS")
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Enable Versioning on the Storage Account
resource "azurerm_storage_management_policy" "policy" {
  storage_account_id = azurerm_storage_account.sa.id
  rule {
    name    = "versioning"
    enabled = true
    filters {
      blob_types = ["blockBlob"]
    }
    actions {
      base_blob {
          tier_to_cool_after_days_since_modification_greater_than    = 30
          tier_to_archive_after_days_since_modification_greater_than = 90
          delete_after_days_since_modification_greater_than          = 2555
      }
    }
  }
}

# Create Storage Containers
resource "azurerm_storage_container" "container" {
  for_each              = toset(length(var.container_names) > 0 ? var.container_names : ["${var.project_name}SFC"])
  name                  = lower(each.value)
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

# Create a key vault
resource "azurerm_key_vault" "kv" {
  name                        = var.key_vault_name != "" ? var.key_vault_name : "${var.project_name}KV"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"

  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
}

resource "azurerm_key_vault_access_policy" "kv_ap" {
  key_vault_id               = azurerm_key_vault.kv.id

  tenant_id                  = data.azurerm_client_config.current.tenant_id
  object_id                  = data.azurerm_client_config.current.object_id

  key_permissions            = []
  secret_permissions         = ["Set", "Get", "Delete", "List", "Recover", "Backup", "Restore", "Purge"]
  certificate_permissions    = []
  storage_permissions        = []
}

# Store Service Principal password in Azure Key Vault
resource "azurerm_key_vault_secret" "sp_secret" {
  name         = "service-principal-password"
  value        = azuread_service_principal_password.sp_password.value
  key_vault_id = azurerm_key_vault.kv.id
}
