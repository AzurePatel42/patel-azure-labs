# AZ-104 Module 05 — Notes

## 1. Azure Key Vault

Azure Key Vault provides a centralized location for storing and controlling access to sensitive values such as:

- Secrets
- Keys
- Certificates

In this lab, the Key Vault was created with Azure RBAC authorization enabled.

```text
Key Vault
kvaz104id05
RBAC Authorization = True



This allows Azure role assignments to control access instead of relying on the older access-policy model.

2. Key Vault RBAC

The lab operator was assigned:

Key Vault Secrets Officer

at the Key Vault scope.

This role was used because the lab required creating and managing secrets.

The important distinction is that an application normally should not receive this level of access.

3. Secret Management

The lab created:

az104-lab-secret

The secret was verified without exposing its actual value in the portfolio evidence.

The lab demonstrated:

Secret creation
Secret retrieval/metadata verification
Secret version identification
Secret expiration
4. Secret Versioning

Key Vault secrets are versioned.

A secret URI can contain a specific version:

https://kvaz104id05.vault.azure.net/secrets/az104-lab-secret/<version>

This allows applications or integrations to reference a particular version when required.

The lab captured the generated secret version as part of the verification process.

5. Secret Expiration

The secret was configured with an expiration date 30 days after creation.

The configured expiration was:

2026-09-23T00:34:03Z

Expiration is useful for enforcing secret lifecycle management and reducing the lifetime of sensitive credentials.

6. Least Privilege

One of the main lessons from this lab was the difference between:

Key Vault Secrets Officer

and:

Key Vault Secrets User
Secrets Officer

Used for managing secrets.

The lab operator received this role.

Secrets User

Designed for workloads that need to read secret values.

The application identity received this role.

The intended architecture was:

Application
     │
     ▼
Managed Identity
     │
     │ Key Vault Secrets User
     ▼
Key Vault

rather than:

Application
     │
     ▼
Key Vault Secrets Officer

The second design grants more permission than the application needs.

7. User-Assigned Managed Identity

The lab created:

id-az104-identity-05

The identity had:

Principal ID:
841131e8-b384-44f9-b005-a59b4c7be75a

and:

Client ID:
0a176b4e-c5b6-449e-868e-97390f09bed5

The identity was assigned:

Key Vault Secrets User

at the Key Vault scope.

8. Why Managed Identity?

Without Managed Identity, an application might need to store credentials such as:

Client ID
Client Secret
Tenant ID

inside configuration or a secret store.

Managed Identity allows Azure-hosted workloads to authenticate to Azure resources without storing an application password.

The identity is managed by Microsoft Entra ID and Azure.

9. Local Managed Identity Test

An attempt was made to authenticate from the local Windows machine using:

az login --identity --client-id $identity05ClientId

The command failed while attempting to reach:

169.254.169.254

The error was:

WinError 10051
A socket operation was attempted to an unreachable network

This was not an RBAC failure.

The local Windows machine does not have access to the Azure Instance Metadata Service endpoint used by Azure-hosted resources for Managed Identity authentication.

This was an important troubleshooting lesson.

10. Azure Container Apps

To demonstrate the correct execution environment, a temporary Azure Container Apps environment was created:

cae-az104-id05

A temporary Container App was then created:

ca-az104-kv-test

The User-Assigned Managed Identity was attached to the Container App.

Verified configuration:

Identity Type:
UserAssigned

Identity:

id-az104-identity-05
11. Container App + Key Vault

The Container App was configured with a Key Vault-backed secret reference.

The resulting architecture was:

Container App
      │
      ▼
User-Assigned Managed Identity
      │
      │ Key Vault Secrets User
      ▼
Azure Key Vault
      │
      ▼
az104-lab-secret

The Container App configuration referenced the Key Vault secret through the managed identity.

The actual secret value was not placed into the configuration output or screenshots.

12. Important Security Boundary

The application identity was given:

Key Vault Secrets User

not:

Key Vault Secrets Officer

This creates a clear security boundary.

Lab Administrator
       │
       ▼
Secrets Officer
       │
       └── Manage secrets




Application
       │
       ▼
Managed Identity
       │
       ▼
Secrets User
       │
       └── Read secret values
13. Secret Value Protection

The actual secret value should not appear unnecessarily in:

Git repositories
README files
Screenshots
Terminal logs
Application source code
Configuration files

The lab intentionally used metadata-only queries for final evidence.

For example:

az keyvault secret show `
  --vault-name kvaz104id05 `
  --name "az104-lab-secret" `
  --query "{Name:name,Version:id,Enabled:attributes.enabled,Expires:attributes.expires}" `
  --output table

This verifies the secret without displaying its value.

14. RBAC Verification

The managed identity assignment was verified with:

az role assignment list `
  --assignee-object-id $identity05PrincipalId `
  --scope $keyVaultId `
  --query "[].{Role:roleDefinitionName,Scope:scope,PrincipalType:principalType}" `
  --output table

Expected relationship:

Key Vault Secrets User
        │
        ▼
kvaz104id05

Principal type:

ServicePrincipal
15. Resource Isolation

The entire lab was isolated inside:

rg-az104-identity-05

This made cleanup safer.

Temporary resources included:

Key Vault
User-Assigned Managed Identity
Container Apps Environment
Container App
Log Analytics workspace

The resource group was deleted after the lab.

Final verification returned:

(ResourceGroupNotFound)

confirming successful cleanup.

16. Troubleshooting Lessons
Azure CLI Managed Identity failure

Problem:

169.254.169.254
WinError 10051

Cause:

The command was executed from a local Windows machine rather than an Azure-hosted workload.

Lesson:

Managed Identity authentication must occur from an Azure resource that supports the identity.

Microsoft.App provider

Initially:

Microsoft.App
NotRegistered

The provider was registered:

az provider register --namespace Microsoft.App

After waiting for registration:

Microsoft.App
Registered

Only then was the Container Apps environment created.

Container Apps CLI extension

Initially the Container Apps extension was not installed.

It was installed/upgraded with:

az extension add `
  --name containerapp `
  --upgrade

The installed version was:

containerapp 1.3.0b4

The extension reported that it was a preview extension.

17. Production Architecture Lesson

For a production backend running in Azure Container Apps, the preferred pattern is:

                    Azure Container App
                           │
                           │
                 User-Assigned Identity
                           │
                           ▼
                    Microsoft Entra ID
                           │
                           │
                    Azure RBAC
                           │
                           ▼
                      Key Vault
                           │
                           ▼
                     Application
                      Secret

This avoids embedding long-lived Azure credentials inside the application.

18. Key Takeaways
Key Vault centralizes sensitive configuration.
Azure RBAC controls access to Key Vault.
Secret management and secret consumption are different permissions.
Least privilege should be applied to application identities.
User-Assigned Managed Identities are reusable across Azure workloads.
Container Apps can use User-Assigned Managed Identities.
Key Vault references can connect Container Apps configuration to Key Vault.
Managed Identity authentication cannot be tested from a normal local machine using the Azure IMDS endpoint.
Secret values should be protected from source control and screenshots.
Temporary Azure resources should be cleaned up after hands-on labs.
Lab Status

Completed — August 2026

Core topics demonstrated:

Azure Key Vault
Secrets
Secret versions
Secret expiration
Azure RBAC
Least privilege
User-Assigned Managed Identity
Container Apps
Key Vault references
Identity troubleshooting
Azure resource cleanup