output "resource_group_name" {
  value = data.azurerm_resource_group.main.name
}

output "openai_endpoint" {
  value = azurerm_cognitive_account.openai.endpoint
}

output "openai_primary_key" {
  value     = azurerm_cognitive_account.openai.primary_access_key
  sensitive = true
}

output "openai_deployment_name" {
  value = azurerm_cognitive_deployment.openai_default.name
}

output "search_service_name" {
  value = azurerm_search_service.vector.name
}

output "search_service_endpoint" {
  value = "https://${azurerm_search_service.vector.name}.search.windows.net"
}

output "search_service_key" {
  value     = azurerm_search_service.vector.primary_key
  sensitive = true
}

output "storage_account_name" {
  value = azurerm_storage_account.data.name
}

output "storage_connection_string" {
  value     = azurerm_storage_account.data.primary_connection_string
  sensitive = true
}
