# Generate providers.tf at run time.
generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = file("${get_repo_root()}/infra-config/generate/providers.tf")
}

# Generate common_data_lookup.tf at run time.
generate "common_data_lookup" {
  path      = "common_data_lookup.tf"
  if_exists = "overwrite_terragrunt"
  contents  = file("${get_repo_root()}/infra-config/generate/common_data_lookup.tf")
}