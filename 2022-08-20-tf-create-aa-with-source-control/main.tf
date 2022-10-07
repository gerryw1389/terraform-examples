
# ---------------------------------------------------------------------------------------------------------------------
# Purpose: Deploy an Automation Account
# Copyright: AutomationAdmin.com

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
#region Data
# ---------------------------------------------------------------------------------------------------------------------
data "azurerm_subscription" "primary" {
}

# ---------------------------------------------------------------------------------------------------------------------
#endregion Data
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
#region Resources
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_resource_group" "aa_rg" {
  name     = "aa-${var.env_stage_abbr}-${var.region_abbr}-aa-rg"
  location = var.region
  tags     = local.sbx_tags
}

resource "azurerm_automation_account" "aa" {
  name                = "aa-${var.env_stage_abbr}-${var.region_abbr}-aa"
  location            = var.region
  resource_group_name = azurerm_resource_group.aa_rg.name
  sku_name            = "Basic"
  
  identity {
     type = "SystemAssigned"
  }
  
  tags                = local.sbx_tags
}

resource "azurerm_role_assignment" "example" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Reader"
  principal_id         = azurerm_automation_account.aa.identity[0].principal_id
}

# ---------------------------------------------------------------------------------------------------------------------
#endregion Resources
# ---------------------------------------------------------------------------------------------------------------------
