# ==============================================================================
# Outputs - Azure ML Compute Module
# ==============================================================================

output "id" {
  description = "The ID of the Azure Machine Learning Compute Cluster."
  value       = azurerm_machine_learning_compute_cluster.this.id
}

output "name" {
  description = "The name of the Azure Machine Learning Compute Cluster."
  value       = azurerm_machine_learning_compute_cluster.this.name
}
