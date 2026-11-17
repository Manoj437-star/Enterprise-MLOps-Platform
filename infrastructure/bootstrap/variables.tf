# ==============================================================================
# Variables - Terraform State Bootstrap
# ==============================================================================

variable "location" {
  type        = string
  description = "Azure region where the Terraform state storage will be deployed."
  default     = "eastus2"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the dedicated Resource Group for remote Terraform state."
  default     = "rg-mlops-tfstate-poc"
}

variable "storage_account_prefix" {
  type        = string
  description = "Prefix for the remote state storage account (must be alphanumeric, lowercase, max 16 chars)."
  default     = "stmlopstf"
  validation {
    condition     = can(regex("^[a-z0-9]{3,16}$", var.storage_account_prefix))
    error_message = "Storage account prefix must be between 3 and 16 lowercase alphanumeric characters."
  }
}

variable "container_name" {
  type        = string
  description = "Name of the Blob container for storing remote tfstate files."
  default     = "tfstate"
}

variable "environment" {
  type        = string
  description = "Deployment environment name."
  default     = "poc"
}

variable "tags" {
  type        = map(string)
  description = "Standard tags to assign to all state resources."
  default = {
    Project     = "Enterprise-MLOps-Platform"
    ManagedBy   = "Terraform"
    Environment = "POC"
    Component   = "Terraform-Remote-State"
  }
}
