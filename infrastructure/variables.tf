variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "region" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "eastasia"
}

variable "app_name" {
  description = "The name of the application"
  type        = string
  default     = "guestbook"
}

variable "service_sku_name" {
  description = "SKU name used by the service plan"
  type        = string
}
