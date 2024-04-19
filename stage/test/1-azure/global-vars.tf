variable "client_id" {
  description = "client id azure rm"
  type        = string
  default = "bf9cf562-a4e8-47ce-a1e4-efb9ac9223db"
}

variable "tenant_id" {
  description = "tenant id azure rm"
  type        = string
  default = "b8fd94a7-4d48-458b-b80a-273abc64f531"
}

variable "subscription_id" {
  description = "subscription id azure rm"
  type        = string
  default = "311159a2-3ede-41c1-a42e-3aa4ca99f856"
}

variable "resource_group_name" {
  description = "name of the resource group azure rm"
  type        = string
  default = "aks1"
}

variable "aks_cluster_name" {
  description = "name of the aks cluster"
  type        = string
  default = "aks1"
}

variable "vault_name" {
  description = "name of vault"
  type        = string
  default     = "jr-aks1"
}