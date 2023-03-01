
locals {

  tst_tags = {
    AppEnv     = var.tags_app_env
    NW_Layer   = var.tags_nw_layer
    Apppoc     = var.tags_app_oc
    CC         = var.tags_cc
    Project    = var.tags_project
    EntAppname = var.tags_ent_app_name
    Pipeline   = var.pipeline
    Purpose    = "UnitTesting template"
  }
}

module "rg" {
  source              = "git::https://github.com/gerryw1389/terraform-modules.git//resource-group?ref=v1.0.0"
  resource_group_name = "aa-${var.env_stage_abbr}-${var.sub_abbr}-${var.region_abbr}-test"
  location            = var.region
  tags                = local.tst_tags
}

resource "azurerm_management_lock" "resource-group-level" {
  name       = "BlockDelete"
  scope      = module.rg.res_out_rg_id
  lock_level = "CanNotDelete"
  notes      = "Protect against accidental deletion"
}