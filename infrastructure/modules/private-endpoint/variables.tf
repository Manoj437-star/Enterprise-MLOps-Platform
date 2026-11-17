# ==============================================================================
# Variables - Private Endpoint Module
# ==============================================================================

variable "name" {
  type        = string
  description = "The name of the Private Endpoint."
}

variable "location" {
  type        = string
  description = "The Azure region where the Private Endpoint should be created."
  default     = "eastus2"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the Private Endpoint will reside."
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet from which Private IP addresses will be allocated."
}

variable "private_connection_resource_id" {
  type        = string
  description = "The resource ID of the Azure PaaS service to link (Storage, ACR, KV, AML, etc.)."
}

variable "subresource_names" {
  type        = list(string)
  description = "The subresource name to connect to (e.g., ['blob'], ['vault'], ['registry'], ['amlworkspace'])."
}

variable "private_dns_zone_group" {
  type = object({
    name                 = string
    private_dns_zone_ids = list(string)
  })
  description = "Optional configuration to automatically register DNS records in Azure Private DNS Zones."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags to assign to the Private Endpoint."
  default     = {}
}
