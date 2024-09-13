# Cosmos DB Account for MongoDB API with version 7
resource "azurerm_cosmosdb_account" "main" {
  name                = "${var.app_name}-cosmosdb-mongo"
  location            = var.region
  resource_group_name = azurerm_resource_group.main.name
  offer_type          = "Standard"
  kind                = "MongoDB"

  capabilities {
    name = "EnableMongo"
  }

  # Set MongoDB version 4.2
  # Can't use version 7, issue: https://github.com/hashicorp/terraform-provider-azurerm/issues/25889
  mongo_server_version = "4.2"

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = azurerm_resource_group.main.location
    failover_priority = 0
  }

  # Enable VNET access and disable access from internet
  public_network_access_enabled     = false
  is_virtual_network_filter_enabled = true

  virtual_network_rule {
    id = azurerm_subnet.app.id
  }
}

# Define a MongoDB Database in Cosmos DB
resource "azurerm_cosmosdb_mongo_database" "main" {
  name                = var.app_name
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.main.name
}

# Define a MongoDB Collection in Cosmos DB
resource "azurerm_cosmosdb_mongo_collection" "main" {
  name                = var.app_name
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.main.name
  database_name       = azurerm_cosmosdb_mongo_database.main.name

  index {
    keys   = ["_id"]
    unique = true
  }
}

resource "azurerm_key_vault_secret" "cosmosdb_mongo_connection_string" {
  name         = "mongodb-uri"
  value        = azurerm_cosmosdb_account.main.primary_mongodb_connection_string
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_key_vault_access_policy.allow_user]
}
