# AZ-104 Module 05 — CLI Commands

## 1. Verify Azure Account

```powershell
az account show `
  --query "{Subscription:name,SubscriptionId:id,TenantId:tenantId,User:user.name}" `
  --output table


2. Create Resource Group
az group create `
  --name rg-az104-identity-05 `
  --location eastus `
  --output table

Verify:

az group show `
  --name rg-az104-identity-05 `
  --query "{Name:name,Location:location,ProvisioningState:properties.provisioningState}" `
  --output table
3. Create Key Vault with RBAC
az keyvault create `
  --name kvaz104id05 `
  --resource-group rg-az104-identity-05 `
  --location eastus `
  --enable-rbac-authorization true `
  --output table

Verify:

az keyvault show `
  --name kvaz104id05 `
  --resource-group rg-az104-identity-05 `
  --query "{Name:name,Location:location,ResourceId:id,RbacEnabled:properties.enableRbacAuthorization,ProvisioningState:properties.provisioningState}" `
  --output table
4. Get Current User Object ID
$myObjectId = az ad signed-in-user show `
  --query id `
  --output tsv


$myObjectId
5. Get Key Vault Resource ID
$keyVaultId = az keyvault show `
  --name kvaz104id05 `
  --resource-group rg-az104-identity-05 `
  --query id `
  --output tsv


$keyVaultId
6. Assign Key Vault Secrets Officer

The lab operator requires secret-management permissions during the lab.

az role assignment create `
  --assignee-object-id $myObjectId `
  --assignee-principal-type User `
  --role "Key Vault Secrets Officer" `
  --scope $keyVaultId `
  --output table

Verify:

az role assignment list `
  --assignee-object-id $myObjectId `
  --scope $keyVaultId `
  --query "[].{Role:roleDefinitionName,Scope:scope,PrincipalType:principalType}" `
  --output table
7. Create a Secret
az keyvault secret set `
  --vault-name kvaz104id05 `
  --name "az104-lab-secret" `
  --value "<lab-secret-value>" `
  --output table

Do not commit actual secret values to Git.

8. Verify Secret Metadata
az keyvault secret show `
  --vault-name kvaz104id05 `
  --name "az104-lab-secret" `
  --query "{Name:name,Version:id,Enabled:attributes.enabled,Expires:attributes.expires}" `
  --output table

Use metadata-only queries for portfolio evidence.

9. Secret Versioning

Create a new version:

az keyvault secret set `
  --vault-name kvaz104id05 `
  --name "az104-lab-secret" `
  --value "<new-secret-value>" `
  --output table

Then list versions:

az keyvault secret list-versions `
  --vault-name kvaz104id05 `
  --name "az104-lab-secret" `
  --query "[].{Version:id,Enabled:attributes.enabled,Created:attributes.created}" `
  --output table
10. Configure Secret Expiration

Calculate an expiration date:

$expiration = (Get-Date).ToUniversalTime().AddDays(30).ToString("yyyy-MM-ddTHH:mm:ssZ")


$expiration

Set the expiration:

az keyvault secret set-attributes `
  --vault-name kvaz104id05 `
  --name "az104-lab-secret" `
  --expires $expiration `
  --output table

Verify:

az keyvault secret show `
  --vault-name kvaz104id05 `
  --name "az104-lab-secret" `
  --query "{Name:name,Enabled:attributes.enabled,Expires:attributes.expires,Updated:attributes.updated}" `
  --output table
11. Inspect Key Vault Secrets User
az role definition list `
  --name "Key Vault Secrets User" `
  --query "[].{Name:roleName,Description:description,Actions:permissions[0].actions,DataActions:permissions[0].dataActions}" `
  --output json
12. Inspect Key Vault Secrets Officer
az role definition list `
  --name "Key Vault Secrets Officer" `
  --query "[].{Name:roleName,Description:description,Actions:permissions[0].actions,DataActions:permissions[0].dataActions}" `
  --output json
13. Create User-Assigned Managed Identity
az identity create `
  --name "id-az104-identity-05" `
  --resource-group "rg-az104-identity-05" `
  --location eastus `
  --output table

Capture identity identifiers:

$identity05Id = az identity show `
  --name "id-az104-identity-05" `
  --resource-group "rg-az104-identity-05" `
  --query id `
  --output tsv


$identity05PrincipalId = az identity show `
  --name "id-az104-identity-05" `
  --resource-group "rg-az104-identity-05" `
  --query principalId `
  --output tsv


$identity05ClientId = az identity show `
  --name "id-az104-identity-05" `
  --resource-group "rg-az104-identity-05" `
  --query clientId `
  --output tsv

Verify:

$identity05Id
$identity05PrincipalId
$identity05ClientId
14. Assign Key Vault Secrets User
az role assignment create `
  --assignee-object-id $identity05PrincipalId `
  --assignee-principal-type ServicePrincipal `
  --role "Key Vault Secrets User" `
  --scope $keyVaultId `
  --output table

Verify:

az role assignment list `
  --assignee-object-id $identity05PrincipalId `
  --scope $keyVaultId `
  --query "[].{Role:roleDefinitionName,Scope:scope,PrincipalType:principalType}" `
  --output table

