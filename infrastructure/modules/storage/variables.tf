# ==============================================================================
# Variables - Storage Account Module
# ==============================================================================

variable "name" {
  type        = string
  description = "The globally unique name of the Storage Account (lowercase alphanumeric, 3-24 chars)."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group in which to create the Storage Account."
}

variable "location" {
  type        = string
  description = "The Azure region for the Storage Account."
  default     = "eastus2"
}

variable "account_tier" {
  type        = string
  description = "Storage tier: Standard or Premium."
  default     = "Standard"
}

variable "replication_type" {
  type        = string
  description = "Replication type: LRS, GRS, ZRS, etc."
  default     = "LRS"
}

variable "containers" {
  type        = list(string)
  description = "List of blob container names to create."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags for the Storage Account."
  default     = {}
}
