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


# Resource Group
resource "azurerm_resource_group" "main_rg" {
  name     = "main-resource-group"
  location = "eastus"
}

# Virtual Network
resource "azurerm_virtual_network" "main_vnet" {
  name                = "main-vnet"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
  address_space       = ["10.0.0.0/16"]
}

# Subnet
resource "azurerm_subnet" "main_subnet" {
  name                 = "main-subnet"
  resource_group_name  = azurerm_resource_group.main_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Security Group
resource "azurerm_network_security_group" "main_nsg" {
  name                = "main-nsg"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name

  security_rule {
    name                       = "Allow_HTTPS"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Deny_All_Inbound"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate NSG with Subnet
resource "azurerm_subnet_network_security_group_association" "main_subnet_nsg" {
  subnet_id                 = azurerm_subnet.main_subnet.id
  network_security_group_id = azurerm_network_security_group.main_nsg.id
}

# Storage Account (General-purpose v2 storage account)
resource "azurerm_storage_account" "main_storage" {
  name                     = "mainstorageacct"
  resource_group_name      = azurerm_resource_group.main_rg.name
  location                 = azurerm_resource_group.main_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Example Resource Groups
resource "azurerm_resource_group" "champions_group" {
  name     = "champions-group"
  location = "eastus"
}

resource "azurerm_resource_group" "test_main_group" {
  name     = "test-main"
  location = "eastus"
}