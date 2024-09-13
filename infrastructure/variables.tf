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

variable "repo_url" {
  description = "Repository URL for the app service to deploy from"
  type        = string
}

variable "branch" {
  description = "Repository branch for the app service to deploy from"
  type        = string
}


variable "service_sku_name" {
  description = "SKU name used by the service plan"
  type        = string
}

variable "db_admin_username" {
  description = "Database admin username"
  type        = string
  default     = "mysqladmin"
}
