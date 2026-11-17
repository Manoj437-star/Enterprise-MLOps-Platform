# ==============================================================================
# Variables - Azure ML Registry Module
# ==============================================================================

variable "name" {
  type        = string
  description = "The name of the Azure Machine Learning Registry (3-32 alphanumeric characters)."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group in which to create the Azure ML Registry."
}

variable "location" {
  type        = string
  description = "The Azure region for the Azure ML Registry."
  default     = "eastus2"
}

variable "storage_account_id" {
  type        = string
  description = "The resource ID of the backing Azure Storage Account for the Registry."
}

variable "container_registry_id" {
  type        = string
  description = "The resource ID of the backing Azure Container Registry for the Registry."
}

variable "tags" {
  type        = map(string)
  description = "Tags for the Azure ML Registry."
  default     = {}
}
