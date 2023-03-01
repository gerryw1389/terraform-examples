
########################################################################
# Step 1: Build providers to pass to Data Sources Module
########################################################################

data "azurerm_subscriptions" "data_sources_available" {
  # Get all subscriptions
}

locals {

  available_subscriptions = data.azurerm_subscriptions.data_sources_available.subscriptions

  hubnonprod_sub_id_object   = [for sub in local.available_subscriptions : sub if sub.display_name == "automationadmin-hub-nonprod"]
  data_sources_hubnonprod_id = length(local.hubnonprod_sub_id_object) == 1 ? local.hubnonprod_sub_id_object[0].subscription_id : "error_retrieving_hub-nonprod_id"

  hubprod_sub_id_object   = [for sub in local.available_subscriptions : sub if sub.display_name == "automationadmin-hub-prod"]
  data_sources_hubprod_id = length(local.hubprod_sub_id_object) == 1 ? local.hubprod_sub_id_object[0].subscription_id : "error_retrieving_hub-prod_id"
}

provider "azurerm" {
  client_id     = trimspace(var.client_id)
  client_secret = trimspace(var.client_secret)
  tenant_id     = trimspace(var.tenant_id)
  features {}
  alias                      = "data_sources_hub_nonprod"
  skip_provider_registration = true
  subscription_id            = local.data_sources_hubnonprod_id
}

provider "azurerm" {
  client_id     = trimspace(var.client_id)
  client_secret = trimspace(var.client_secret)
  tenant_id     = trimspace(var.tenant_id)
  features {}
  alias                      = "data_sources_hub_prod"
  skip_provider_registration = true
  subscription_id            = local.data_sources_hubprod_id
}

########################################################################
# Step 2: Call the Data Sources Module
########################################################################

# Uncomment to get sensitive locals
# module "dataLookup" {
#   source          = "git::https://dev.azure.com/my-project/_git/my-repo/module.shared_data_sources?ref=v1.0.5"
#   tenant_id       = var.tenant_id
#   subscription_id = var.subscription_id
#   client_id       = var.client_id
#   client_secret   = var.client_secret
#   providers = {
#     azurerm            = azurerm
#     azurerm.nonprd-hub = azurerm.data_sources_hub_nonprod
#     azurerm.prod-hub   = azurerm.data_sources_hub_prod
#   }
# }

########################################################################
# Step 3: Create lookups based on Module's Outputs and your local environment stage and region combination
########################################################################

# Sensitive Locals
# locals {

#   lookup = "${var.env_stage_abbr}_${var.region_abbr}"

#   # Log Analytics Workspace ID
#   law_workspace_id_env_map = {
#     "nonprd_scus" = module.dataLookup.law_nscus_workspace_id,
#     "nonprd_eus" = module.dataLookup.law_ne_workspace_id,
#     "prd_scus"    = module.dataLookup.law_scus_workspace_id,
#     "prd_eus"    = module.dataLookup.law_pe_workspace_id,
#   }

#   law_workspace_id = lookup(local.law_workspace_id_env_map, local.lookup, "Error_Invalid_Lookup")
# }


# Non Sensitive Locals
locals {

  priv_dns_zone_rg           = "prod-hub-dnszone-rg"
  azconfig_io_id             = "/subscriptions/${local.data_sources_hubprod_id}/resourceGroups/${local.priv_dns_zone_rg}/providers/Microsoft.Network/privateDnsZones/privatelink.azconfig.io"
  azconfig_io_name           = "privatelink.azconfig.io"
  azure-automation_net_id    = "/subscriptions/${local.data_sources_hubprod_id}/resourceGroups/${local.priv_dns_zone_rg}/providers/Microsoft.Network/privateDnsZones/privatelink.azure-automation.net"
  azure-automation_net_name  = "privatelink.azure-automation.net"
  azureacr_io_id             = "/subscriptions/${local.data_sources_hubprod_id}/resourceGroups/${local.priv_dns_zone_rg}/providers/Microsoft.Network/privateDnsZones/privatelink.azureacr.io"
  azureacr_io_name           = "privatelink.azureacr.io"
  azurecr_io_id              = "/subscriptions/${local.data_sources_hubprod_id}/resourceGroups/${local.priv_dns_zone_rg}/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io"
  azurecr_io_name            = "privatelink.azurecr.io"
  azurewebsites_net_id       = "/subscriptions/${local.data_sources_hubprod_id}/resourceGroups/${local.priv_dns_zone_rg}/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"
  azurewebsites_net_name     = "privatelink.azurewebsites.net"
  blob_core_windows_net_id   = "/subscriptions/${local.data_sources_hubprod_id}/resourceGroups/${local.priv_dns_zone_rg}/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
  blob_core_windows_net_name = "privatelink.blob.core.windows.net"
  database_windows_net_id    = "/subscriptions/${local.data_sources_hubprod_id}/resourceGroups/${local.priv_dns_zone_rg}/providers/Microsoft.Network/privateDnsZones/privatelink.database.windows.net"
  database_windows_net_name  = "privatelink.database.windows.net"

  file_core_windows_net_id         = "/subscriptions/${local.data_sources_hubprod_id}/resourceGroups/${local.priv_dns_zone_rg}/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net"
  file_core_windows_net_name       = "privatelink.file.core.windows.net"
  postgres_database_azure_com_id   = "/subscriptions/${local.data_sources_hubprod_id}/resourceGroups/${local.priv_dns_zone_rg}/providers/Microsoft.Network/privateDnsZones/privatelink.postgres.database.azure.com"
  postgres_database_azure_com_name = "privatelink.postgres.database.azure.com"
  queue_core_windows_net_id        = "/subscriptions/${local.data_sources_hubprod_id}/resourceGroups/${local.priv_dns_zone_rg}/providers/Microsoft.Network/privateDnsZones/privatelink.queue.core.windows.net"
  queue_core_windows_net_name      = "privatelink.queue.core.windows.net"
  servicebus_windows_net_id        = "/subscriptions/${local.data_sources_hubprod_id}/resourceGroups/${local.priv_dns_zone_rg}/providers/Microsoft.Network/privateDnsZones/privatelink.servicebus.windows.net"
  servicebus_windows_net_name      = "privatelink.servicebus.windows.net"
  table_core_windows_net_id        = "/subscriptions/${local.data_sources_hubprod_id}/resourceGroups/${local.priv_dns_zone_rg}/providers/Microsoft.Network/privateDnsZones/privatelink.table.core.windows.net"
  table_core_windows_net_name      = "privatelink.table.core.windows.net"
  vaultcore_azure_net_id           = "/subscriptions/${local.data_sources_hubprod_id}/resourceGroups/${local.priv_dns_zone_rg}/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"
  vaultcore_azure_net_name         = "privatelink.vaultcore.azure.net"
  web_core_windows_net_id          = "/subscriptions/${local.data_sources_hubprod_id}/resourceGroups/${local.priv_dns_zone_rg}/providers/Microsoft.Network/privateDnsZones/privatelink.web.core.windows.net"
  web_core_windows_net_name        = "privatelink.web.core.windows.net"


}
