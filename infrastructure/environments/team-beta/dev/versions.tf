# ==============================================================================
# Versions & Remote State - Team Beta DEV Environment
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

  backend "azurerm" {
    resource_group_name  = "rg-mlops-tfstate-poc"
    storage_account_name = "stmlopstfdfb9yd"
    container_name       = "tfstate"
    key                  = "team-beta-dev.tfstate"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Reference Central Shared Platform Outputs
data "terraform_remote_state" "shared" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-mlops-tfstate-poc"
    storage_account_name = "stmlopstfdfb9yd"
    container_name       = "tfstate"
    key                  = "shared.tfstate"
  }
}
