# ==============================================================================
# Variables - Private DNS Module
# ==============================================================================

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the Private DNS Zones should be created."
}

variable "dns_zones" {
  type        = list(string)
  description = "List of Private DNS Zone names to create."
  default = [
    "privatelink.api.azureml.ms",
    "privatelink.notebooks.azure.net",
    "privatelink.blob.core.windows.net",
    "privatelink.file.core.windows.net",
    "privatelink.azurecr.io",
    "privatelink.vaultcore.azure.net"
  ]
}

variable "vnet_links" {
  type        = map(string)
  description = "Map of VNet names to VNet resource IDs to link each DNS zone to."
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Tags to assign to the Private DNS Zones."
  default     = {}
}
