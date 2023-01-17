
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
  source = "${find_in_parent_folders("infra")}"
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
  env_stage      = local.env_stage
  env_stage_abbr = local.env_stage_abbr
  region         = local.region
  region_abbr    = local.region_abbr

}

## Global terragrunt file placeholder

# Inject this provider configuration in all the modules that includes the root file without having to define them in the underlying modules
# This instructs Terragrunt to create the file provider.tf in the working directory (where Terragrunt calls terraform) before it calls any 
# of the Terraform commands (e.g plan, apply, validate, etc)
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.30.0"
    }
  }

  required_version = "1.2.0"
}

# default azurerm provider
provider "azurerm" {
  client_id                  = var.client_id
  client_secret              = var.client_secret
  subscription_id            = var.subscription_id
  tenant_id                  = var.tenant_id
  skip_provider_registration = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# hub-prod provider
provider "azurerm" {
  client_id                  = trimspace(var.client_id)
  client_secret              = trimspace(var.client_secret)
  tenant_id                  = trimspace(var.tenant_id)
  alias                      = "hub-prod"
  skip_provider_registration = true
  subscription_id            = trimspace(var.hub_prod_id)
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# hub-nonprod provider
provider "azurerm" {
  client_id                  = trimspace(var.client_id)
  client_secret              = trimspace(var.client_secret)
  tenant_id                  = trimspace(var.tenant_id)
  alias                      = "hub-nonprod"
  skip_provider_registration = true
  subscription_id            = trimspace(var.hub_nonprod_id)
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# spoke-prod provider
provider "azurerm" {
  client_id                  = trimspace(var.client_id)
  client_secret              = trimspace(var.client_secret)
  tenant_id                  = trimspace(var.tenant_id)
  alias                      = "spoke-prod"
  skip_provider_registration = true
  subscription_id            = trimspace(var.spoke_prod_id)
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# spoke-nonprod provider
provider "azurerm" {
  client_id                  = trimspace(var.client_id)
  client_secret              = trimspace(var.client_secret)
  tenant_id                  = trimspace(var.tenant_id)
  alias                      = "spoke-nonprod"
  skip_provider_registration = true
  subscription_id            = trimspace(var.spoke_nonprod_id)
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

EOF
}
