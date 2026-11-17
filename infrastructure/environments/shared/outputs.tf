# ==============================================================================
# Outputs - Shared Environment (Phase 2: Resource Groups & Networking)
# ==============================================================================

# Resource Group Names
output "resource_groups" {
  description = "Map of all created Resource Groups."
  value = {
    shared    = module.rg_shared.name
    network   = module.rg_network.name
    alpha_dev = module.rg_alpha_dev.name
    alpha_stg = module.rg_alpha_stg.name
    alpha_prd = module.rg_alpha_prd.name
    beta_dev  = module.rg_beta_dev.name
    beta_stg  = module.rg_beta_stg.name
    beta_prd  = module.rg_beta_prd.name
  }
}

# Hub Network Outputs
output "hub_vnet_id" {
  description = "The ID of the Hub VNet."
  value       = module.vnet_hub.vnet_id
}

output "hub_vnet_name" {
  description = "The name of the Hub VNet."
  value       = module.vnet_hub.vnet_name
}

output "hub_subnets" {
  description = "Subnets inside the Hub VNet."
  value       = module.vnet_hub.subnets
}

# Team Alpha Spoke Network Outputs
output "alpha_vnet_id" {
  description = "The ID of Team Alpha Spoke VNet."
  value       = module.vnet_alpha.vnet_id
}

output "alpha_vnet_name" {
  description = "The name of Team Alpha Spoke VNet."
  value       = module.vnet_alpha.vnet_name
}

output "alpha_subnets" {
  description = "Subnets inside Team Alpha Spoke VNet."
  value       = module.vnet_alpha.subnets
}

# Team Beta Spoke Network Outputs
output "beta_vnet_id" {
  description = "The ID of Team Beta Spoke VNet."
  value       = module.vnet_beta.vnet_id
}

output "beta_vnet_name" {
  description = "The name of Team Beta Spoke VNet."
  value       = module.vnet_beta.vnet_name
}

output "beta_subnets" {
  description = "Subnets inside Team Beta Spoke VNet."
  value       = module.vnet_beta.subnets
}


# Private DNS Outputs
output "private_dns_zones" {
  description = "Map of Private DNS Zones to their resource IDs."
  value       = module.private_dns.zone_ids
}


# Shared Platform Services Outputs
output "shared_services" {
  description = "Summary of Shared Platform resources."
  value = {
    log_analytics_workspace_id   = module.monitoring.log_analytics_workspace_id
    log_analytics_workspace_name = module.monitoring.log_analytics_workspace_name
    application_insights_id      = module.monitoring.application_insights_id
    storage_account_name         = module.shared_storage.name
    storage_account_id           = module.shared_storage.id
    container_registry_name      = module.shared_acr.name
    container_registry_id        = module.shared_acr.id
    container_registry_login     = module.shared_acr.login_server
    key_vault_name               = module.shared_key_vault.name
    key_vault_id                 = module.shared_key_vault.id
    key_vault_uri                = module.shared_key_vault.vault_uri
    azureml_registry_name        = module.azureml_registry.name
    azureml_registry_id          = module.azureml_registry.id
  }
}

output "private_endpoints" {
  description = "Private IP addresses for Shared Services Private Endpoints."
  value = {
    storage_private_ip   = module.pe_shared_storage.private_ip_address
    acr_private_ip       = module.pe_shared_acr.private_ip_address
    key_vault_private_ip = module.pe_shared_key_vault.private_ip_address
  }
}
