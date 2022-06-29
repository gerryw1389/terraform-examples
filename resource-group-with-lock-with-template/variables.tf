
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
  description = "(Optional) The region abbreviation. Example: wus"
  type        = string
  default     = "tx"
}
