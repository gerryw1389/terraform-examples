
locals {
  aa_tags = {
    Owner       = "Automation Admin"
    CostCenter  = "100"
    Description = "Automation Admin Terraform POC"
    Environment = var.env_stage_abbr
    App_Contact = "gerry@automationadmin.com"
  }
}

resource "azurerm_resource_group" "hub_prod_rg" {
  name     = "aa-${var.env_stage_abbr}-${var.region_abbr}-mgmt-rg"
  location = var.region
  tags     = local.aa_tags
  provider = azurerm.hub-prod
}

resource "azurerm_resource_group" "hub_nonprod_rg" {
  name     = "aa-${var.env_stage_abbr}-${var.region_abbr}-mgmt-rg"
  location = var.region
  tags     = local.aa_tags
  provider = azurerm.hub-nonprod
}

resource "azurerm_resource_group" "spoke_prod_rg" {
  name     = "aa-${var.env_stage_abbr}-${var.region_abbr}-mgmt-rg"
  location = var.region
  tags     = local.aa_tags
  provider = azurerm.spoke-prod
}

resource "azurerm_resource_group" "spoke_nonprod_rg" {
  name     = "aa-${var.env_stage_abbr}-${var.region_abbr}-mgmt-rg"
  location = var.region
  tags     = local.aa_tags
  provider = azurerm.spoke-nonprod
}

### Mgmt Groups

# Read in parent
data "azurerm_management_group" "management" {
name = "Automation Admin"
}

# Create child "Hub"
resource "azurerm_management_group" "mgmt_hub" {
display_name               = "Hub"
parent_management_group_id = data.azurerm_management_group.management.id
}

resource "azurerm_management_group" "mgmt_hub_prod" {
display_name               = "Prod"
parent_management_group_id = azurerm_management_group.mgmt_hub.id
subscription_ids           = [var.hub_prod_id]
}

resource "azurerm_management_group" "mgmt_hub_nonprod" {
display_name               = "NonProd"
parent_management_group_id = azurerm_management_group.mgmt_hub.id
subscription_ids           = [var.hub_nonprod_id]
}

# Create child "Spoke"
resource "azurerm_management_group" "mgmt_spoke" {
display_name               = "Spoke"
parent_management_group_id = data.azurerm_management_group.management.id
}

resource "azurerm_management_group" "mgmt_spoke_prod" {
display_name               = "Prod"
parent_management_group_id = azurerm_management_group.mgmt_spoke.id
subscription_ids           = [var.spoke_prod_id]
}

resource "azurerm_management_group" "mgmt_spoke_nonprod" {
display_name               = "NonProd"
parent_management_group_id = azurerm_management_group.mgmt_spoke.id
subscription_ids           = [var.spoke_nonprod_id]
}