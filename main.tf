terraform {
  required_version = ">= 1.13.1"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.42.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 3.5.0"
    }
  }
}

provider "azurerm" {
  features {}
  use_cli             = true
  storage_use_azuread = true
  subscription_id     = var.subscription_id
  tenant_id           = var.tenant_id
}

provider "azuread" {
  tenant_id           = var.tenant_id
}

data "azuread_client_config" "current" {}

locals {
  scope = var.assignment_scope != "" ? var.assignment_scope : "/subscriptions/${var.subscription_id}"
  prefix = var.resource_prefix != "" ? "${var.resource_prefix}-" : ""
}

resource "azuread_application_registration" "gitlab_oidc" {
  display_name = "${prefix}gitlab-oidc"
  sign_in_audience = "AzureADMyOrg"
}

resource "azuread_service_principal" "gitlab_oidc" {
  client_id = azuread_application_registration.gitlab_oidc.client_id
  owners = [data.azuread_client_config.current.object_id]
}

# 3. Federated cred — non-flexible terraform-managed path (explicit subject, one credential per project)
resource "azuread_application_federated_identity_credential" "gitlab_credential" {
  count = length(var.gitlab_credential_subjects)

  application_id = azuread_application_registration.gitlab_oidc.id
  display_name = "${prefix}gitlab-credential-${count.index}"
  description  = "Federated identity credential for Gitlab OIDC integration."
  audiences    = var.gitlab_audiences
  issuer       = var.gitlab_issuer_url
  subject      = var.gitlab_credential_subjects[count.index]
}

data "azurerm_role_definition" "role" {
  name  = var.azure_role_to_assign
  scope = local.scope
}

resource "azurerm_role_assignment" "gitlab_oidc_sp_role" {
  scope              = local.scope
  role_definition_id = data.azurerm_role_definition.role.id
  principal_id       = azuread_service_principal.gitlab_oidc.object_id

  # avoid accidental duplicates: generate unique name if needed (provider does it)
  depends_on = [azuread_service_principal.gitlab_oidc]
}
