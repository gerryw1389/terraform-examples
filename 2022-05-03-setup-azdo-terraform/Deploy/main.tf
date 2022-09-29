
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
