variable "name_prefix" {
  description = "Prefix for Azure resource names; non-alphanumeric characters are stripped."
  type        = string
  default     = "genai"
}

variable "tags" {
  description = "Common tags to apply to all resources."
  type        = map(string)
  default     = {}
}

variable "openai_account_name" {
  description = "Override for Azure OpenAI account name. Leave empty to auto-generate."
  type        = string
  default     = ""
}

variable "subscription_id" {
  description = "Azure subscription ID to deploy into."
  type        = string
}

variable "subscription_name" {
  description = "Friendly subscription name"
  type        = string
}

variable "resource_group_name" {
  description = "Existing resource group name to deploy resources into."
  type        = string
}

variable "model_deployment_name" {
  description = "Azure OpenAI deployment name."
  type        = string
  default     = "gpt-4o-mini"
}

variable "model_name" {
  description = "Azure OpenAI model name."
  type        = string
  default     = "gpt-4o-mini"
}

variable "model_version" {
  description = "Azure OpenAI model version."
  type        = string
  default     = "2024-07-18"
}

variable "model_capacity" {
  description = "Capacity units for the OpenAI deployment (check subscription limits)."
  type        = number
  default     = 1
}

variable "embedding_deployment_name" {
  description = "Azure OpenAI embedding deployment name."
  type        = string
  default     = "text-embedding-3-large"
}

variable "embedding_model_name" {
  description = "Azure OpenAI embedding model name."
  type        = string
  default     = "text-embedding-3-large"
}

variable "embedding_model_version" {
  description = "Azure OpenAI embedding model version."
  type        = string
  default     = "2024-05-13"
}

variable "embedding_model_capacity" {
  description = "Capacity units for the embedding deployment."
  type        = number
  default     = 1
}

variable "search_sku" {
  description = "SKU for Azure AI Search; Standard supports vector search."
  type        = string
  default     = "standard"
}

variable "search_partition_count" {
  description = "Number of partitions for the search service."
  type        = number
  default     = 1
}

variable "search_replica_count" {
  description = "Number of replicas for the search service."
  type        = number
  default     = 1
}
