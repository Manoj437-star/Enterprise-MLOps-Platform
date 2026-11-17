# ==============================================================================
# Variables - Resource Group Module
# ==============================================================================

variable "name" {
  type        = string
  description = "The name of the Resource Group."
}

variable "location" {
  type        = string
  description = "The Azure Region where the Resource Group should exist."
  default     = "eastus2"
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the Resource Group."
  default     = {}
}
