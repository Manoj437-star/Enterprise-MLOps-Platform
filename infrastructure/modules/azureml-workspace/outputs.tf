# ==============================================================================
# Outputs - Azure ML Workspace Module
# ==============================================================================

output "id" {
  description = "The ID of the Azure Machine Learning Workspace."
  value       = azurerm_machine_learning_workspace.this.id
}

output "name" {
  description = "The name of the Azure Machine Learning Workspace."
  value       = azurerm_machine_learning_workspace.this.name
}

output "discovery_url" {
  description = "The discovery URL of the Azure Machine Learning Workspace."
  value       = azurerm_machine_learning_workspace.this.discovery_url
}

output "principal_id" {
  description = "The Principal ID of the Workspace System-Assigned Managed Identity."
  value       = azurerm_machine_learning_workspace.this.identity[0].principal_id
}
