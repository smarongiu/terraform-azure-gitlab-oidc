output "azure_client_id" {
  value       = azuread_application_registration.gitlab_oidc.client_id
  description = "Application (client) ID — use as AZURE_CLIENT_ID in GitLab CI/CD."
}

output "azure_sp_object_id" {
  value       = azuread_service_principal.gitlab_oidc.object_id
  description = "Object ID of the Service Principal (useful for debugging / RBAC)."
}

output "federated_credential_ids" {
  value       = concat(azuread_application_federated_identity_credential.gitlab_credential.*.id)
  description = "IDs of federated identity credentials created by Terraform."
}
