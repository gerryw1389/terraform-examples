
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
      source  = "hashicorp/azurerm"
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
  aa_tags = {
    Owner      = "Automation Admin"
    CostCenter = "100"
    EntAppname = "Automation Admin Terraform POC"
    Appenv     = var.env_stage
    Apppoc     = "gerry@automationadmin.com"
  }
}

###################### < /Locals > ######################
###################### < Resources > ######################

module "rg" {
  source              = "git::https://github.com/gerryw1389/terraform-modules.git//resource-group?ref=v1.0.0"
  resource_group_name = "aa-${var.env_stage_abbr}-${var.region_abbr}-functionapp"
  location            = var.region
  tags                = local.aa_tags
}

resource "azurerm_storage_account" "fa_sa" {
  name                     = "aa${var.env_stage_abbr}${var.region_abbr}sa"
  resource_group_name      = module.rg.name
  location                 = module.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.aa_tags
}

resource "azurerm_service_plan" "fa_plan" {
  name                = "aa-${var.env_stage_abbr}-${var.region_abbr}-fa-plan"
  resource_group_name = module.rg.name
  location            = module.rg.location
  os_type             = "Windows"
  sku_name            = "Y1"
  tags                = local.aa_tags
}

resource "azurerm_windows_function_app" "fa" {
  name                        = "aa-${var.env_stage_abbr}-${var.region_abbr}-fa"
  location                    = module.rg.location
  resource_group_name         = module.rg.name
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
