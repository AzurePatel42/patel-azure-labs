@'
# AZ-104 Lab 01 — Microsoft Entra ID: Users, Groups, RBAC, Managed Identity, App Registration & Key Vault

## Objective

This lab provides hands-on experience with Microsoft Entra ID and Azure identity/security concepts relevant to AZ-104.

The lab covers:

- Microsoft Entra users and groups
- Group membership
- Azure RBAC
- Role definitions
- User-assigned managed identities
- System-assigned managed identities
- App registrations
- Service principals
- Client-secret lifecycle
- Azure Key Vault
- Key Vault RBAC
- Least-privilege access
- Identity/RBAC troubleshooting
- Azure resource cleanup

---

## Environment

- Azure subscription: `patel-platform-service-template`
- Region: `eastus`
- Lab resource group: `rg-az104-identity-01`
- Azure CLI
- Microsoft Entra ID
- Azure RBAC
- Azure Managed Identity
- Azure Key Vault

---

## Lab Architecture

```text
Microsoft Entra ID
│
├── Users
│
├── Groups
│
├── App Registration
│      │
│      └── Service Principal
│              │
│              └── Azure RBAC → Reader
│
└── Managed Identities
       │
       ├── User-assigned Identity
       │       └── Azure RBAC
       │
       └── System-assigned Identity
               └── Azure RBAC

Managed Identity
       │
       ▼
Microsoft Entra ID
       │
       ▼
Azure Key Vault
       │
       └── Key Vault Secrets User

Key Concepts Learned
Microsoft Entra Users

Users are identities that can authenticate to Microsoft Entra ID.

Groups

Groups allow permissions and access to be managed for multiple users collectively.

Azure RBAC

Azure RBAC controls access to Azure resources.

Common built-in roles examined:

Reader
Contributor
Owner
Role Scope

Azure RBAC can be assigned at different scopes, including:

Subscription
Resource group
Individual resource

This lab primarily used resource-group and resource-level scopes.

Managed Identity

Two managed identity types were demonstrated:

User-assigned managed identity

Created independently as an Azure resource and reusable by supported Azure resources.

Example:

id-az104-identity-01
System-assigned managed identity

Created as part of an Azure resource's lifecycle.

The Storage Account was configured with a system-assigned identity.

App Registration vs Service Principal

An important distinction demonstrated in this lab:

App Registration
      │
      ▼
Application definition
      │
      ▼
Service Principal
      │
      ▼
Identity used by the application in the tenant

The application produced multiple identifiers:

App/Client ID
App Registration Object ID
Service Principal Object ID

These identifiers must not be confused when troubleshooting Azure identity and RBAC.

Client Secret Lifecycle

A client secret was intentionally created for learning purposes.

Lifecycle:

Create
  ↓
Inspect metadata
  ↓
Do not expose secret value
  ↓
Delete credential

The lab credential was successfully revoked before cleanup.

This demonstrates why long-lived application secrets should be avoided when managed identity is available.

Azure Key Vault

Azure Key Vault was created with RBAC authorization enabled.

The user-assigned managed identity was granted:

Key Vault Secrets User

A temporary:

Key Vault Secrets Officer

role was assigned to the signed-in user only to create a harmless lab secret.

That temporary role was removed before cleanup.

Important Troubleshooting Event

The first Key Vault secret creation failed with:

ForbiddenByRbac

The error identified the actual caller as the signed-in user.

The managed identity had:

Key Vault Secrets User

but the signed-in user did not.

The issue was resolved by temporarily assigning:

Key Vault Secrets Officer

to the signed-in user.

After the secret was created, that temporary role was removed.

This demonstrated an important Azure security principle:

Always identify the actual caller before changing permissions.

Resource Provider Registration

Key Vault creation initially failed because:

Microsoft.KeyVault

was not registered for the subscription.

The provider was registered using Azure CLI:

az provider register --namespace Microsoft.KeyVault --wait

After registration, Key Vault creation succeeded.

Cleanup

All lab resources were placed in:

rg-az104-identity-01

The resource group contained:

User-assigned managed identity
Storage account
Key Vault

The resource group was deleted after completing the lab.

Final verification:

az group exists --name rg-az104-identity-01
false

The Azure environment was therefore cleaned up successfully.

Interview Takeaways
What is the difference between App Registration and Service Principal?

An App Registration defines the application. A Service Principal is the application's identity in a specific Entra tenant.

What is Managed Identity?

Managed Identity provides an Azure-managed identity that applications/resources can use to authenticate to supported services without storing credentials in application configuration.

Why use Key Vault?

Key Vault provides centralized protection and controlled access to secrets, keys, and certificates.

What is Azure RBAC?

Azure RBAC controls who can perform which actions on Azure resources at a specified scope.

Why prefer Managed Identity over Client Secrets?

Managed identities remove the need for applications to manage long-lived credentials.

Lab Status

Completed — 100%

Azure resources cleaned up successfully.
'@ | Set-Content .\README.md



### 2. `cli-commands.md`


```powershell
@'
# CLI Commands — AZ-104 Entra ID Lab


