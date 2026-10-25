# Storage account names must be globally unique, so add a random suffix.
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_resource_group" "site" {
  name     = "rg-${var.project_name}-${random_string.suffix.result}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "site" {
  name                     = "st${var.project_name}${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.site.name
  location                 = azurerm_resource_group.site.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Security baseline: HTTPS only, modern TLS, no public blob containers.
  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  tags = var.tags
}

resource "azurerm_storage_account_static_website" "site" {
  storage_account_id = azurerm_storage_account.site.id
  index_document     = "index.html"
  error_404_document = "404.html"
}

# Upload every file in ./site to the special $web container.
locals {
  site_files = fileset("${path.module}/site", "**")

  content_types = {
    html = "text/html"
    css  = "text/css"
    js   = "application/javascript"
    png  = "image/png"
    jpg  = "image/jpeg"
    svg  = "image/svg+xml"
    ico  = "image/x-icon"
  }
}

resource "azurerm_storage_blob" "site" {
  for_each = local.site_files

  name                 = each.value
  storage_container_id = "${azurerm_storage_account.site.id}/blobServices/default/containers/$web"
  type                 = "Block"
  source               = "${path.module}/site/${each.value}"
  content_md5          = filemd5("${path.module}/site/${each.value}")
  content_type         = lookup(local.content_types, reverse(split(".", each.value))[0], "application/octet-stream")

  depends_on = [azurerm_storage_account_static_website.site]
}