Expected:

Key Vault Secrets User
ServicePrincipal
15. Managed Identity Login Test

A local Windows machine does not have the Azure Instance Metadata Service endpoint required for Managed Identity authentication.

The attempted command was:

az login `
  --identity `
  --client-id $identity05ClientId

The local environment returned an error involving:

169.254.169.254

This is expected when attempting to use Azure Managed Identity from a normal local machine.

16. Install Container Apps Extension

Check:

az extension show `
  --name containerapp `
  --query "{Name:name,Version:version}" `
  --output table

Install or upgrade:

az extension add `
  --name containerapp `
  --upgrade

The lab used Container Apps CLI extension version:

1.3.0b4
17. Register Microsoft.App

Check:

az provider show `
  --namespace Microsoft.App `
  --query "{Namespace:namespace,RegistrationState:registrationState}" `
  --output table

Register:

az provider register `
  --namespace Microsoft.App

Wait until:

Registered
18. Verify Operational Insights
az provider show `
  --namespace Microsoft.OperationalInsights `
  --query "{Namespace:namespace,RegistrationState:registrationState}" `
  --output table

The provider was already registered during this lab.

19. Create Container Apps Environment
az containerapp env create `
  --name cae-az104-id05 `
  --resource-group rg-az104-identity-05 `
  --location eastus `
  --output table

Verify:

az containerapp env show `
  --name cae-az104-id05 `
  --resource-group rg-az104-identity-05 `
  --query "{Name:name,Location:location,ProvisioningState:properties.provisioningState}" `
  --output table
20. Create Temporary Container App
az containerapp create `
  --name ca-az104-kv-test `
  --resource-group rg-az104-identity-05 `
  --environment cae-az104-id05 `
  --image mcr.microsoft.com/k8se/quickstart:latest `
  --target-port 80 `
  --ingress external `
  --user-assigned $identity05Id `
  --min-replicas 1 `
  --max-replicas 1 `
  --output table
21. Verify Managed Identity Attachment
az containerapp show `
  --name ca-az104-kv-test `
  --resource-group rg-az104-identity-05 `
  --query "{Name:name,ProvisioningState:properties.provisioningState,IdentityType:identity.type,UserAssignedIdentities:identity.userAssignedIdentities}" `
  --output json

Expected identity type:

UserAssigned
22. Verify Container App Identity
az containerapp show `
  --name ca-az104-kv-test `
  --resource-group rg-az104-identity-05 `
  --query "{Name:name,IdentityType:identity.type,Identity:identity.userAssignedIdentities}" `
  --output json
23. Configure Key Vault Secret Reference

Get the secret URI:

$secretUri = az keyvault secret show `
  --vault-name kvaz104id05 `
  --name "az104-lab-secret" `
  --query id `
  --output tsv


$secretUri

Configure the Container App secret reference:

az containerapp secret set `
  --name ca-az104-kv-test `
  --resource-group rg-az104-identity-05 `
  --secrets "lab-secret=keyvaultref:$secretUri,identityref:$identity05Id" `
  --output table

Verify:

az containerapp show `
  --name ca-az104-kv-test `
  --resource-group rg-az104-identity-05 `
  --query "properties.configuration.secrets[].{Name:name,KeyVaultUrl:keyVaultUrl,Identity:identity}" `
  --output json

The output should show the Key Vault reference and managed identity.

The secret value should not be exposed.

24. Final Secret Verification

Return to the normal Azure user account:

az login

Verify:

az account show `
  --query "{Subscription:name,User:user.name,TenantId:tenantId}" `
  --output table

Then verify secret metadata:

az keyvault secret show `
  --vault-name kvaz104id05 `
  --name "az104-lab-secret" `
  --query "{Name:name,Version:id,Enabled:attributes.enabled,Expires:attributes.expires}" `
  --output table
25. Final Container App Verification
az containerapp show `
  --name ca-az104-kv-test `
  --resource-group rg-az104-identity-05 `
  --query "properties.configuration.secrets[].{Name:name,KeyVaultUrl:keyVaultUrl,Identity:identity}" `
  --output json
26. Delete Temporary Container App
az containerapp delete `
  --name ca-az104-kv-test `
  --resource-group rg-az104-identity-05 `
  --yes

Verify:

az containerapp show `
  --name ca-az104-kv-test `
  --resource-group rg-az104-identity-05

Expected:

ResourceNotFound
27. Delete Container Apps Environment
az containerapp env delete `
  --name cae-az104-id05 `
  --resource-group rg-az104-identity-05 `
  --yes

Expected:

Containerapp environment successfully deleted
28. Delete Module Resource Group
az group delete `
  --name rg-az104-identity-05 `
  --yes

Verify:

az group show `
  --name rg-az104-identity-05

Expected:

(ResourceGroupNotFound)

This confirms cleanup.

Security Notes

Never commit:

Actual secret values
Client secrets
Passwords
Access tokens
Private keys

Use metadata-only queries when creating screenshots or documentation.

For production workloads, prefer:

Managed Identity
        +
Azure RBAC
        +
Key Vault

over embedding long-lived credentials in application configuration.