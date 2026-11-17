# ==============================================================================
# Versions & Remote Backend - Shared Environment
# ==============================================================================

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.13.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
  }

  # Configured to use the dedicated remote state storage provisioned in Phase 1
  backend "azurerm" {
    resource_group_name  = "rg-mlops-tfstate-poc"
    storage_account_name = "stmlopstfdfb9yd"
    container_name       = "tfstate"
    key                  = "shared.tfstate"
  }
}

provider "azurerm" {
  features {}
}
