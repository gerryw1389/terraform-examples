
locals {

  # Automatically load environment-level variables from files in parent folders
  global_vars       = read_terragrunt_config(find_in_parent_folders("global.hcl"))
  env_vars          = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  subscription_vars = read_terragrunt_config(find_in_parent_folders("sub.hcl"))
  region_vars       = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract out common variables for reuse
  org_prefix       = local.global_vars.locals.org_prefix
  subscription_id  = local.global_vars.locals.subscription_id
  tenant_id        = local.global_vars.locals.tenant_id
  client_id        = local.global_vars.locals.client_id
  client_secret    = local.global_vars.locals.client_secret
  spoke_nonprod_id = local.global_vars.locals.spoke_nonprod_id
  spoke_prod_id    = local.global_vars.locals.spoke_prod_id
  hub_nonprod_id   = local.global_vars.locals.hub_nonprod_id
  hub_prod_id      = local.global_vars.locals.hub_prod_id

  environment    = local.env_vars.locals.environment
  env_stage      = local.env_vars.locals.env_stage
  env_stage_abbr = local.env_vars.locals.env_stage_abbr

  sub_abbr = local.subscription_vars.locals.sub_abbr

  region      = local.region_vars.locals.region
  region_abbr = local.region_vars.locals.region_abbr

  resource_group_name = "${local.org_prefix}-${local.env_stage_abbr}-${local.region_abbr}-${local.sub_abbr}-rg-test"

}

# Global remote state
remote_state {
  backend = "azurerm"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    resource_group_name  = "tx-storage-rg"
    storage_account_name = "automationadminstorage"
    container_name       = "terragrunt"
    key                  = "${path_relative_to_include()}/terraform.tfstate"
    #access_key = local.access_key
  }
}


terraform {
  source = "${find_in_parent_folders("infra")}//prod"
}

inputs = {

  # required
  tenant_id        = local.tenant_id
  subscription_id  = local.subscription_id
  client_id        = local.client_id
  client_secret    = local.client_secret
  spoke_nonprod_id = local.spoke_nonprod_id
  spoke_prod_id    = local.spoke_prod_id
  hub_nonprod_id   = local.hub_nonprod_id
  hub_prod_id      = local.hub_prod_id

  # Optional
  environment    = local.env_stage
  env_stage      = local.env_stage
  env_stage_abbr = local.env_stage_abbr
  region         = local.region
  region_abbr    = local.region_abbr
  sub_abbr       = local.sub_abbr

}
# Include all settings from the root terragrunt.hcl file
include "root_config" {
  path = find_in_parent_folders("root.hcl")
}