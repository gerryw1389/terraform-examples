
# ---------------------------------------------------------------------------------------------------------------------
# Purpose: Deploy A Powershell7 FunctionApp
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
      source  = "hashicorp/azurerm"
      version = "3.0.0"
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
  aa_tags = {
    Owner       = "Automation Admin"
    CostCenter  = "100"
    Description = "Automation Admin Terraform POC"
    Environment = var.env_stage_abbr
    App_Contact = "gerry@automationadmin.com"
  }
}

###################### < /Locals > ######################
###################### < Resources > ######################

resource "azurerm_resource_group" "fa_rg" {
  name     = "aa-${var.env_stage_abbr}-${var.region_abbr}-fa"
  location = var.region
  tags     = local.aa_tags
}

resource "azurerm_storage_account" "fa_sa" {
  name                     = "aa${var.env_stage_abbr}${var.region_abbr}sa"
  resource_group_name      = azurerm_resource_group.fa_rg.name
  location                 = azurerm_resource_group.fa_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.aa_tags
}

resource "azurerm_service_plan" "fa_plan" {
  name                = "aa-${var.env_stage_abbr}-${var.region_abbr}-fa-plan"
  resource_group_name = azurerm_resource_group.fa_rg.name
  location            = azurerm_resource_group.fa_rg.location
  os_type             = "Windows"
  sku_name            = "Y1"
  tags                = local.aa_tags
}

resource "azurerm_windows_function_app" "fa" {
  name                        = "aa-${var.env_stage_abbr}-${var.region_abbr}-fa"
  location                    = azurerm_resource_group.fa_rg.location
  resource_group_name         = azurerm_resource_group.fa_rg.name
  service_plan_id             = azurerm_service_plan.fa_plan.id
  storage_account_name        = azurerm_storage_account.fa_sa.name
  storage_account_access_key  = azurerm_storage_account.fa_sa.primary_access_key
  functions_extension_version = "~4"
  https_only                  = true
  tags                        = local.aa_tags

  auth_settings {
    enabled                       = false
    runtime_version               = "~1"
    unauthenticated_client_action = "AllowAnonymous"
  }

  identity {
    type = "SystemAssigned"
  }

  site_config {
    minimum_tls_version = "1.2"
    application_stack {
      powershell_core_version = "7"
    }
  }
}

resource "azurerm_app_service_source_control" "fa_sc" {
  app_id                 = azurerm_windows_function_app.fa.id
  repo_url               = "https://github.com/gerryw1389/PS-FindNextCIDRRange"
  branch                 = "main"
  use_manual_integration = true
}

###################### < /Resources > ######################
