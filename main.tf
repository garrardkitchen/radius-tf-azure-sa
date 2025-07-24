# Variables

variable "context" {
  description = "This variable contains Radius recipe context."
  type = any
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "UKSouth"
}

# Configure the Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.114.0"
    }
  }
}

# Configure the Microsoft Azure Provider
# provider "azurerm" {
#   features {}
#   # use_cli = false
# }

# Create a resource group
resource "azurerm_resource_group" "this" {
  name     = var.context.azure.resourceGroup.name
  location = var.location
}

# Create a storage account
resource "azurerm_storage_account" "this" {
  name                     = var.context.resource.name
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.context.environment.name
  }
}

# Output the storage account name
output "storage_account_name" {
  value = azurerm_storage_account.this.name
}

# Output the resource group name
output "resource_group_name" {
  value = azurerm_resource_group.this.name
}

# Output the storage account resource ID
output "storage_account_resource_id" {
  value = azurerm_storage_account.this.id
}

# Output the storage account primary access key
output "storage_account_primary_access_key" {
  value     = azurerm_storage_account.this.primary_access_key
  sensitive = true
}

# Output the storage account connection string
output "storage_account_connection_string" {
  value     = azurerm_storage_account.this.primary_connection_string
  sensitive = true
}


output "result" {
  value = {
    values = {
      resource_group_name = azurerm_resource_group.this.name
      storage_account_name = azurerm_storage_account.this.name
      tag = var.context.environment.name
    }
    resources = [
      "/planes/azure/azurecloud/subscriptions/${var.context.azure.subscriptionId}/resourceGroups/${azurerm_resource_group.this.name}/providers/Microsoft.Storage/storageAccounts/${azurerm_storage_account.this.name}"
    ]
  }
}

