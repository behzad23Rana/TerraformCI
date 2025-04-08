variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  default     = "665ef1b3-b23d-4af9-9316-5155d0637cbd"

}

variable "enable_locks" {
  description = "Enable locks for the resource group"
  type        = bool
  default     = false
}

variable "index" {
  description = "When we need to create a seqeunce of the rg we use this variable to add the sequence at the end"
  type        = number
  default     = 2
}

variable "counter" {
  description = "A counter variable for iteration or indexing purposes"
  type        = number
  default     = 1
}

variable "env" {
  description = "Environment name"
  type        = string
  default     = "dev"

}

variable "region" {
  description = "Azure region"
  type        = string
  default     = "canadacentral"

}

variable "location" {
  description = "Azure location"
  type        = string
  default     = "canadacentral"

}

variable "storage_accounts" {
  description = "Map of storage accounts to create"
  type = map(object({
    name                     = string
    location                 = string
    account_tier             = string
    account_replication_type = string
  }))
}

variable "sa_resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "my-resource-group"

}

variable "aks_resource_group_name" {
  description = "Name of the AKS resource group"
  type        = string
  default     = "my-aks-resource-group"

}
