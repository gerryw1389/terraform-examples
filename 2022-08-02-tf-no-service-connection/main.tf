
# ---------------------------------------------------------------------------------------------------------------------
# Purpose: Create Resource Groups
# Copyright: Gerry Williams (https://automationadmin.com)
# License: MIT License (https://opensource.org/licenses/mit)

# vscode Region expansion keyboard shortcuts
# Ctrl+Shift+[    Fold (collapse) region  editor.fold
# Ctrl+Shift+]    Unfold (uncollapse) region  editor.unfold
# Ctrl+K Ctrl+[   Fold (collapse) all subregions  editor.foldRecursively
# Ctrl+K Ctrl+]   Unfold (uncollapse) all subregions  editor.unfoldRecursively
# Ctrl+K Ctrl+0   Fold (collapse) all regions editor.foldAll
# Ctrl+K Ctrl+J   Unfold (uncollapse) all regions
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
#region Providers
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  
  backend "azurerm" {
    resource_group_name  = "tx-storage-rg"
    storage_account_name = "automationadminstorage"
    container_name       = "tfstate"
    key                  = "prodtfstate"
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

# ---------------------------------------------------------------------------------------------------------------------
#endregion Providers
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
#region Locals
# ---------------------------------------------------------------------------------------------------------------------


locals {
  sbx_tags = {
    Owner      = "Automation Admin"
    CostCenter = "100"
    EntAppname = "Automation Admin Terraform POC"
    Appenv     = var.env_stage
    Apppoc     = "gerry@automationadmin.com"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
#endregion Locals
# ---------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------
#region Resources
# ---------------------------------------------------------------------------------------------------------------------

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

# ---------------------------------------------------------------------------------------------------------------------
#endregion Resources
# ---------------------------------------------------------------------------------------------------------------------
