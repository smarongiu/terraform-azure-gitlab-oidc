variable "subscription_id" {
  description = "Azure subscription id"
}

variable "tenant_id" {
  default = "Azure tenant id"
}

variable "gitlab_credential_subjects" {
  type        = list(string)
  description = "The explicit subject in credentials for Gitlab: (e.g., 'project_path:mygroup/myproject:ref_type:branch:ref:main')."
}

variable "gitlab_issuer_url" {
  type        = string
  description = "The issuer URL for your GitLab instance (also used as issuer in federated credentials, e.g.: 'https://gitlab.com')."
}

variable "gitlab_audiences" {
  type        = list(string)
  description = "The aud value(s) expected in the GitLab ID token. Must match the 'audiences' in the federated credential and your pipeline's id_tokens.aud (e.g.: 'https://gitlab.com')."
}

variable "resource_prefix" {
  type = string
  description = "(Optional) The prefix for resource names (e.g.: dev, sandbox, prod, dv-stg-xxx). Default is empty."
  default = ""
}

variable "azure_role_to_assign" {
  type        = string
  description = "The name of the Azure role to assign to the service principal (e.g., 'Reader', 'Contributor')."
  default     = "Reader"
}

variable "assignment_scope" {
  type        = string
  description = "(Optional) Scope for the role assignment. If empty, defaults to the current subscription (/subscriptions/<id>). You can set a resource group or resource id."
  default     = ""
}
