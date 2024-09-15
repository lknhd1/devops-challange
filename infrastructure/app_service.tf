# Define the user-assigned managed identity for app service
resource "azurerm_user_assigned_identity" "main" {
  name                = "${var.app_name}-managed-identity"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.region
}

# Define the service plan for app service
resource "azurerm_service_plan" "main" {
  name                = "${var.app_name}-asp"
  location            = var.region
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Linux"
  sku_name            = var.service_sku_name
}

# Define app service
resource "azurerm_linux_web_app" "main" {
  name                      = "${var.app_name}-app"
  location                  = var.region
  resource_group_name       = azurerm_resource_group.main.name
  service_plan_id           = azurerm_service_plan.main.id
  virtual_network_subnet_id = azurerm_subnet.app.id

  site_config {
    application_stack {
      node_version = "18-lts"
    }

    app_command_line = "node app.js"
  }

  app_settings = {
    "LISTEN_PORT" = "8080"
    "MONGODB_URI" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.main.vault_uri}secrets/mongodb-uri/)"
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.main.id
    ]
  }

  logs {
    detailed_error_messages = true
    failed_request_tracing  = true

    http_logs {
      file_system {
        retention_in_days = 2
        retention_in_mb   = 35
      }
    }
  }

  key_vault_reference_identity_id = azurerm_user_assigned_identity.main.id

  depends_on = [
    azurerm_key_vault_access_policy.allow_app_service,
  ]
}
