# ==============================================================================
# Variables - Azure ML Compute Module
# ==============================================================================

variable "name" {
  type        = string
  description = "The name of the Azure Machine Learning Compute Cluster."
  default     = "cpu-cluster"
}

variable "location" {
  type        = string
  description = "The Azure region for the Compute Cluster."
  default     = "eastus2"
}

variable "workspace_id" {
  type        = string
  description = "The resource ID of the parent Azure Machine Learning Workspace."
}

variable "vm_size" {
  type        = string
  description = "The size of the Virtual Machine for compute nodes."
  default     = "Standard_DS2_v2"
}

variable "vm_priority" {
  type        = string
  description = "The priority of the VM (Dedicated or LowPriority)."
  default     = "Dedicated"
}

variable "min_node_count" {
  type        = number
  description = "Minimum number of nodes (0 allows idle scale to zero)."
  default     = 0
}

variable "max_node_count" {
  type        = number
  description = "Maximum number of nodes to scale up to."
  default     = 2
}

variable "idle_time_before_scale_down" {
  type        = string
  description = "ISO 8601 duration after which idle nodes scale down (e.g. PT120S for 2 minutes)."
  default     = "PT120S"
}

variable "subnet_resource_id" {
  type        = string
  description = "The ID of the Subnet where the Compute Cluster should be attached (optional)."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags to assign to the Compute Cluster."
  default     = {}
}
