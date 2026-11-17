# ==============================================================================
# Outputs - Team Alpha STAGING Environment
# ==============================================================================

output "workspace" {
  description = "Azure ML STAGING Workspace details."
  value = {
    id            = module.azureml_workspace.id
    name          = module.azureml_workspace.name
    discovery_url = module.azureml_workspace.discovery_url
    principal_id  = module.azureml_workspace.principal_id
  }
}

output "backing_storage" {
  description = "Dedicated Backing Storage Account."
  value = {
    id   = module.workspace_storage.id
    name = module.workspace_storage.name
  }
}

output "backing_key_vault" {
  description = "Dedicated Backing Key Vault."
  value = {
    id   = module.workspace_key_vault.id
    name = module.workspace_key_vault.name
    uri  = module.workspace_key_vault.vault_uri
  }
}
