# Variables
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "UKSouth"
}

variable "storage_account_name" {
  description = "Name for the storage account"
  type        = string
}

variable "tag" {
  description = "Environment tag"
  type        = string
}

# Configure the Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  use_cli = false
}

# Create a resource group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# Create a storage account
resource "azurerm_storage_account" "main" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.tag
  }
}

# Output the storage account name
output "storage_account_name" {
  value = azurerm_storage_account.main.name
}

# Output the resource group name
output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

# Output the storage account resource ID
output "storage_account_resource_id" {
  value = azurerm_storage_account.main.id
}

# Output the storage account primary access key
output "storage_account_primary_access_key" {
  value     = azurerm_storage_account.main.primary_access_key
  sensitive = true
}

# Output the storage account connection string
output "storage_account_connection_string" {
  value     = azurerm_storage_account.main.primary_connection_string
  sensitive = true
}