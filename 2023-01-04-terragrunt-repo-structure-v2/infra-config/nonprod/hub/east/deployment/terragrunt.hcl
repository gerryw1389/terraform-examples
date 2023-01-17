
# Include all settings from the nonprod terragrunt.hcl file
include "nonprod_config" {
  path = find_in_parent_folders("all-nonprod.hcl")
}