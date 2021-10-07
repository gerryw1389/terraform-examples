variable "ARM_SUBSCRIPTION_ID" {
  type = string
}

variable "ARM_CLIENT_ID" {
  type = string
}

variable "ARM_CLIENT_SECRET" {
  type = string
}

variable "ARM_TENANT_ID" {
  type = string
}

terraform {
  required_providers {
    azurerm = {
      source            = "hashicorp/azurerm"
      version           = "~>2.0"
    }
  }
}

# Configure the Microsoft Azure as a provider
provider "azurerm" {

    features {}
    
    subscription_id     = var.ARM_SUBSCRIPTION_ID
    client_id           = var.ARM_CLIENT_ID
    client_secret       = var.ARM_CLIENT_SECRET
    tenant_id           = var.ARM_TENANT_ID
}

data "template_file" "workflow" {
  template              = file("email_filter.json")
}

resource "azurerm_resource_group_template_deployment" "workflow" {
  
   name                 = "la_deployment_${formatdate("YYYY-MM-DD-hh-mm-ss", timestamp())}"
   resource_group_name  = "email-filter-la"
   
   deployment_mode      = "Incremental"
   
   template_content     = data.template_file.workflow.template
}