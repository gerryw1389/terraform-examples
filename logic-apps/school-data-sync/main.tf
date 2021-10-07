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

# Create a resource group
resource "azurerm_resource_group" "azurerg" {
   name                 = "logic-app--school-data-sync"
   location             = "southcentralus"

   tags                 = {
      environment = "Terraform Demo"
   }
}

# Deploy the ARM template to configure the workflow in the Logic App
data "template_file" "workflow" {
  template              = file("school-data-sync.json")
}

# Deploy the ARM template workflow
resource "azurerm_resource_group_template_deployment" "workflow" {
   name                 = "la_deployment_${formatdate("YYMMDDhhmmss", timestamp())}"
   resource_group_name  = azurerm_resource_group.azurerg.name
   
   deployment_mode      = "Complete"
   
   template_content     = data.template_file.workflow.template
}