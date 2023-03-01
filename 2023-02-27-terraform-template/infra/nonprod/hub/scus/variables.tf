### Authentication Vars

variable "tenant_id" {
  description = "(Required) The Azure Active Directory `Tenant ID` property used for terraform authentication."
  type        = string
}

variable "client_id" {
  description = "(Required) The terraform Enterprise Application (Service Principal) `Application ID` property used for terraform authentication. This is the same as the `Client ID` of the associated App Registration in Azure AD."
  type        = string
}

variable "client_secret" {
  description = "(Required) The terraform App Registration (Service Principal) `Client secret` property used for terraform authentication."
  type        = string
}

variable "subscription_id" {
  description = "(Required) The Azure `Subscription ID` property used for terraform authentication. This is used to setup the default and the spoke-subscription provider block `azurerm` ."
  type        = string
}

variable "hub_subscription_id" {
  description = "(Required) The Azure `Subscription ID` property used for terraform authentication. This is used to setup the hub-subscription provider block `azurerm`."
  type        = string
}

### Naming/Tagging Vars

variable "requested_for" {
  description = "(Required) Azure Devops Automatic Variable used for tagging resources."
  type        = string
}

variable "requested_for_email" {
  description = "(Required) Azure Devops Automatic Variable used for tagging resources."
  type        = string
}

variable "pipeline" {
  description = "(Required) Azure Devops Automatic Variable used for tagging resources."
  type        = string
}

variable "env_stage_abbr" {
  description = "(Optional) The environment stage abbreviation. Example: nonprd or prd."
  type        = string
  default     = "nonprd"
}

variable "region_abbr" {
  description = "(Optional) The region abbreviation. Example: scus."
  type        = string
  default     = "scus"
}

variable "sub_abbr" {
  description = "(Optional) Shortcode for the Subscription Name. Used for naming resources."
  type        = string
  default     = "hub"
}

variable "region" {
  description = "(Optional) The Azure Region."
  type        = string
  default     = "southcentralus"
}

variable "tags_app_env" {
  description = "(Optional) The App Environment. Example: dev, qa, prod."
  type        = string
  default     = "dev"
}

variable "tags_nw_layer" {
  description = "(Optional) The App Network Layer. Example: internal or external."
  type        = string
  default     = "internal"
}

variable "tags_app_oc" {
  description = "(Optional) The App Contact, should be the name of a Distribution List. Example: me@domain.com."
  type        = string
  default     = "me@domain.com"
}

variable "tags_cc" {
  description = "(Optional) The Cost Center for all resources deployed. Example: 001."
  type        = string
  default     = "001"
}

variable "tags_project" {
  description = "(Optional) The Project name. Example: my-project."
  type        = string
  default     = "AutomationAdmin"
}

variable "tags_ent_app_name" {
  description = "(Optional) The Enterprise Application name. Example: my-app1, my-app2."
  type        = string
  default     = "AutomationAdmin"
}
