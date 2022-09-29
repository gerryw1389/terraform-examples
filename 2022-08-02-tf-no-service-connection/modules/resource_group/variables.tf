
variable "resource_group_name" {
  description = "(Required) Name of the Azure Resource Group."
  type        = string
}

variable "location" {
  description = "(Required) Location where the Vnet resides. Example: WestUS"
  type        = string
}

variable "tags" {
  description = "(Required) Tags of the RG to be created"
}
