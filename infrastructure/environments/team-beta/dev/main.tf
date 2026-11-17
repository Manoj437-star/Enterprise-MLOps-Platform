# ==============================================================================
# Main - Team Beta DEV Environment (Azure ML Workspace & Compute Cluster)
# ==============================================================================

# Unique suffix for globally unique resources (Storage, Key Vault)
resource "random_string" "beta_dev_suffix" {
  length  = 5
  special = false
  upper   = false
}

locals {
  resource_group_name = data.terraform_remote_state.shared.outputs.resource_groups["beta_dev"]
  app_insights_id     = data.terraform_remote_state.shared.outputs.shared_services.application_insights_id
  container_reg_id    = data.terraform_remote_state.shared.outputs.shared_services.container_registry_id
}

# ------------------------------------------------------------------------------
# 1. Backing Storage Account (Dedicated for Team Beta DEV Workspace)
# ------------------------------------------------------------------------------
module "workspace_storage" {
  source              = "../../../modules/storage"
  name                = "stbetadev${random_string.beta_dev_suffix.result}"
  resource_group_name = local.resource_group_name
  location            = var.location
  account_tier        = "Standard"
  replication_type    = "LRS"
  containers          = ["workspace-artifacts"]
  tags                = merge(var.tags, { Component = "Workspace-Storage" })
}

# ------------------------------------------------------------------------------
# 2. Backing Key Vault (Dedicated for Team Beta DEV Workspace)
# ------------------------------------------------------------------------------
module "workspace_key_vault" {
  source              = "../../../modules/key-vault"
  name                = "kv-bet-dev-${random_string.beta_dev_suffix.result}"
  resource_group_name = local.resource_group_name
  location            = var.location
  sku_name            = "standard"
  tags                = merge(var.tags, { Component = "Workspace-KeyVault" })
}

# ------------------------------------------------------------------------------
# 3. Azure Machine Learning Workspace (Team Beta DEV)
# ------------------------------------------------------------------------------
module "azureml_workspace" {
  source                        = "../../../modules/azureml-workspace"
  name                          = "aml-beta-dev-poc"
  resource_group_name           = local.resource_group_name
  location                      = var.location
  storage_account_id            = module.workspace_storage.id
  key_vault_id                  = module.workspace_key_vault.id
  application_insights_id       = local.app_insights_id
  container_registry_id         = local.container_reg_id
  public_network_access_enabled = true
  friendly_name                 = "Team Beta DEV Workspace (NLP)"
  description                   = "Azure ML DEV Workspace for Team Beta NLP workloads."
  tags                          = merge(var.tags, { Component = "AzureML-Workspace" })
}

# ------------------------------------------------------------------------------
# 4. Training Compute Cluster (Auto-scaling with Zero Idle Cost)
# ------------------------------------------------------------------------------
module "azureml_compute" {
  source                      = "../../../modules/azureml-compute"
  name                        = "cpu-cluster"
  workspace_id                = module.azureml_workspace.id
  location                    = var.location
  vm_size                     = var.compute_vm_size
  vm_priority                 = "Dedicated"
  min_node_count              = var.compute_min_nodes
  max_node_count              = var.compute_max_nodes
  idle_time_before_scale_down = "PT120S"
  tags                        = merge(var.tags, { Component = "Compute-Cluster" })
}
