
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

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "environment" {
  description = "(Optional) The environment stage. Example: prod, qa, dev."
  type        = string
  default     = "prod"
}

variable "region" {
  description = "(Optional) The name of the region. Example: southcentralus."
  type        = string
  default     = "southcentralus"

  validation {
    condition     = var.region == "westus" || var.region == "eastus" || var.region == "southcentralus"
    error_message = "The region must be westus, eastus, or southcentralus."
  }
}

variable "region_abbr" {
  description = "(Optional) The region abbreviation. Example: wus, eus, scus"
  type        = string
  default     = "scus"
}