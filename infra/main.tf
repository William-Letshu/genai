resource "random_string" "suffix" {
  length  = 4
  upper   = false
  lower   = true
  numeric = true
  special = false
}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

locals {
  cleaned_prefix = lower(replace(var.name_prefix, "/[^0-9a-z]/", ""))
  base_prefix    = length(local.cleaned_prefix) > 0 ? local.cleaned_prefix : "genai"
  unique_suffix  = random_string.suffix.result
  effective_tags = merge(var.tags, var.subscription_name == "" ? {} : { subscription = var.subscription_name })
  openai_account = var.openai_account_name != "" ? var.openai_account_name : "${local.short_name}aoai"
  # Storage and OpenAI names must be alphanumeric; truncate to stay within Azure limits.
  short_name = substr("${local.base_prefix}${local.unique_suffix}", 0, 12)
}

resource "azurerm_cognitive_account" "openai" {
  name                = "${local.openai_account}-v2"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  kind                = "OpenAI"
  sku_name            = "S0"
  

  public_network_access_enabled = true
  tags                          = local.effective_tags
}

resource "azurerm_cognitive_deployment" "openai_default" {
  name                 = var.model_deployment_name
  cognitive_account_id = azurerm_cognitive_account.openai.id

  model {
    format = "OpenAI"
    name   = var.model_name
  }

  sku {
    name     = "GlobalStandard"
    capacity = var.model_capacity
  }
}

resource "azurerm_cognitive_deployment" "openai_embeddings" {
  name                 = var.embedding_deployment_name
  cognitive_account_id = azurerm_cognitive_account.openai.id

  model {
    format = "OpenAI"
    name   = var.embedding_model_name
  }

  sku {
    name     = "GlobalStandard"
    capacity = var.embedding_model_capacity
  }
}

resource "azurerm_search_service" "vector" {
  name                = "${local.base_prefix}-search-${local.unique_suffix}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  sku                 = var.search_sku
  partition_count     = var.search_partition_count
  replica_count       = var.search_replica_count

  semantic_search_sku           = "standard"
  public_network_access_enabled = true

  identity {
    type = "SystemAssigned"
  }

  tags = local.effective_tags
}

resource "azurerm_storage_account" "data" {
  name                     = substr("${local.short_name}sa", 0, 24)
  resource_group_name      = data.azurerm_resource_group.main.name
  location                 = data.azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  public_network_access_enabled = true
  tags                          = local.effective_tags
}

resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_name  = azurerm_storage_account.data.name
  container_access_type = "private"
}
