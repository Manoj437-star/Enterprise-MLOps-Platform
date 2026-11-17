# ==============================================================================
# Outputs - Monitoring Module
# ==============================================================================

output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.this.id
}

output "log_analytics_workspace_name" {
  description = "The Name of the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.this.name
}

output "application_insights_id" {
  description = "The ID of the Application Insights instance."
  value       = azurerm_application_insights.this.id
}

output "application_insights_name" {
  description = "The Name of the Application Insights instance."
  value       = azurerm_application_insights.this.name
}
