# ==============================================================================
# Main - Shared Environment (Phase 2: Resource Groups & Hub-Spoke Networking)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. Resource Groups
# ------------------------------------------------------------------------------

# Shared Platform Services Resource Group
module "rg_shared" {
  source   = "../../modules/resource-group"
  name     = "rg-mlops-shared-${var.environment}"
  location = var.location
  tags     = merge(var.tags, { Role = "Shared-Platform-Services" })
}

# Dedicated Networking Resource Group
module "rg_network" {
  source   = "../../modules/resource-group"
  name     = "rg-mlops-network-${var.environment}"
  location = var.location
  tags     = merge(var.tags, { Role = "Networking-Hub-Spoke" })
}

# Team Alpha (Computer Vision) Resource Groups
module "rg_alpha_dev" {
  source   = "../../modules/resource-group"
  name     = "rg-mlops-alpha-dev-${var.environment}"
  location = var.location
  tags     = merge(var.tags, { Team = "Team-Alpha", Environment = "DEV" })
}

module "rg_alpha_stg" {
  source   = "../../modules/resource-group"
  name     = "rg-mlops-alpha-stg-${var.environment}"
  location = var.location
  tags     = merge(var.tags, { Team = "Team-Alpha", Environment = "STAGING" })
}

module "rg_alpha_prd" {
  source   = "../../modules/resource-group"
  name     = "rg-mlops-alpha-prd-${var.environment}"
  location = var.location
  tags     = merge(var.tags, { Team = "Team-Alpha", Environment = "PROD" })
}

# Team Beta (NLP) Resource Groups
module "rg_beta_dev" {
  source   = "../../modules/resource-group"
  name     = "rg-mlops-beta-dev-${var.environment}"
  location = var.location
  tags     = merge(var.tags, { Team = "Team-Beta", Environment = "DEV" })
}

module "rg_beta_stg" {
  source   = "../../modules/resource-group"
  name     = "rg-mlops-beta-stg-${var.environment}"
  location = var.location
  tags     = merge(var.tags, { Team = "Team-Beta", Environment = "STAGING" })
}

module "rg_beta_prd" {
  source   = "../../modules/resource-group"
  name     = "rg-mlops-beta-prd-${var.environment}"
  location = var.location
  tags     = merge(var.tags, { Team = "Team-Beta", Environment = "PROD" })
}

# ------------------------------------------------------------------------------
# 2. Virtual Networks (Hub & Spoke Topology)
# ------------------------------------------------------------------------------

# A. Central Hub VNet (Shared Private Endpoints & Monitoring)
module "vnet_hub" {
  source              = "../../modules/networking"
  vnet_name           = "vnet-shared-hub"
  resource_group_name = module.rg_network.name
  location            = var.location
  address_space       = var.hub_address_space

  subnets = {
    "snet-shared-pe" = {
      address_prefixes                          = ["10.100.1.0/24"]
      private_endpoint_network_policies_enabled = true
      service_endpoints                         = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.ContainerRegistry"]
    }
  }

  tags = merge(var.tags, { Topology = "Hub" })
}

# B. Team Alpha Spoke VNet (Computer Vision DEV / STG / PRD Subnets)
module "vnet_alpha" {
  source              = "../../modules/networking"
  vnet_name           = "vnet-team-alpha"
  resource_group_name = module.rg_network.name
  location            = var.location
  address_space       = var.alpha_spoke_address_space

  subnets = {
    "snet-alpha-dev" = {
      address_prefixes                          = ["10.101.1.0/24"]
      private_endpoint_network_policies_enabled = true
      service_endpoints                         = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.ContainerRegistry"]
    }
    "snet-alpha-stg" = {
      address_prefixes                          = ["10.101.2.0/24"]
      private_endpoint_network_policies_enabled = true
      service_endpoints                         = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.ContainerRegistry"]
    }
    "snet-alpha-prd" = {
      address_prefixes                          = ["10.101.3.0/24"]
      private_endpoint_network_policies_enabled = true
      service_endpoints                         = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.ContainerRegistry"]
    }
  }

