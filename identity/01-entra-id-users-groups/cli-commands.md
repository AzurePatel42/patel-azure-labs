
@'
# CLI Commands — AZ-104 Entra ID Lab

## Account Context

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
Lab Resource Group
az group create `
  --name rg-az104-identity-01 `
  --location eastus `
  --output table
Resource Group RBAC
az role assignment create `
  --assignee-object-id "3e3eadff-a748-49ca-ad9e-995a4c9d3b93" `
  --assignee-principal-type Group `
  --role "Reader" `
  --scope "/subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec/resourceGroups/rg-az104-identity-01" `
  --output table
User-assigned Managed Identity
az identity list `
  --query "[].{Name:name,ResourceGroup:resourceGroup,Location:location,PrincipalId:principalId,ClientId:clientId}" `
  --output table
az identity show `
  --name id-az104-identity-01 `
  --resource-group rg-az104-identity-01 `
  --query "{Name:name,PrincipalId:principalId,ClientId:clientId}" `
  --output table
Managed Identity RBAC
az role assignment create `
  --assignee-object-id "bffe6214-84c3-4077-aa9b-62d24a448d79" `
  --assignee-principal-type ServicePrincipal `
  --role "Reader" `
  --scope "/subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec/resourceGroups/rg-az104-identity-01" `
  --output table
Storage Account System-assigned Identity
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
az ad app show `
  --id "37d2f223-2725-4c4d-8227-133ccd6a3d2a" `
  --query "{DisplayName:displayName,AppId:appId,ObjectId:id,PublisherDomain:publisherDomain}" `
  --output table
Service Principal
az ad sp create `
  --id "37d2f223-2725-4c4d-8227-133ccd6a3d2a" `
  --output table
az ad sp show `
  --id "37d2f223-2725-4c4d-8227-133ccd6a3d2a" `
  --query "{DisplayName:displayName,AppId:appId,ObjectId:id,Type:servicePrincipalType,AccountEnabled:accountEnabled}" `
  --output table
Service Principal RBAC
az role assignment create `
  --assignee-object-id "da1d7b12-bb81-4056-b750-42c7906f23bc" `
  --assignee-principal-type ServicePrincipal `
  --role "Reader" `
  --scope "/subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec/resourceGroups/rg-az104-identity-01" `
  --output table
Client Secret Lifecycle
az ad app credential reset `
  --id "37d2f223-2725-4c4d-8227-133ccd6a3d2a" `
  --append `
  --display-name "az104-lab-secret" `
  --years 1 `
  --output json

Never commit or paste the returned secret value.

az ad app credential list `
  --id "37d2f223-2725-4c4d-8227-133ccd6a3d2a" `
  --query "[].{DisplayName:displayName,KeyId:keyId,StartDate:startDateTime,EndDate:endDateTime}" `
  --output table
az ad app credential delete `
  --id "37d2f223-2725-4c4d-8227-133ccd6a3d2a" `
  --key-id "9a4cf8bb-81b7-45fb-87c6-0f5cc37f83f7"
Key Vault Provider Registration
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
  --assignee-object-id "bffe6214-84c3-4077-aa9b-62d24a448d79" `
  --assignee-principal-type ServicePrincipal `
  --role "Key Vault Secrets User" `
  --scope "/subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec/resourceGroups/rg-az104-identity-01/providers/Microsoft.KeyVault/vaults/kv-az104-identity-01" `
  --output table
Temporary Key Vault Secret Management Role

The signed-in user temporarily received Key Vault Secrets Officer because the CLI command was executed by the user.

az role assignment create `
  --assignee-object-id "0563a187-761f-4cbe-83d7-cbf337d0be33" `
  --assignee-principal-type User `
  --role "Key Vault Secrets Officer" `
  --scope "/subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec/resourceGroups/rg-az104-identity-01/providers/Microsoft.KeyVault/vaults/kv-az104-identity-01" `
  --output table

The temporary role was removed after creating the lab secret.

Key Vault Secret

Dummy lab value only:

az keyvault secret set `
  --vault-name "kv-az104-identity-01" `
  --name "az104-lab-secret" `
  --value "AZ104-LAB-ONLY" `
  --output table

Metadata verification:

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





---


## Scope


RBAC can be assigned at:


- Subscription
- Resource group
- Resource


The lab used resource-group and resource-level scopes.


---


## Managed Identity


### User-assigned


Created as a separate Azure resource.


Example:


`id-az104-identity-01`


Principal ID:


`bffe6214-84c3-4077-aa9b-62d24a448d79`


### System-assigned


Attached directly to an Azure resource.


The storage account `staz104idlab01` was configured with a system-assigned identity.


---


## App Registration


Application:


`app-az104-identity-01`


App ID:


`37d2f223-2725-4c4d-8227-133ccd6a3d2a`


The application was represented in the tenant by a Service Principal.


---


## App Registration vs Service Principal


```text
App Registration
      ↓
