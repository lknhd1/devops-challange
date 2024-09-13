output "app_service_url" {
  value = azurerm_linux_web_app.main.default_hostname
}

# Cosmos DB Account Connection Strings output
output "cosmosdb_mongo_connection_string" {
  value     = azurerm_cosmosdb_account.main.primary_mongodb_connection_string
  sensitive = true
}
