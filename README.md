# Configure OpenID Connect (OIDC) between Azure and GitLab

Official gitlab guide [here](https://docs.gitlab.com/ci/cloud_services/azure/)

# Use
1. Clone or fork this project.
2. Add a `terraform.tfvars` with your specific values.
```
   subscription_id            = "******"
   tenant_id                  = "******"
   aws_region                 = "eu-west-2"
   gitlab_issuer_url          = "https://gitlab.example.com"
   gitlab_audiences           = "https://gitlab.example.com"
   gitlab_credential_subjects = ["project_path:mygroup/myproject:ref_type:branch:ref:main"]
   azure_role_to_assign       = "Reader"
```
3. Run terrorm init, plan, and apply.
4. Note the `azure_client_id` from output.
5. Add the following CI/CD variables in your GitLab project:
```
AZURE_CLIENT_ID: <azure_client_id>
AZURE_TENANT_ID: <azure tenant id>
```

6. Add id_tokens block to your gitlab-ci yaml, specifying `aud` as configured in `gitlab_audiences`. Example:
```yaml
id_tokens:
  GITLAB_OIDC_TOKEN:
    aud: https://gitlab.example.com
```
7. Login to azure. Full example:
```yaml
job-example:
  id_tokens:
    GITLAB_OIDC_TOKEN:
      aud: https://gitlab.example.com
  script:
    - az login --service-principal -u $AZURE_CLIENT_ID -t $AZURE_TENANT_ID --federated-token $GITLAB_OIDC_TOKEN
    - az account show
```

## Additional resources
- https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation
- https://azure.github.io/azure-workload-identity/docs/topics/federated-identity-credential.html#federated-identity-credential-for-an-azure-ad-application-1
- https://learn.microsoft.com/en-us/answers/questions/1160840/why-doesnt-app-registration-federated-credentials
