# ==============================================================================
# Variables - Team Alpha PROD Environment
# ==============================================================================

variable "environment" {
  type        = string
  description = "Environment identifier."
  default     = "prd"
}

variable "location" {
  type        = string
  description = "Azure region for deployment."
  default     = "eastus2"
}

variable "team" {
  type        = string
  description = "Team identifier."
  default     = "team-alpha"
}

variable "domain" {
  type        = string
  description = "ML business domain."
  default     = "Computer-Vision"
}

variable "endpoint_name" {
  type        = string
  description = "Name of the Managed Online Endpoint."
  default     = "mep-alpha-cv-poc"
}

variable "tags" {
  type        = map(string)
  description = "Common resource tags."
  default = {
    Project     = "Enterprise-MLOps-Platform"
    Team        = "Team-Alpha"
    Domain      = "Computer-Vision"
    Environment = "PROD"
    ManagedBy   = "Terraform"
  }
}
