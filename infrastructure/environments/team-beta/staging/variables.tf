# ==============================================================================
# Variables - Team Beta STAGING Environment
# ==============================================================================

variable "environment" {
  type        = string
  description = "Environment identifier."
  default     = "stg"
}

variable "location" {
  type        = string
  description = "Azure region for deployment."
  default     = "eastus2"
}

variable "team" {
  type        = string
  description = "Team identifier."
  default     = "team-beta"
}

variable "domain" {
  type        = string
  description = "ML business domain."
  default     = "NLP"
}

variable "tags" {
  type        = map(string)
  description = "Common resource tags."
  default = {
    Project     = "Enterprise-MLOps-Platform"
    Team        = "Team-Beta"
    Domain      = "NLP"
    Environment = "STAGING"
    ManagedBy   = "Terraform"
  }
}
