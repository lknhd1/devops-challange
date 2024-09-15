# Configure logs analytics workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.app_name}-law"
  location            = var.region
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Define Diagnostic Settings for the Web App to send logs to Log Analytics Workspace
resource "azurerm_monitor_diagnostic_setting" "main" {
  name                       = "${var.app_name}-diagnostic-setting"
  target_resource_id         = azurerm_linux_web_app.main.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "AppServiceHTTPLogs"
  }

  enabled_log {
    category = "AppServiceAppLogs"
  }

  metric {
    category = "AllMetrics"
  }

  depends_on = [azurerm_linux_web_app.main]
}
