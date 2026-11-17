# ==============================================================================
# Outputs - Storage Account Module
# ==============================================================================

output "id" {
  description = "The ID of the Storage Account."
  value       = azurerm_storage_account.this.id
}

output "name" {
  description = "The Name of the Storage Account."
  value       = azurerm_storage_account.this.name
}

output "primary_blob_endpoint" {
  description = "The primary blob endpoint URL."
  value       = azurerm_storage_account.this.primary_blob_endpoint
}

output "primary_access_key" {
  description = "The primary access key for the Storage Account."
  value       = azurerm_storage_account.this.primary_access_key
  sensitive   = true
}
