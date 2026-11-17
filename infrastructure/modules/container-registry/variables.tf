# ==============================================================================
# Variables - Container Registry Module
# ==============================================================================

variable "name" {
  type        = string
  description = "The globally unique name of the Container Registry (alphanumeric only, 5-50 chars)."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group for ACR."
}

variable "location" {
  type        = string
  description = "The Azure region for ACR."
  default     = "eastus2"
}

variable "sku" {
  type        = string
  description = "The SKU of the container registry (Premium required for Private Endpoints)."
  default     = "Premium"
}

variable "admin_enabled" {
  type        = bool
  description = "Should the admin user be enabled on the ACR?"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags for the Container Registry."
  default     = {}
}
