# ==============================================================================
# Main - Team Alpha PROD Environment (Production Workspace & Online Endpoint)
# ==============================================================================

resource "random_string" "alpha_prd_suffix" {
  length  = 5
  special = false
  upper   = false
}

locals {
  resource_group_name = data.terraform_remote_state.shared.outputs.resource_groups["alpha_prd"]
  app_insights_id     = data.terraform_remote_state.shared.outputs.shared_services.application_insights_id
  container_reg_id    = data.terraform_remote_state.shared.outputs.shared_services.container_registry_id
}

# 1. Backing Storage Account (Dedicated for Team Alpha PROD Workspace)
module "workspace_storage" {
  source              = "../../../modules/storage"
  name                = "stalpprd${random_string.alpha_prd_suffix.result}"
  resource_group_name = local.resource_group_name
  location            = var.location
  account_tier        = "Standard"
  replication_type    = "LRS"
  containers          = ["workspace-artifacts", "production-models"]
  tags                = merge(var.tags, { Component = "Workspace-Storage" })
}

# 2. Backing Key Vault (Dedicated for Team Alpha PROD Workspace)
module "workspace_key_vault" {
  source              = "../../../modules/key-vault"
  name                = "kv-alp-prd-${random_string.alpha_prd_suffix.result}"
  resource_group_name = local.resource_group_name
  location            = var.location
  sku_name            = "standard"
  tags                = merge(var.tags, { Component = "Workspace-KeyVault" })
}

# 3. Azure Machine Learning Workspace (Team Alpha PROD)
module "azureml_workspace" {
  source                        = "../../../modules/azureml-workspace"
  name                          = "aml-alpha-prd-poc"
  resource_group_name           = local.resource_group_name
  location                      = var.location
  storage_account_id            = module.workspace_storage.id
  key_vault_id                  = module.workspace_key_vault.id
  application_insights_id       = local.app_insights_id
  container_registry_id         = local.container_reg_id
  public_network_access_enabled = true
  friendly_name                 = "Team Alpha PROD Workspace (Computer Vision)"
  description                   = "Production Azure ML Workspace for serving Team Alpha models."
  tags                          = merge(var.tags, { Component = "AzureML-Workspace" })
}

# 4. Azure ML Managed Online Endpoint (Blue/Green Inference Endpoint)
resource "azapi_resource" "online_endpoint" {
  type                      = "Microsoft.MachineLearningServices/workspaces/onlineEndpoints@2024-04-01-preview"
  name                      = var.endpoint_name
  parent_id                 = module.azureml_workspace.id
  location                  = var.location
  schema_validation_enabled = false

  body = jsonencode({
    identity = {
      type = "SystemAssigned"
    }
    properties = {
      authMode    = "Key"
      description = "Managed Online Endpoint for Team Alpha Computer Vision inference"
      traffic     = {}
    }
  })

  tags = merge(var.tags, { Component = "Managed-Online-Endpoint" })
}
