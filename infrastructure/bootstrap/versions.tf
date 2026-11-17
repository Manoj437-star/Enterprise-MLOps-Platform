# ==============================================================================
# Terraform & Provider Version Constraints - Bootstrap
# ==============================================================================

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
  }

  # Remote Azure Blob backend for bootstrap state
  backend "azurerm" {
    resource_group_name  = "rg-mlops-tfstate-poc"
    storage_account_name = "stmlopstfdfb9yd"
    container_name       = "tfstate"
    key                  = "bootstrap.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
