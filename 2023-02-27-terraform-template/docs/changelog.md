
# Changelog

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased](https://my-project@dev.azure.com/my-project/_git/my-repo/template/branchCompare?baseVersion=GBmain&targetVersion=GTv0.0.1&_a=commits)

### Added

### Changed
- Initial version of the repo has been updated to include `./yaml` and `./infra`
- Each `./infra` sub dir has `./nonprod` and `./prod`, each subscription, and then `./eus` and `./scus` subfolders
- Each `backend.tf` has state files with pattern `$subscription/$region/template.tfstate`.
- Data Sources has `nonprod_eus.tf`, `prod_eus.tf`, `nonprod_scus.tf`, and `prod_scus.tf` split between environment-region.
- Data sources has a `common_data_lookup.tf` with an examlpe module call commented out that developers can use if needed.
- The file `terraform.tfvars` is placed to follow our variables standard.
- Any changes from here need a version bump with an explanation in this file.

### Removed

### Fixed

## [v0.0.1](https://dev.azure.com/my-project/_git/my-repo/template/branchCompare?baseVersion=GBmain&targetVersion=GTv0.0.1&_a=commits)

### Added

- Initialized repo

### Changed

### Removed

### Fixed