  tags = merge(var.tags, { Topology = "Spoke", Team = "Team-Alpha" })
}

# C. Team Beta Spoke VNet (NLP DEV / STG / PRD Subnets)
module "vnet_beta" {
  source              = "../../modules/networking"
  vnet_name           = "vnet-team-beta"
  resource_group_name = module.rg_network.name
  location            = var.location
  address_space       = var.beta_spoke_address_space

  subnets = {
    "snet-beta-dev" = {
      address_prefixes                          = ["10.102.1.0/24"]
      private_endpoint_network_policies_enabled = true
      service_endpoints                         = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.ContainerRegistry"]
    }
    "snet-beta-stg" = {
      address_prefixes                          = ["10.102.2.0/24"]
      private_endpoint_network_policies_enabled = true
      service_endpoints                         = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.ContainerRegistry"]
    }
    "snet-beta-prd" = {
      address_prefixes                          = ["10.102.3.0/24"]
      private_endpoint_network_policies_enabled = true
      service_endpoints                         = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.ContainerRegistry"]
    }
  }

  tags = merge(var.tags, { Topology = "Spoke", Team = "Team-Beta" })
}

# ------------------------------------------------------------------------------
# 3. VNet Peering (Hub-to-Spoke & Spoke-to-Hub)
# ------------------------------------------------------------------------------

