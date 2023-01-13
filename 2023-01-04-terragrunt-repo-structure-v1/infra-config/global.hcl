# Global variables used by all environments, subscriptions, and regions that will inherit downwards

locals {
  org_prefix = "aa"

  # Auth vars
  #access_key          = get_env("TF_VAR_ARM_ACCESS_KEY")
  subscription_id  = get_env("TF_VAR_ARM_SUBSCRIPTION_ID")
  tenant_id        = get_env("TF_VAR_ARM_TENANT_ID")
  client_id        = get_env("TF_VAR_ARM_CLIENT_ID")
  client_secret    = get_env("TF_VAR_ARM_CLIENT_SECRET")
  spoke_nonprod_id = get_env("TF_VAR_spoke_nonprod_id")
  spoke_prod_id    = get_env("TF_VAR_spoke_prod_id")
  hub_nonprod_id   = get_env("TF_VAR_hub_nonprod_id")
  hub_prod_id      = get_env("TF_VAR_hub_prod_id")

}
