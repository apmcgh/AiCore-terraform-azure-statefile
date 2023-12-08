variable "region" {
  description = "Region we operate in"
  type        = string
  default     = "UK South"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "TFLearning"
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group, e.g. ProjectRG"
  type        = string
  default     = ""
}

variable "service_principal_name" {
  description = "Name of the Azure Service Principal, e.g. ProjectSP"
  type        = string
  default     = ""
}

variable "storage_account_name" {
  description = "Name of the Azure Storage Account, e.g. ProjectSFS"
  type        = string
  default     = ""
}

variable "container_names" {
  description = "List of names for containers in the storage account, e.g. ProjectSFC"
  type        = list(string)
  default     = []
}

variable "key_vault_name" {
  description = "Name of the Azure Key Vault, e.g. ProjectKV"
  type        = string
  default     = ""
}
