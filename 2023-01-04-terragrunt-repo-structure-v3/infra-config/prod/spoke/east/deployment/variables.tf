# See https://www.terraform.io/language/modules/develop/structure where they recommend to follow the Consul module => https://github.com/hashicorp/terraform-azurerm-consul/blob/master/vars.tf

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "tenant_id" {
  description = "(Required) Service Principal AD Tenant ID - Azure AD for terraform authentication."
  type        = string
}

variable "subscription_id" {
  description = "(Required) Azure Subscription Id used to connect to AzureRM provider."
  type        = string
}

variable "client_id" {
  description = "(Required) Service Principal App ID - Azure AD for terraform authentication."
  type        = string
}

variable "client_secret" {
  description = "(Required) Service Principal Client Secret - Azure AD for terraform authentication."
  type        = string
}

variable "hub_prod_id" {
  description = "(Required) Azure Subscription Id used to connect to AzureRM provider."
  type        = string
}

variable "hub_nonprod_id" {
  description = "(Required) Azure Subscription Id used to connect to AzureRM provider."
  type        = string
}

variable "spoke_prod_id" {
  description = "(Required) Azure Subscription Id used to connect to AzureRM provider."
  type        = string
}

variable "spoke_nonprod_id" {
  description = "(Required) Azure Subscription Id used to connect to AzureRM provider."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "environment" {
  description = "(Optional) The name of the environment. Example: nonprod or prod."
  type        = string
  default     = "prod"
}

variable "env_stage" {
  description = "(Optional) The environment stage. Example: development, qa, or production."
  type        = string
  default     = "development"
}

variable "env_stage_abbr" {
  description = "(Optional) The environment stage abbreviation. Example: dev, qa, or prd."
  type        = string
  default     = "dev"
}

variable "region" {
  description = "(Optional) The name of the region. Example: southcentralus."
  type        = string
  default     = "southcentralus"
}

variable "region_abbr" {
  description = "(Optional) The region abbreviation. Example: wus, eus, scus"
  type        = string
  default     = "scus"
}

variable "sub_abbr" {
  description = "(Optional) The subscription abbreviation. Example: hub or spk"
  type        = string
  default     = "spk"
}