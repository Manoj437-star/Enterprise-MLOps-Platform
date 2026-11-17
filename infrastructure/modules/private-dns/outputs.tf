# ==============================================================================
# Outputs - Private DNS Module
# ==============================================================================

output "zone_ids" {
  description = "Map of DNS zone names to their resource IDs."
  value = {
    for k, v in azurerm_private_dns_zone.this : k => v.id
  }
}

output "zone_names" {
  description = "List of created Private DNS zone names."
  value       = [for v in azurerm_private_dns_zone.this : v.name]
}
