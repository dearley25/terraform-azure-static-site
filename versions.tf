terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "azurerm" {
  features {}

  # Register only the resource provider this project uses instead of the
  # provider's default set.
  resource_provider_registrations = "none"
  resource_providers_to_register  = ["Microsoft.Storage"]

  # The subscription is read from the ARM_SUBSCRIPTION_ID environment variable,
  # and credentials come from `az login`. No secrets are stored in this repo.
}
