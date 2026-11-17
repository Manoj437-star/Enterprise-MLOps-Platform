# ==============================================================================
# Main - Azure ML Compute Module
# ==============================================================================

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100.0"
    }
  }
}

resource "azurerm_machine_learning_compute_cluster" "this" {
  name                          = var.name
  location                      = var.location
  machine_learning_workspace_id = var.workspace_id
  vm_size                       = var.vm_size
  vm_priority                   = var.vm_priority
  subnet_resource_id            = var.subnet_resource_id

  scale_settings {
    min_node_count                       = var.min_node_count
    max_node_count                       = var.max_node_count
    scale_down_nodes_after_idle_duration = var.idle_time_before_scale_down
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}
