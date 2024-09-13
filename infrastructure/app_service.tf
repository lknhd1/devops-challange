resource "azurerm_service_plan" "main" {
  name                = "${var.app_name}-asp"
  location            = var.region
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Linux"
  sku_name            = var.service_sku_name
}

# Define the user-assigned managed identity for app service
resource "azurerm_user_assigned_identity" "main" {
  name                = "${var.app_name}-managed-identity"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.region
}

# Define app service
resource "azurerm_linux_web_app" "main" {
  name                      = "${var.app_name}-app"
  location                  = var.region
  resource_group_name       = azurerm_resource_group.main.name
  service_plan_id           = azurerm_service_plan.main.id
  virtual_network_subnet_id = azurerm_subnet.app.id

  site_config {}

  app_settings = {
    "MONGODB_URI" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.main.vault_uri}secrets/mongodb-uri/)"
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.main.id
    ]
  }

  key_vault_reference_identity_id = azurerm_user_assigned_identity.main.id

  depends_on = [
    azurerm_key_vault_access_policy.allow_app_service,
  ]
}

# resource "azurerm_app_service_source_control" "main" {
#   app_id   = azurerm_linux_web_app.main.id
#   repo_url = var.repo_url
#   branch   = var.branch
# }
