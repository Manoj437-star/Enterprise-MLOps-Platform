# ==============================================================================
# Outputs - Terraform State Bootstrap
# ==============================================================================

output "resource_group_name" {
  description = "Name of the resource group hosting remote Terraform state."
  value       = azurerm_resource_group.state_rg.name
}

output "storage_account_name" {
  description = "Name of the Azure Storage Account holding the tfstate container."
  value       = azurerm_storage_account.state_sa.name
}

output "container_name" {
  description = "Name of the blob container holding the remote state files."
  value       = azurerm_storage_container.state_container.name
}

output "backend_config_example" {
  description = "Example backend configuration snippet for downstream environments."
  value       = <<-EOT
    terraform {
      backend "azurerm" {
        resource_group_name  = "${azurerm_resource_group.state_rg.name}"
        storage_account_name = "${azurerm_storage_account.state_sa.name}"
        container_name       = "${azurerm_storage_container.state_container.name}"
        key                  = "<environment-name>.tfstate"
      }
    }
  EOT
}
