
# Include all settings from the root terragrunt.hcl file
include "root_config" {
  path = find_in_parent_folders("root.hcl")
}

# Include all settings from the nonprod terragrunt.hcl file
include "nonprod_config" {
  path = find_in_parent_folders("all-nonprod.hcl")
}