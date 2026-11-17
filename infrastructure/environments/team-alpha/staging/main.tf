# ==============================================================================
# Main - Team Alpha STAGING Environment (Validation Workspace)
# ==============================================================================

resource "random_string" "alpha_stg_suffix" {
  length  = 5
  special = false
  upper   = false
}

locals {
  resource_group_name = data.terraform_remote_state.shared.outputs.resource_groups["alpha_stg"]
  app_insights_id     = data.terraform_remote_state.shared.outputs.shared_services.application_insights_id
  container_reg_id    = data.terraform_remote_state.shared.outputs.shared_services.container_registry_id
}

# 1. Backing Storage Account (Dedicated for Team Alpha STAGING Workspace)
module "workspace_storage" {
  source              = "../../../modules/storage"
  name                = "stalpstg${random_string.alpha_stg_suffix.result}"
  resource_group_name = local.resource_group_name
  location            = var.location
  account_tier        = "Standard"
  replication_type    = "LRS"
  containers          = ["workspace-artifacts", "validation-reports"]
  tags                = merge(var.tags, { Component = "Workspace-Storage" })
}

# 2. Backing Key Vault (Dedicated for Team Alpha STAGING Workspace)
module "workspace_key_vault" {
  source              = "../../../modules/key-vault"
  name                = "kv-alp-stg-${random_string.alpha_stg_suffix.result}"
  resource_group_name = local.resource_group_name
  location            = var.location
  sku_name            = "standard"
  tags                = merge(var.tags, { Component = "Workspace-KeyVault" })
}

# 3. Azure Machine Learning Workspace (Team Alpha STAGING - Model Validation & Gating)
module "azureml_workspace" {
  source                        = "../../../modules/azureml-workspace"
  name                          = "aml-alpha-stg-poc"
  resource_group_name           = local.resource_group_name
  location                      = var.location
  storage_account_id            = module.workspace_storage.id
  key_vault_id                  = module.workspace_key_vault.id
  application_insights_id       = local.app_insights_id
  container_registry_id         = local.container_reg_id
  public_network_access_enabled = true
  friendly_name                 = "Team Alpha STAGING Workspace (Computer Vision)"
  description                   = "Azure ML STAGING Workspace for Team Alpha model validation, testing, and quality gating."
  tags                          = merge(var.tags, { Component = "AzureML-Workspace" })
}
