terraform {
  required_version = ">= 1.5.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.25.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-dev-canadacentral-02"
    storage_account_name = "tfstate0080"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"

  }
}

provider "azurerm" {
  features {}
  # skip_provider_registration = true
  subscription_id = var.subscription_id
  # subscription_id = "665ef1b3-b23d-4af9-9316-5155d0637cbd"
}

locals {
  enable_locks = var.enable_locks == "true" ? var.index : 0
}

resource "azurerm_resource_group" "rg" {
  count    = var.index
  name     = format("rg-%s-%s-%02d", var.env, var.region, count.index + var.counter)
  location = var.location
  tags = {
    environment = var.env
    region      = var.region
  }
}

resource "azurerm_management_lock" "rg_lock" {
  count      = local.enable_locks
  name       = "DenyDelete"
  scope      = azurerm_resource_group.rg[count.index].id
  lock_level = "CanNotDelete"
  notes      = "This lock is to prevent accidental deletion of the resource group."
  depends_on = [azurerm_resource_group.rg]
  lifecycle {
    ignore_changes = [name, lock_level, notes]
  }
}

resource "azurerm_storage_account" "sa" {
  for_each                 = var.storage_accounts
  name                     = each.value.name
  resource_group_name      = var.sa_resource_group_name
  location                 = each.value.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
  depends_on               = [azurerm_resource_group.rg]
}


resource "azurerm_kubernetes_cluster" "aks" {
  name                = "k8s-cluster-1"
  location            = var.location
  resource_group_name = var.aks_resource_group_name
  dns_prefix          = "k8s-cluster-1"
  sku_tier            = "Free"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "dev"
  }
  depends_on = [azurerm_resource_group.rg]

}

// rm terraform.tfstate* command to remove the state file