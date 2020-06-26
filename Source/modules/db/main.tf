/**
* # Module Properties
*
*
* Example usage and Testing
*
* ```hcl
* module "db" {
* source         = "../modules/db"
* DB_RG_NAME = azurerm_resource_group.db.name
* NAME           = var.NAME
* LOCATION       = var.LOCATION
* }
* ```
*/

resource "azurerm_resource_group" "tw_rg" {
  name		      = "tw_rg"
  location	      = var.LOCATION
}

resource "azurerm_sql_server" "tw_sql_svr" {
  name                = "tw_sql_svr"
  location            = var.LOCATION
  resource_group_name = azurerm_resource_group.tw_rg.name
}

resource "azurerm_storage_account" "tailwinds_stor" "tw_stor" {
  name                = "tw_stor"
  resource_group_name = azurerm_resource_group.tw_rg.name
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
  location            = var.LOCATION
  account_tier	      = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_sql_database"  "tw_sql_db" {
  name		      = "tw_sql_db"
  resource_group_name = azurerm_resource_group.tw_rg.name
  location            = var.LOCATION
  server_name         = azurerm_sql_server.tw_sql_svr.name
}

resource "azurerm_container_group" "tw_container" {
  name                = "tw_container"
  resource_group_name = azurerm_resource_group.tw_rg.name
  location            = var.LOCATION
  ip_address_type     = "public"
  dns_name_label      = "tw_dns_label"
  os_type 	      = "linux"
}

data "docker_registry_image" "tw_registry_image" {
  name = "retaildevcrew/imdb-import"
}

resource "docker_image" "tw_image" {
  name          = data.docker_registry_image.tw_registry_image.name
  pull_triggers = ["${data.docker_registry_image.tw_registry_image.sha256_digest}"]
}

resource "docker_container" "imdb-import" {
  name    = "imdb-importer${each.key}"
  image   = docker_image.imdb-import.name
  command = ["${azurerm_cosmosdb_account.cosmosdb.name}", "${azurerm_cosmosdb_account.cosmosdb.primary_master_key}", "imdb-${each.key}", "movies"]
  rm      = true
}