## Account


```powershell
az account show `
  --query "{Subscription:name,SubscriptionId:id,TenantId:tenantId,User:user.name}" `
  --output table
Signed-in User
az ad signed-in-user show `
  --query "{DisplayName:displayName,UPN:userPrincipalName,Id:id}" `
  --output table
Users
az ad user list `
  --query "[].{DisplayName:displayName,UPN:userPrincipalName,AccountEnabled:accountEnabled}" `
  --output table
Groups
az ad group list `
  --query "[].{Name:displayName,Id:id,SecurityEnabled:securityEnabled,MailEnabled:mailEnabled}" `
  --output table
Group Members
az ad group member list `
  --group "Marketing" `
  --query "[].{Name:displayName,UPN:userPrincipalName,Type:userType}" `
  --output table
Group Membership Check
az ad user show `
  --id "JayP@patel42maheshoutlook.onmicrosoft.com" `
  --query "{Name:displayName,UPN:userPrincipalName,Id:id}" `
  --output table
az ad group member check `
  --group "tampagroup" `
  --member-id "41f333f8-b1a4-4017-879d-9b253b4c00c8" `
  --output table
Role Definitions
az role definition list `
  --name "Reader" `
  --query "[].{Name:roleName,Id:name,Description:description}" `
  --output table
az role definition list `
  --name "Contributor" `
  --query "[].{Name:roleName,Id:name,Description:description}" `
  --output table
az role definition list `
  --name "Owner" `
  --query "[].{Name:roleName,Id:name,Description:description}" `
  --output table
Resource Group
az group create `
  --name rg-az104-identity-01 `
  --location eastus `
  --output table
Managed Identity
az identity list `
  --query "[].{Name:name,ResourceGroup:resourceGroup,Location:location,PrincipalId:principalId,ClientId:clientId}" `
  --output table
az identity show `
  --name id-az104-identity-01 `
  --resource-group rg-az104-identity-01 `
  --query "{Name:name,PrincipalId:principalId,ClientId:clientId}" `
  --output table
RBAC for Managed Identity
az role assignment create `
  --assignee-object-id "bffe6214-84c3-4077-aa9b-62d24a448d79" `
  --assignee-principal-type ServicePrincipal `
  --role "Reader" `
  --scope "/subscriptions/<subscription-id>/resourceGroups/rg-az104-identity-01" `
  --output table
Storage Account System-Assigned Identity
az storage account update `
  --name staz104idlab01 `
  --resource-group rg-az104-identity-01 `
  --assign-identity `
  --output table
az storage account show `
  --name staz104idlab01 `
  --resource-group rg-az104-identity-01 `
  --query "{Name:name,SystemAssignedPrincipalId:identity.principalId,TenantId:identity.tenantId}" `
  --output table
App Registration
az ad app create `
  --display-name "app-az104-identity-01" `
  --output table
Service Principal
az ad sp create `
  --id "<app-id>" `
  --output table
App / Service Principal Inspection
az ad app show `
  --id "<app-id>" `
  --query "{DisplayName:displayName,AppId:appId,ObjectId:id,PublisherDomain:publisherDomain}" `
  --output table
az ad sp show `
  --id "<app-id>" `
  --query "{DisplayName:displayName,AppId:appId,ObjectId:id,Type:servicePrincipalType,AccountEnabled:accountEnabled}" `
  --output table
Service Principal RBAC
az role assignment create `
  --assignee-object-id "<service-principal-object-id>" `
  --assignee-principal-type ServicePrincipal `
  --role "Reader" `
  --scope "/subscriptions/<subscription-id>/resourceGroups/rg-az104-identity-01" `
  --output table
az role assignment list `
  --assignee "<service-principal-object-id>" `
  --all `
  --query "[].{Role:roleDefinitionName,Principal:principalName,Type:principalType,Scope:scope}" `
  --output table
Client Secret
az ad app credential reset `
  --id "<app-id>" `
  --append `
  --display-name "az104-lab-secret" `
  --years 1 `
  --output json

Never store or publish the returned secret value.

az ad app credential list `
  --id "<app-id>" `
  --query "[].{DisplayName:displayName,KeyId:keyId,StartDate:startDateTime,EndDate:endDateTime}" `
  --output table

