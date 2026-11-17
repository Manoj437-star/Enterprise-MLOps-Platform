# ==============================================================================
# Main - Terraform Remote State Storage Provisioning
# ==============================================================================

# 1. Dedicated Resource Group for Terraform State
resource "azurerm_resource_group" "state_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# 2. Random suffix for globally unique storage account naming
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# 3. Secure, Cost-Conscious Azure Storage Account for State
resource "azurerm_storage_account" "state_sa" {
  name                            = "${var.storage_account_prefix}${random_string.suffix.result}"
  resource_group_name             = azurerm_resource_group.state_rg.name
  location                        = azurerm_resource_group.state_rg.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  enable_https_traffic_only       = true
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = true

  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = 14
    }
  }

  tags = var.tags
}

# 4. Blob Container for Environment State Files
resource "azurerm_storage_container" "state_container" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.state_sa.name
  container_access_type = "private"
}