# Peering: Hub <--> Team Alpha
resource "azurerm_virtual_network_peering" "hub_to_alpha" {
  name                         = "peering-hub-to-alpha"
  resource_group_name          = module.rg_network.name
  virtual_network_name         = module.vnet_hub.vnet_name
  remote_virtual_network_id    = module.vnet_alpha.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "alpha_to_hub" {
  name                         = "peering-alpha-to-hub"
  resource_group_name          = module.rg_network.name
  virtual_network_name         = module.vnet_alpha.vnet_name
  remote_virtual_network_id    = module.vnet_hub.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# Peering: Hub <--> Team Beta
resource "azurerm_virtual_network_peering" "hub_to_beta" {
  name                         = "peering-hub-to-beta"
  resource_group_name          = module.rg_network.name
  virtual_network_name         = module.vnet_hub.vnet_name
  remote_virtual_network_id    = module.vnet_beta.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "beta_to_hub" {
  name                         = "peering-beta-to-hub"
  resource_group_name          = module.rg_network.name
  virtual_network_name         = module.vnet_beta.vnet_name
  remote_virtual_network_id    = module.vnet_hub.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}


# ------------------------------------------------------------------------------
# 4. Private DNS Zones & Virtual Network Links (Phase 3: DNS Resolution)
# ------------------------------------------------------------------------------

module "private_dns" {
  source              = "../../modules/private-dns"
  resource_group_name = module.rg_network.name

  dns_zones = [
    "privatelink.api.azureml.ms",
    "privatelink.notebooks.azure.net",
    "privatelink.blob.core.windows.net",
    "privatelink.file.core.windows.net",
    "privatelink.azurecr.io",
    "privatelink.vaultcore.azure.net"
  ]

  vnet_links = {
    "hub"   = module.vnet_hub.vnet_id
    "alpha" = module.vnet_alpha.vnet_id
    "beta"  = module.vnet_beta.vnet_id
  }

  tags = merge(var.tags, { Component = "Private-DNS" })
}


# ------------------------------------------------------------------------------
# 5. Shared Platform Services (Phase 4: Monitoring, Storage, ACR, KV & AML Registry)
# ------------------------------------------------------------------------------

# Random suffix for globally unique naming
resource "random_string" "shared_suffix" {
  length  = 5
  special = false
  upper   = false
}

# A. Central Monitoring (Log Analytics Workspace & Application Insights)
module "monitoring" {
  source              = "../../modules/monitoring"
  name_prefix         = "mlops-${var.environment}"
  resource_group_name = module.rg_shared.name
  location            = var.location
  retention_in_days   = 30
  tags                = merge(var.tags, { Component = "Monitoring" })
}

# B. Shared Storage Account (Datasets & Model Artifacts)
module "shared_storage" {
  source              = "../../modules/storage"
  name                = "stmlopsshared${random_string.shared_suffix.result}"
  resource_group_name = module.rg_shared.name
  location            = var.location
  containers          = ["golden-datasets", "models", "code"]
  tags                = merge(var.tags, { Component = "Shared-Storage" })
}

# C. Shared Azure Container Registry (Golden Base Images)
module "shared_acr" {
  source              = "../../modules/container-registry"
  name                = "crmlopsshared${random_string.shared_suffix.result}"
  resource_group_name = module.rg_shared.name
  location            = var.location
  sku                 = "Premium"
  tags                = merge(var.tags, { Component = "Shared-ACR" })
}

# D. Shared Key Vault (Enterprise Secrets & Credentials)
module "shared_key_vault" {
  source              = "../../modules/key-vault"
  name                = "kv-mlops-sh-${random_string.shared_suffix.result}"
  resource_group_name = module.rg_shared.name
  location            = var.location
  tags                = merge(var.tags, { Component = "Shared-KeyVault" })
}

# E. Central Azure ML Registry (Model & Environment Catalog)
module "azureml_registry" {
  source                = "../../modules/azureml-registry"
  name                  = "amlregmlopsshared${var.environment}"
  resource_group_name   = module.rg_shared.name
  location              = var.location
  storage_account_id    = module.shared_storage.id
  container_registry_id = module.shared_acr.id
  tags                  = merge(var.tags, { Component = "AzureML-Registry" })
}

# ------------------------------------------------------------------------------
# 6. Private Endpoints for Shared Services (Phase 4: Network Isolation)
# ------------------------------------------------------------------------------

# Private Endpoint for Shared Storage (Blob)
module "pe_shared_storage" {
  source                         = "../../modules/private-endpoint"
  name                           = "pe-stmlops-shared-blob"
  location                       = var.location
  resource_group_name            = module.rg_network.name
  subnet_id                      = module.vnet_hub.subnets["snet-shared-pe"].id
  private_connection_resource_id = module.shared_storage.id
  subresource_names              = ["blob"]

  private_dns_zone_group = {
    name                 = "pdzg-shared-storage-blob"
    private_dns_zone_ids = [module.private_dns.zone_ids["privatelink.blob.core.windows.net"]]
  }

  tags = merge(var.tags, { Component = "Private-Endpoint-Storage" })
}

# Private Endpoint for Shared ACR
module "pe_shared_acr" {
  source                         = "../../modules/private-endpoint"
  name                           = "pe-crmlops-shared-registry"
  location                       = var.location
  resource_group_name            = module.rg_network.name
  subnet_id                      = module.vnet_hub.subnets["snet-shared-pe"].id
  private_connection_resource_id = module.shared_acr.id
  subresource_names              = ["registry"]

  private_dns_zone_group = {
    name                 = "pdzg-shared-acr"
    private_dns_zone_ids = [module.private_dns.zone_ids["privatelink.azurecr.io"]]
  }

  tags = merge(var.tags, { Component = "Private-Endpoint-ACR" })
}

# Private Endpoint for Shared Key Vault
module "pe_shared_key_vault" {
  source                         = "../../modules/private-endpoint"
  name                           = "pe-kvmlops-shared-vault"
  location                       = var.location
  resource_group_name            = module.rg_network.name
  subnet_id                      = module.vnet_hub.subnets["snet-shared-pe"].id
  private_connection_resource_id = module.shared_key_vault.id
  subresource_names              = ["vault"]

  private_dns_zone_group = {
    name                 = "pdzg-shared-key-vault"
    private_dns_zone_ids = [module.private_dns.zone_ids["privatelink.vaultcore.azure.net"]]
  }

  tags = merge(var.tags, { Component = "Private-Endpoint-KeyVault" })
}
