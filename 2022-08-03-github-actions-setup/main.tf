
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
  
  required_version = "~>1.2.0"
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
  source              = "./modules/resource_group"
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

module "azure_learning_rg_2" {
  source              = "./modules/resource_group"
  resource_group_name = "aa-${var.env_stage_abbr}-${var.region_abbr}-test-2"
  location            = var.region
  tags                = local.sbx_tags
}

resource "azurerm_management_lock" "resource-group-level-2" {
  name       = "BlockDelete"
  scope      = module.azure_learning_rg_2.res_out_rg_id
  lock_level = "CanNotDelete"
  notes      = "Protect against accidental deletion"
}

###################### < /Resources > ######################