Application definition
      ↓
Service Principal
      ↓
Tenant identity
      ↓
Azure RBAC

The App Registration Object ID and Service Principal Object ID are different identifiers.

Client Secret

A client secret was created for learning purposes.

The credential was:

Created.
Listed using metadata only.
Not exposed in documentation.
Deleted.

This demonstrates credential lifecycle management.

Key Vault

Key Vault was created with RBAC authorization enabled.

The subscription initially returned:

MissingSubscriptionRegistration

for Microsoft.KeyVault.

The provider was registered, after which Key Vault creation succeeded.

Key Vault RBAC

The user-assigned managed identity received:

Key Vault Secrets User

at the Key Vault resource scope.

This is appropriate for applications that need to retrieve secrets.

RBAC Troubleshooting

The first attempt to create a Key Vault secret failed with:

ForbiddenByRbac

The caller shown in the error was the signed-in user.

The managed identity's role did not apply to the user.

A temporary Key Vault Secrets Officer role was therefore assigned to the signed-in user to create the harmless lab secret.

The temporary role was then removed.

Important lesson:

Identify the actual caller before modifying RBAC.

Least Privilege

The lab intentionally avoided giving the managed identity broad Key Vault Administrator permissions.

The managed identity received only:

Key Vault Secrets User

The human user temporarily received:

Key Vault Secrets Officer

only for the required lab operation.

Managed Identity vs Client Secret

Client Secret:

Application
   ↓
Secret
   ↓
Credential management
   ↓
Rotation / expiration / revocation

Managed Identity:

Azure Resource
   ↓
Managed Identity
   ↓
Entra ID
   ↓
Target Azure Resource

Managed identity reduces the need for applications to store long-lived credentials.

Resource Provider Registration

Azure resource providers must be registered at the subscription level before certain resource types can be deployed.

The Key Vault provider was initially:

NotRegistered

It was changed to:

Registered

using Azure CLI.

Cleanup

All lab resources were contained in:

rg-az104-identity-01

The resource group was deleted after the lab.

Final verification returned:

false

for az group exists.

Interview Takeaways
What is Entra ID?

Cloud identity and access management for Azure and applications.

What is Azure RBAC?

Authorization that determines which identities can perform which actions on Azure resources at defined scopes.

What is Managed Identity?

An Azure-managed identity that allows supported resources/applications to authenticate without managing credentials.

App Registration vs Service Principal?

The App Registration defines the application; the Service Principal represents the application's identity in a tenant.

Why Key Vault?

To securely store and control access to secrets, keys, and certificates.

Why Managed Identity?

To avoid unnecessary application credential management when Azure-supported managed identity is available.
'@ | Set-Content .\notes.md





The Key Vault was configured for Azure RBAC authorization.


---


## 12. Key Vault IAM


Open:


Key Vault → Access control (IAM) → Role assignments


The user-assigned managed identity was assigned:


`Key Vault Secrets User`


at the Key Vault scope.


---


## 13. Key Vault Secret


Open:


Key Vault → Objects → Secrets


The lab created:


`az104-lab-secret`


using a harmless dummy value.


---


## 14. RBAC Troubleshooting


The initial secret creation failed with:


`ForbiddenByRbac`


The error identified the signed-in user as the caller.


The managed identity had the required Key Vault role, but the human user did not.


A temporary `Key Vault Secrets Officer` role was assigned to the signed-in user.


The secret was then successfully created.


The temporary role was removed before cleanup.


---


## 15. Cleanup


All Azure resources were contained in:


`rg-az104-identity-01`


The resource group was deleted after completing the lab.


Verification:


```powershell
az group exists --name rg-az104-identity-01

Expected:

false
Screenshot Checklist

Recommended screenshots:

Entra account context
Users
Groups
Group members
Marketing Reader RBAC
Managed identity
System-assigned identity
Managed identity RBAC
App registration / service principal
Service principal Reader RBAC
Client secret
Client secret revoked
Key Vault created
Key Vault managed identity RBAC
Key Vault lab secret
Lab Status

Completed — 100%.