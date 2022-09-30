
###################### < Providers > ######################

terraform {
  
  backend "azurerm" {
    resource_group_name  = "tx-storage-rg"
    storage_account_name = "automationadminstorage"
    container_name       = "tfstatesbx"
    key                  = "learning_rg"
  }

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>3.10.0"
    }
  }
  
  required_version = "1.2.0"
}

provider "azurerm" {
  client_id                  = var.client_id
  client_secret              = var.client_secret
  subscription_id            = var.subscription_id
  tenant_id                  = var.tenant_id
  skip_provider_registration = true
  features {}
}

###################### < /Providers > ######################
###################### < Locals > ######################

locals {
  sbx_tags = {
    Owner      = "Automation Admin"
    CostCenter = "100"
    EntAppname = "Automation Admin Terraform POC"
    Appenv     = var.env_stage
    Apppoc     = "gerry@automationadmin.com"
  }
}

###################### < /Locals > ######################
###################### < Resources > ######################

module "azure_learning_rg" {
  source              = "git::https://github.com/gerryw1389/terraform-modules.git//resource-group?ref=v1.0.0"
  resource_group_name = "aa-${var.env_stage_abbr}-${var.region_abbr}-test-remote"
  location            = var.region
  tags                = local.sbx_tags
}

resource "azurerm_management_lock" "resource-group-level" {
  name       = "BlockDelete"
  scope      = module.azure_learning_rg.res_out_rg_id
  lock_level = "CanNotDelete"
  notes      = "Protect against accidental deletion"
}

###################### < /Resources > ######################
