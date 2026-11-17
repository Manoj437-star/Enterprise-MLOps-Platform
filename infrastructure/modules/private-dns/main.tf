# ==============================================================================
# Main - Private DNS Module
# ==============================================================================

# 1. Private DNS Zones
resource "azurerm_private_dns_zone" "this" {
  for_each = toset(var.dns_zones)

  name                = each.value
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# 2. Flatten Cartesian product of DNS zones and VNets for linking
locals {
  dns_vnet_links = merge([
    for zone in var.dns_zones : {
      for vnet_name, vnet_id in var.vnet_links :
      "${replace(zone, ".", "-")}_${vnet_name}" => {
        zone_name = zone
        vnet_name = vnet_name
        vnet_id   = vnet_id
      }
    }
  ]...)
}

# 3. Virtual Network Links
resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each = local.dns_vnet_links

  name                  = "link-${each.value.vnet_name}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this[each.value.zone_name].name
  virtual_network_id    = each.value.vnet_id
  registration_enabled  = false
  tags                  = var.tags
}
