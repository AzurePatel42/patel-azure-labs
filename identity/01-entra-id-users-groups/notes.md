@'
# Notes — AZ-104 Entra ID Lab

## Identity Model

Microsoft Entra ID provides identity and access management for Azure and applications.

The lab covered:

- Users
- Groups
- Managed identities
- App registrations
- Service principals

## Users and Groups

Users represent identities.

Groups allow multiple users to be managed collectively.

Groups examined:

- patelfamily
- Marketing
- tampagroup

Group membership was verified using `az ad group member check`.

## Azure RBAC

Azure RBAC controls authorization to Azure resources.

Roles examined:

### Reader
Can view resources but cannot make changes.

### Contributor
Can manage resources but cannot assign Azure RBAC roles.

### Owner
Full resource management, including Azure RBAC role assignment.

## RBAC Scope

RBAC can be assigned at:

- Subscription
- Resource group
- Resource

This lab used resource-group and resource-level scopes.

## Managed Identity

### User-assigned Managed Identity

Created as a separate Azure resource:

`id-az104-identity-01`

The managed identity received the Reader role at the resource-group scope.

### System-assigned Managed Identity

The storage account `staz104idlab01` was configured with a system-assigned managed identity.

System-assigned identities are tied to the lifecycle of the Azure resource.

## App Registration

Application:

`app-az104-identity-01`

The application was registered in Microsoft Entra ID and represented in the tenant by a Service Principal.

## App Registration vs Service Principal

```text
App Registration
      |
      v
Application definition
      |
      v
Service Principal
      |
      v
Tenant identity
      |
      v
Azure RBAC



The Application Object ID and Service Principal Object ID are different identifiers.

Client Secret

A client secret was created for the lab.

Credential lifecycle:

Create
Verify metadata
Do not expose the secret
Delete

The secret was deleted before cleanup.

Key Vault

Azure Key Vault was created with RBAC authorization enabled.

The Microsoft.KeyVault resource provider initially showed:

NotRegistered

It was registered successfully before creating the vault.

Key Vault RBAC

The user-assigned managed identity received:

Key Vault Secrets User

at the Key Vault scope.

This demonstrates least-privilege access for an application identity.

RBAC Troubleshooting

The first attempt to create a Key Vault secret failed with:

ForbiddenByRbac

The error showed that the signed-in user was the caller.

The managed identity's permissions did not automatically apply to the human user.

A temporary:

Key Vault Secrets Officer

role was assigned to the signed-in user.

The harmless lab secret was then created successfully.

The temporary human-user role was removed before cleanup.

Key Lesson

Always identify the actual caller when troubleshooting Azure RBAC.

Managed Identity vs Client Secret

Client secret:

Application
     |
     v
Client Secret
     |
     v
Credential lifecycle
     |
     v
Rotation / Expiration / Revocation

Managed identity:

Azure Resource
     |
     v
Managed Identity
     |
     v
Microsoft Entra ID
     |
     v
Target Azure Resource

Managed identity reduces the need for applications to store credentials.

Least Privilege

The lab demonstrated least privilege by giving:

Marketing group → Reader on resource group
User-assigned managed identity → Reader on resource group
Storage account identity → Reader on resource group
Application Service Principal → Reader on resource group
User-assigned managed identity → Key Vault Secrets User on Key Vault

The human user received Key Vault Secrets Officer only temporarily to perform the lab operation.

Cleanup

All Azure lab resources were placed inside:

rg-az104-identity-01

The resource group was deleted after completing the lab.

Final verification:

az group exists --name rg-az104-identity-01

returned:

false

Therefore the Azure resources created by this lab were successfully cleaned up.

Interview Takeaways
What is Microsoft Entra ID?

A cloud identity and access management service used for Azure and application identities.

What is Azure RBAC?

A system for controlling which identities can perform which actions on Azure resources at defined scopes.

What is Managed Identity?

An Azure-managed identity that allows supported Azure resources and applications to authenticate without managing credentials directly.

App Registration vs Service Principal?

The App Registration defines the application. The Service Principal is the application's identity within a tenant.

Why Key Vault?

To securely store and control access to secrets, keys, and certificates.

Why Managed Identity?

It avoids unnecessary application credential storage and simplifies authentication to supported Azure resources.
'@ | Set-Content .\notes.md