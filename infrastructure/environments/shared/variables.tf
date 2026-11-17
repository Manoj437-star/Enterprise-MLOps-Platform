# ==============================================================================
# Variables - Shared Environment (Phase 2: RGs and Networking)
# ==============================================================================

variable "location" {
  type        = string
  description = "Azure region where resources will be deployed."
  default     = "eastus2"
}

variable "environment" {
  type        = string
  description = "Environment identifier (e.g., poc, dev, staging, prod)."
  default     = "poc"
}

variable "hub_address_space" {
  type        = list(string)
  description = "Address space for the Shared Hub Virtual Network."
  default     = ["10.100.0.0/16"]
}

variable "alpha_spoke_address_space" {
  type        = list(string)
  description = "Address space for the Team Alpha Spoke Virtual Network."
  default     = ["10.101.0.0/16"]
}

variable "beta_spoke_address_space" {
  type        = list(string)
  description = "Address space for the Team Beta Spoke Virtual Network."
  default     = ["10.102.0.0/16"]
}

variable "tags" {
  type        = map(string)
  description = "Common baseline tags for all resources in this environment."
  default = {
    Project   = "Enterprise-MLOps-Platform"
    ManagedBy = "Terraform"
    Tier      = "Shared-Platform"
  }
}
