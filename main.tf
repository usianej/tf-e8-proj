terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.7.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstate19531"
    container_name       = "tfstate2"
    key                  = "terraform.tfstate"
    use_oidc             = true
  }

}

provider "azurerm" {
  features {}
  use_oidc = true
}

resource "azurerm_resource_group" "state-demo-secure" {
  name     = "champions-group"
  location = "eastus"
}
resource "azurerm_resource_group" "state-test-main" {
  name     = "test-main"
  location = "eastus"
}