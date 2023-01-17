
# Include all settings from the nonprod terragrunt.hcl file
include "prod_config" {
  path = find_in_parent_folders("all-prod.hcl")
}