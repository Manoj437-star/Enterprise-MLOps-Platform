# ==============================================================================
# Variables - Networking Module (VNet, Subnets & NSG)
# ==============================================================================

variable "vnet_name" {
  type        = string
  description = "The name of the Virtual Network."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the virtual network."
}

variable "location" {
  type        = string
  description = "The Azure region where the virtual network should exist."
  default     = "eastus2"
}

variable "address_space" {
  type        = list(string)
  description = "The address space used by the virtual network (e.g. ['10.100.0.0/16'])."
}

variable "subnets" {
  type = map(object({
    address_prefixes                          = list(string)
    service_endpoints                         = optional(list(string), [])
    private_endpoint_network_policies_enabled = optional(bool, true)
  }))
  description = "Map of subnets to create within the virtual network."
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to all network resources."
  default     = {}
}
