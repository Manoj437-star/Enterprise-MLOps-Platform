# ==============================================================================
# Outputs - Team Alpha PROD Environment
# ==============================================================================

output "workspace" {
  description = "Azure ML PROD Workspace details."
  value = {
    id            = module.azureml_workspace.id
    name          = module.azureml_workspace.name
    discovery_url = module.azureml_workspace.discovery_url
    principal_id  = module.azureml_workspace.principal_id
  }
}

output "online_endpoint" {
  description = "Managed Online Endpoint details."
  value = {
    id   = azapi_resource.online_endpoint.id
    name = var.endpoint_name
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
