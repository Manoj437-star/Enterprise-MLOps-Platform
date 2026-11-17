# ==============================================================================
# Variables - Key Vault Module
# ==============================================================================

variable "name" {
  type        = string
  description = "The globally unique name of the Key Vault (3-24 alphanumeric characters and dashes)."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group in which to create the Key Vault."
}

variable "location" {
  type        = string
  description = "The Azure region for the Key Vault."
  default     = "eastus2"
}

variable "sku_name" {
  type        = string
  description = "The Name of the SKU used for this Key Vault: standard or premium."
  default     = "standard"
}

variable "tags" {
  type        = map(string)
  description = "Tags for the Key Vault."
  default     = {}
}
