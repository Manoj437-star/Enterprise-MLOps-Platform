# ==============================================================================
# Outputs - Team Beta DEV Environment
# ==============================================================================

output "workspace" {
  description = "Azure ML Workspace details."
  value = {
    id            = module.azureml_workspace.id
    name          = module.azureml_workspace.name
    discovery_url = module.azureml_workspace.discovery_url
    principal_id  = module.azureml_workspace.principal_id
  }
}

output "compute_cluster" {
  description = "Training Compute Cluster details."
  value = {
    id        = module.azureml_compute.id
    name      = module.azureml_compute.name
    vm_size   = var.compute_vm_size
    min_nodes = var.compute_min_nodes
    max_nodes = var.compute_max_nodes
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
