resource "azurerm_virtual_network" "main" {
  name                = "${var.app_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.region
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "db" {
  name                 = "${var.app_name}-db-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.AzureCosmosDB"]
}

resource "azurerm_subnet" "vm" {
  name                 = "${var.app_name}-vm-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.KeyVault"]
}

resource "azurerm_subnet" "app" {
  name                 = "${var.app_name}-app-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.3.0/24"]
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.AzureCosmosDB"]

  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }
}


resource "azurerm_network_security_group" "main" {
  name                = "${var.app_name}-nsg"
  location            = var.region
  resource_group_name = azurerm_resource_group.main.name
}

# resource "azurerm_network_security_rule" "allow_mysql" {
#   resource_group_name         = azurerm_resource_group.main.name
#   name                        = "allow-mysql"
#   priority                    = 100
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "3306"
#   source_address_prefix       = "10.0.1.0/24"
#   destination_address_prefix  = "*"
#   network_security_group_name = azurerm_network_security_group.main.name
# }
