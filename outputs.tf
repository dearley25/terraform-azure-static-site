output "website_url" {
  description = "Public URL of the static website."
  value       = azurerm_storage_account.site.primary_web_endpoint
}

output "resource_group_name" {
  description = "Resource group that holds everything this project creates."
  value       = azurerm_resource_group.site.name
}

output "storage_account_name" {
  description = "Storage account hosting the site."
  value       = azurerm_storage_account.site.name
}
