# ==============================================================================
# Variables - Team Beta DEV Environment
# ==============================================================================

variable "environment" {
  type        = string
  description = "Environment identifier (dev, staging, prod)."
  default     = "dev"
}

variable "location" {
  type        = string
  description = "Azure region for deployment."
  default     = "eastus2"
}

variable "team" {
  type        = string
  description = "Team identifier."
  default     = "team-beta"
}

variable "domain" {
  type        = string
  description = "ML business domain."
  default     = "NLP"
}

variable "compute_vm_size" {
  type        = string
  description = "VM size for the training compute cluster."
  default     = "Standard_DS2_v2"
}

variable "compute_min_nodes" {
  type        = number
  description = "Minimum nodes for compute cluster (0 for zero idle cost)."
  default     = 0
}

variable "compute_max_nodes" {
  type        = number
  description = "Maximum nodes for compute cluster (within subscription quota)."
  default     = 1
}

variable "tags" {
  type        = map(string)
  description = "Common resource tags."
  default = {
    Project     = "Enterprise-MLOps-Platform"
    Team        = "Team-Beta"
    Domain      = "NLP"
    Environment = "DEV"
    ManagedBy   = "Terraform"
  }
}
