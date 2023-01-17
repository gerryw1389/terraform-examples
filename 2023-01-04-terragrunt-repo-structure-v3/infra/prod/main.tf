
locals {
  aa_tags = {
    Owner       = "Automation Admin"
    CostCenter  = "100"
    Description = "Automation Admin Terraform POC"
    Environment = var.env_stage_abbr
    App_Contact = "gerry@automationadmin.com"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "aa-${var.env_stage_abbr}-${var.region_abbr}-mgmt-rg"
  location = var.region
  tags     = local.aa_tags
}
