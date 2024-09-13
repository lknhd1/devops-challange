terraform {
  required_version = ">= 1.9.0, < 1.10.0"

  backend "azurerm" {
    resource_group_name  = "DefaultResourceGroup-SEA"
    storage_account_name = "devopschallange"
    container_name       = "tfstate"
    key                  = "guestbook.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.116.0, < 4.0.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "06e94e0f-88b0-4722-825c-60e43742a52a"
  tenant_id       = "ad1720fb-d28d-4824-9560-36d5e5b82fc1"

  disable_terraform_partner_id = true

  features {}
}

data "azurerm_client_config" "current" {}
