# ==============================================================================
# Main - Azure ML Registry Module (Using Azure AzAPI Provider)
# ==============================================================================

terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.13.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100.0"
    }
  }
}

data "azurerm_client_config" "current" {}

resource "azapi_resource" "registry" {
  type                      = "Microsoft.MachineLearningServices/registries@2024-04-01-preview"
  name                      = var.name
  location                  = var.location
  parent_id                 = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"
  schema_validation_enabled = false

  body = jsonencode({
    identity = {
      type = "SystemAssigned"
    }
    properties = {
      publicNetworkAccess = "Enabled"
      regionDetails = [
        {
          location = var.location
          storageAccountDetails = [
            {
              systemCreatedStorageAccount = {
                storageAccountType = "Standard_LRS"
              }
            }
          ]
          acrDetails = [
            {
              systemCreatedAcrAccount = {
                acrAccountSku = "Premium"
              }
            }
          ]
        }
      ]
    }
  })

  tags = var.tags
}