Delete the credential:

az ad app credential delete `
  --id "<app-id>" `
  --key-id "<key-id>"
Key Vault Provider
az provider show `
  --namespace Microsoft.KeyVault `
  --query "{Provider:namespace,State:registrationState}" `
  --output table
az provider register `
  --namespace Microsoft.KeyVault `
  --wait
Key Vault
az keyvault create `
  --name kv-az104-identity-01 `
  --resource-group rg-az104-identity-01 `
  --location eastus `
  --enable-rbac-authorization true `
  --output table
az keyvault show `
  --name kv-az104-identity-01 `
  --resource-group rg-az104-identity-01 `
  --query "{Name:name,Location:location,ProvisioningState:properties.provisioningState,EnableRbac:properties.enableRbacAuthorization}" `
  --output table
Key Vault RBAC
az role assignment create `
  --assignee-object-id "<managed-identity-principal-id>" `
  --assignee-principal-type ServicePrincipal `
  --role "Key Vault Secrets User" `
  --scope "/subscriptions/<subscription-id>/resourceGroups/rg-az104-identity-01/providers/Microsoft.KeyVault/vaults/kv-az104-identity-01" `
  --output table
Secret
az keyvault secret set `
  --vault-name "kv-az104-identity-01" `
  --name "az104-lab-secret" `
  --value "AZ104-LAB-ONLY" `
  --output table
az keyvault secret show `
  --vault-name "kv-az104-identity-01" `
  --name "az104-lab-secret" `
  --query "{Name:name,Enabled:attributes.enabled,Created:attributes.created}" `
  --output table
Resource Inventory
az resource list `
  --resource-group rg-az104-identity-01 `
  --query "[].{Name:name,Type:type,Location:location}" `
  --output table
Cleanup
az group delete `
  --name rg-az104-identity-01 `
  --yes
az group exists `
  --name rg-az104-identity-01

Expected:

false

'@ | Set-Content .\cli-commands.md



### 3. `notes.md`


```powershell
@'
# Notes — AZ-104 Entra ID Lab


## Core Identity Model


Microsoft Entra ID provides identity and access management for Azure and applications.


Important identities demonstrated:


- User
- Group
- Managed Identity
- Application
- Service Principal


---


## App Registration vs Service Principal


App Registration:


Defines the application.


Service Principal:


Represents the application as an identity in a tenant.


Mental model:


```text
Application
    ↓
App Registration
    ↓
Service Principal
    ↓
Azure RBAC
Important IDs

An application can have multiple identifiers.

Client / App ID

Identifies the application.

App Registration Object ID

Identifies the application object in Entra ID.

Service Principal Object ID

Identifies the service principal object used for authorization in the tenant.

These IDs are not interchangeable.

Azure RBAC

Azure RBAC answers:

What can this identity do to this Azure resource?

Roles examined:

Reader

Can view resources but cannot make changes.

Contributor

Can manage resources but cannot assign Azure RBAC roles.

Owner

Full resource management including the ability to assign Azure RBAC roles.

RBAC Scope

Permissions can be assigned at:

Subscription
Resource group
Resource

A narrower scope generally follows the principle of least privilege.

Managed Identity

Managed identity allows supported Azure resources/applications to authenticate without storing credentials.

User-assigned

Independent Azure resource.

Can be assigned to multiple supported resources.

System-assigned

Created with the Azure resource and tied to its lifecycle.

Key Vault

Key Vault protects:

Secrets
Keys
Certificates

This lab used Azure RBAC authorization for Key Vault.

Key Vault RBAC

The managed identity received:

Key Vault Secrets User

This is different from:

Key Vault Secrets Officer

The Secrets User role is appropriate for applications that need to read secrets.

The Secrets Officer role was temporarily given to the human user only because the CLI command was being executed by that user and the lab needed to create a test secret.

The temporary role was removed before cleanup.

Troubleshooting Lesson

Initial Key Vault secret creation failed:

ForbiddenByRbac
Assignment: (not found)

The error showed the caller was the signed-in user.

The managed identity's permissions did not apply to the human user.

This demonstrated:

Always identify the actual caller
before changing RBAC permissions.
Resource Provider Registration

Key Vault initially failed because:

Microsoft.KeyVault

was not registered.

The provider was registered:

az provider register --namespace Microsoft.KeyVault --wait

After registration, Key Vault creation succeeded.

Client Secrets

Client secrets can authenticate applications, but they introduce credential-management responsibilities:

Secure storage
Rotation
Expiration
Revocation
Accidental exposure risk

The lab secret was created, inspected without exposing its value, and deleted.

Security Principle

Prefer:

Managed Identity
      ↓
Entra ID
      ↓
Key Vault

over embedding long-lived credentials in application configuration when Azure-supported managed identity is available.

Cleanup Principle

Use a dedicated lab resource group.

At the end:

Resource Group
      ↓
Delete entire lab
      ↓
Verify it no longer exists

This reduces accidental ongoing Azure costs.

Interview Questions
What is Microsoft Entra ID?

Azure's cloud identity and access management service.

What is Azure RBAC?

A resource authorization system controlling who can perform which actions at a particular Azure scope.

What is a managed identity?

An Azure-managed identity that lets applications authenticate to supported resources without managing credentials.

App Registration vs Service Principal?

App Registration defines the application. Service Principal provides the application's identity within a tenant.

Why use Key Vault?

To securely centralize secrets, keys, and certificates.

Why is Managed Identity preferred?

It reduces the need to create, store, rotate, and protect application credentials.

What caused the Key Vault ForbiddenByRbac error?

The signed-in user was the caller, but only the managed identity had been granted Key Vault Secrets User access.

Lab Status

Completed.

Azure resources cleaned up successfully.
'@ | Set-Content .\notes.md



### 4. `portal-steps.md`


```powershell
@'
# Portal Steps — AZ-104 Entra ID Lab


