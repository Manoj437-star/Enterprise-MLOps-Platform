# ==============================================================================
# Outputs - Azure ML Registry Module
# ==============================================================================

output "id" {
  description = "The ID of the Azure ML Registry."
  value       = azapi_resource.registry.id
}

output "name" {
  description = "The Name of the Azure ML Registry."
  value       = var.name
}
