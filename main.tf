terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.38.1"
    }
  }
}

provider "azurerm" {
  features {
  }
  subscription_id = "caad2972-ffea-4fb3-a64f-09fe1152f36d"
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_resource_group" "arg" {
  name = "${var.resource_group_name}${random_integer.ri.result}"
  // name    = var.resource_group_name
  // location = "polandcentral"
  location = var.resource_group_location
}

resource "azurerm_service_plan" "asp" {
  //name                = "AzureTaskServicePlan${random_integer.ri.result}"
  name                = "${var.app_service_plan_name}${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.arg.name
  location            = azurerm_resource_group.arg.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "alwa" {
  // name                = "AzureTaskWebApp${random_integer.ri.result}"
  name                = "${var.app_service_name}${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.arg.name
  location            = azurerm_service_plan.asp.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
    always_on = false
  }
  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.server.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.database.name};User ID=${azurerm_mssql_server.server.administrator_login};Password=${azurerm_mssql_server.server.administrator_login_password};Trusted_Connection=False; MultipleActiveResultSets=True;"
  }
}

resource "azurerm_app_service_source_control" "aassc" {
  app_id = azurerm_linux_web_app.alwa.id
  // repo_url = "https://github.com/BorislavGenov85/AzureTask"
  repo_url = var.repo_URL
  branch   = "main"
}

resource "azurerm_mssql_server" "server" {
  // name                         = "task-board-sql${random_integer.ri.result}"
  name                = "${var.sql_server_name}${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.arg.name
  location            = azurerm_resource_group.arg.location
  version             = "12.0"
  // administrator_login          = "4dm1n157r470r"
  administrator_login = var.sql_admin_login
  // administrator_login_password = "4-v3ry-53cr37-p455w0rd"
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_mssql_database" "database" {
  // name                 = "TaskBoardDB${random_integer.ri.result}"
  name                 = "${var.sql_database_name}${random_integer.ri.result}"
  server_id            = azurerm_mssql_server.server.id
  collation            = "SQL_Latin1_General_CP1_CI_AS"
  license_type         = "LicenseIncluded"
  max_size_gb          = 2
  sku_name             = "S0"
  zone_redundant       = false
  storage_account_type = "Local"
}

resource "azurerm_mssql_firewall_rule" "firewall" {
  // name             = "FirewallRule1"
  name             = var.firewall_rule_name
  server_id        = azurerm_mssql_server.server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
