# ==============================================================================
# Variables - Monitoring Module (Log Analytics & Application Insights)
# ==============================================================================

variable "name_prefix" {
  type        = string
  description = "Prefix for monitoring resource names."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group where monitoring resources will reside."
}

variable "location" {
  type        = string
  description = "Azure region for monitoring resources."
  default     = "eastus2"
}

variable "sku" {
  type        = string
  description = "Log Analytics Workspace SKU."
  default     = "PerGB2018"
}

variable "retention_in_days" {
  type        = number
  description = "Data retention in days for Log Analytics (minimum 30 days)."
  default     = 30
}

variable "tags" {
  type        = map(string)
  description = "Tags for monitoring resources."
  default     = {}
}
