# ==============================================================================
# Variables - Azure ML Workspace Module
# ==============================================================================

variable "name" {
  type        = string
  description = "The name of the Azure Machine Learning Workspace."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group in which to create the Workspace."
}

variable "location" {
  type        = string
  description = "The Azure region for the Workspace."
  default     = "eastus2"
}

variable "storage_account_id" {
  type        = string
  description = "The resource ID of the backing Azure Storage Account."
}

variable "key_vault_id" {
  type        = string
  description = "The resource ID of the backing Azure Key Vault."
}

variable "application_insights_id" {
  type        = string
  description = "The resource ID of the Application Insights component."
}

variable "container_registry_id" {
  type        = string
  description = "The resource ID of the Azure Container Registry (optional)."
  default     = null
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether public network access is enabled for the workspace."
  default     = true
}

variable "friendly_name" {
  type        = string
  description = "A friendly name for the workspace."
  default     = null
}

variable "description" {
  type        = string
  description = "A description of the workspace."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags to assign to the workspace."
  default     = {}
}
