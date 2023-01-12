
terraform {

  backend "azurerm" {
    resource_group_name  = "tx-storage-rg"
    storage_account_name = "automationadminstorage"
    container_name       = "tfstate"
    key                  = "prodtfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.20.0"
    }
  }

  required_version = "1.2.0"
}

# default azurerm provider
provider "azurerm" {
  client_id                  = var.client_id
  client_secret              = var.client_secret
  subscription_id            = var.subscription_id
  tenant_id                  = var.tenant_id
  skip_provider_registration = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# hub-prod provider
provider "azurerm" {
  client_id                  = trimspace(var.client_id)
  client_secret              = trimspace(var.client_secret)
  tenant_id                  = trimspace(var.tenant_id)
  alias                      = "hub-prod"
  skip_provider_registration = true
  subscription_id            = trimspace(var.hub_prod_id)
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# hub-nonprod provider
provider "azurerm" {
  client_id                  = trimspace(var.client_id)
  client_secret              = trimspace(var.client_secret)
  tenant_id                  = trimspace(var.tenant_id)
  alias                      = "hub-nonprod"
  skip_provider_registration = true
  subscription_id            = trimspace(var.hub_nonprod_id)
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# spoke-prod provider
provider "azurerm" {
  client_id                  = trimspace(var.client_id)
  client_secret              = trimspace(var.client_secret)
  tenant_id                  = trimspace(var.tenant_id)
  alias                      = "spoke-prod"
  skip_provider_registration = true
  subscription_id            = trimspace(var.spoke_prod_id)
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# spoke-nonprod provider
provider "azurerm" {
  client_id                  = trimspace(var.client_id)
  client_secret              = trimspace(var.client_secret)
  tenant_id                  = trimspace(var.tenant_id)
  alias                      = "spoke-nonprod"
  skip_provider_registration = true
  subscription_id            = trimspace(var.spoke_nonprod_id)
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}