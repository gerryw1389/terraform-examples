
locals {
  sbx_tags = {
    Owner      = "Automation Admin"
    CostCenter = "100"
    EntAppname = "Automation Admin Terraform POC"
    Appenv     = var.env_stage
    Apppoc     = "gerry@automationadmin.com"
  }
}

module "azure_learning_rg" {
  source              = "./ResourceGroup"
  resource_group_name = "aa-${var.env_stage_abbr}-${var.region_abbr}-test"
  location            = var.region
  tags                = local.sbx_tags
}

resource "azurerm_management_lock" "resource-group-level" {
  name       = "BlockDelete"
  scope      = module.azure_learning_rg.res_out_rg_id
  lock_level = "CanNotDelete"
  notes      = "Protect against accidental deletion"
}