## 1. Microsoft Entra ID


Open the Azure Portal and navigate to:


```text
Microsoft Entra ID

Review:

Overview
Users
Groups
App registrations
Enterprise applications
2. Users

Navigate to:

Microsoft Entra ID
→ Users

Review existing users and their:

Display name
User principal name
Account status
Object ID
3. Groups

Navigate to:

Microsoft Entra ID
→ Groups

Review groups including:

patelfamily
Marketing
tampagroup

Open a group and review:

Members

This demonstrates group-based identity management.

4. Resource Group

Open:

Resource groups
→ rg-az104-identity-01

Review the resources created for the lab.

5. Azure RBAC

Open:

Resource group
→ Access control (IAM)
→ Role assignments

Review the Reader assignment for the Marketing group.

This demonstrates:

Group
  ↓
RBAC role
  ↓
Resource group
6. Managed Identity

Search for:

Managed Identities

Open:

id-az104-identity-01

Review:

Overview
Client ID
Principal ID
Tenant ID

The Principal ID is used when assigning Azure RBAC permissions.

7. Storage Account Identity

Open:

Storage account
→ Security + networking
→ Identity

Review the system-assigned identity.

Note that Azure Portal navigation can change between portal versions. The Azure CLI command used in this lab was:

az storage account update --assign-identity
8. App Registration

Navigate to:

Microsoft Entra ID
→ App registrations
→ app-az104-identity-01

Review:

Application (client) ID
Object ID
Tenant ID
Supported account types
9. Service Principal

Navigate to:

Microsoft Entra ID
→ Enterprise applications

Locate:

app-az104-identity-01

The Enterprise Application represents the service principal in the tenant.

10. Client Secret

Open:

App registration
→ Certificates & secrets

A lab client secret was created and then revoked.

Never expose secret values in screenshots, documentation, source code, or Git.

11. Azure Key Vault

Open:

Key Vaults
→ kv-az104-identity-01

Review:

Overview
Access control (IAM)
Secrets

The Key Vault was configured to use:

Azure role-based access control
12. Key Vault IAM

Open:

Key Vault
→ Access control (IAM)
→ Role assignments

The user-assigned managed identity was assigned:

Key Vault Secrets User

This demonstrates resource-level RBAC.

13. Key Vault Secret

Open:

Key Vault
→ Objects
→ Secrets

A harmless lab secret was created.

Do not use real production credentials in a learning lab.

14. RBAC Troubleshooting

The CLI secret creation initially failed because the signed-in user was the caller.

The managed identity had Key Vault Secrets User, but the signed-in user did not.

The temporary solution was:

Key Vault Secrets Officer

assigned to the signed-in user.

After creating the lab secret, the temporary role was removed.

15. Cleanup

All Azure resources were placed inside:

rg-az104-identity-01

The complete resource group was deleted after the lab.

Final verification:

az group exists --name rg-az104-identity-01

Expected:

false
Screenshots

Recommended screenshots:

01-entra-account-context.png
02-users.png
03-groups.png
04-group-members.png
05-rbac-group-assignment.png
06-managed-identity.png
07-system-assigned-identity.png
08-managed-identity-rbac.png
09-app-registration-service-principal.png
10-service-principal-reader-rbac.png
11-app-client-secret.png
12-client-secret-revoked.png
13-key-vault-created.png
14-key-vault-managed-identity-rbac.png
15-key-vault-secret.png
Lab Status

Completed — 100%.
