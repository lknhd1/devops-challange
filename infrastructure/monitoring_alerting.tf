resource "azurerm_monitor_action_group" "main" {
  name                = "email"
  resource_group_name = azurerm_resource_group.main.name
  short_name          = "email"

  email_receiver {
    name          = "lukman_alert"
    email_address = "lknhd19-alerts@googlegroups.com"
  }
}

resource "azurerm_monitor_metric_alert" "cpu" {
  name                = "cpu-usage-alert"
  resource_group_name = azurerm_resource_group.main.name
  scopes              = [azurerm_linux_web_app.main.id]
  severity            = 3

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "CpuTime"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 50
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}
