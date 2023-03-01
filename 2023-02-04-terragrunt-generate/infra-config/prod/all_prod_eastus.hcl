
######################################################################
### Step 0 - Ensure we are running correct binary versions...
######################################################################

# https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#terraform_version_constraint
terraform_version_constraint = "= 1.2.0"

# https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#terragrunt_version_constraint
terragrunt_version_constraint = "= v0.42.7"

######################################################################
### Step 1 - Import locals from file system above into our own locals that we will pass to Terraform
######################################################################

locals {

  terragrunt_generated = read_terragrunt_config(find_in_parent_folders("terragrunt_generated.hcl"))
  
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

######################################################################
### Step 2 - Generate static files at run time for us to use with our Terraform config - common_data_lookup.tf, backend.tf, providers.tf
######################################################################

# https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#generate
generate "locals_prod_eus" {
  path      = "locals_prod_eus.tf"
  if_exists = "overwrite_terragrunt"
  contents  = file("${get_repo_root()}/infra-config/generate/prod_eus.tf")
}
generate = local.terragrunt_generated.generate

# https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#remote_state
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

######################################################################
### Step 3 - Most important step! Call Terraform files by passing in our locals from above.
######################################################################

# https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#terraform
terraform {
  source = "${find_in_parent_folders("examples")}//nonprod"


  before_hook "windows_echo_starting_plan" {
    commands = get_platform() == "windows" ? ["plan"] : []
    execute  = ["echo", "========= [Windows] Subscription To Run A Plan Against... ========="]
  }

  before_hook "windows_echo_starting_plan" {
    commands = get_platform() == "windows" ? ["plan"] : []
    execute  = ["powershell", "-c", "Write-Output $env:TF_VAR_sub_abbr"]
  }

  before_hook "windows_echo_starting_plan_2" {
    commands = get_platform() == "windows" ? ["plan"] : []
    execute  = ["echo", "========= Directory Contents: ========="]
  }

  before_hook "windows_echo_starting_plan_3" {
    commands = get_platform() == "windows" ? ["plan"] : []
    execute  = ["powershell", "-c", "Get-ChildItem"]
  }

  before_hook "windows_echo_starting_plan_4" {
    commands = get_platform() == "windows" ? ["plan"] : []
    execute  = ["echo", "======================================================"]
  }

  before_hook "linux_echo_starting_plan" {
    commands = get_platform() != "windows" ? ["plan"] : []
    execute  = ["echo", "========= [Linux] Subscription To Run A Plan Against... ========="]
  }

  before_hook "linux_echo_starting_plan_2" {
    commands = get_platform() != "windows" ? ["plan"] : []
    execute  = ["printenv", "TF_VAR_sub_abbr"]
  }

  before_hook "windows_echo_starting_plan_3" {
    commands = get_platform() != "windows" ? ["plan"] : []
    execute  = ["echo", "========= Directory Contents: ========="]
  }

  before_hook "windows_echo_starting_plan_4" {
    commands = get_platform() != "windows" ? ["plan"] : []
    execute  = ["ls", "-l"]
  }

  before_hook "linux_echo_starting_plan_5" {
    commands = get_platform() != "windows" ? ["plan"] : []
    execute  = ["echo", "======================================================"]
  }

  before_hook "echo_starting_apply" {
    commands = ["apply"]
    execute  = ["echo", "Starting apply..."]
  }

  error_hook "error_hook_1" {
    commands = ["apply", "plan"]
    execute  = ["echo", "Error Hook executed! You could run a script here if needed."]
    on_errors = [
      ".*",
    ]
  }

}

# These will always be passed as strings so set your variables.tf to the correct data type or else! You have been warned :)
# https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#inputs
inputs = {

  tenant_id           = local.tenant_id
  client_id           = local.client_id
  client_secret       = local.client_secret
  subscription_id     = local.subscription_id
  hub_subscription_id = local.hub_subscription_id

  requested_for       = local.requested_for
  requested_for_email = local.requested_for_email
  pipeline            = local.pipeline
  env_stage_abbr      = local.env_stage_abbr
  region_abbr         = local.region_abbr
  tags_app_env        = local.env_stage_abbr
  sub_abbr            = local.sub_abbr
  location            = local.region

}