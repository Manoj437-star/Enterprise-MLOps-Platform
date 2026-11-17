# ==============================================================================
# Outputs - Resource Group Module
# ==============================================================================

output "id" {
  description = "The ID of the Resource Group."
  value       = azurerm_resource_group.this.id
}

output "name" {
  description = "The Name of the Resource Group."
  value       = azurerm_resource_group.this.name
}

output "location" {
  description = "The Azure Region of the Resource Group."
  value       = azurerm_resource_group.this.location
}
