variable "resource_group_name" {
  description = "The Azure region where the resources will be created."
  type        = string
}

variable "resource_group_location" {
  description = "The Azure region where the resources will be created."
  type        = string
}

variable "app_service_plan_name" {
  description = "The name of the App Service Plan."
  type        = string
}

variable "app_service_name" {
  description = "The name of the Azure Linux Web App."
  type        = string
}

variable "sql_server_name" {
  description = "The name of the SQL Server."
  type        = string
}

variable "sql_database_name" {
  description = "The name of the SQL Database."
  type        = string
}

variable "sql_admin_login" {
  description = "The administrator login for the SQL Server."
  type        = string
}

variable "sql_admin_password" {
  description = "The administrator password for the SQL Server."
  type        = string
}

variable "firewall_rule_name" {
  description = "The name of the SQL Server firewall rule."
  type        = string
}

variable "repo_URL" {
  description = "value of the repository URL for the source control."
  type        = string
}