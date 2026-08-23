# Module 03 — Azure CLI Commands
## Managed Identities

This document contains the working Azure CLI commands used during the AZ-104 Managed Identities lab.

> All commands use PowerShell syntax.

---

# 1. Login and Subscription Verification

Verify the active Azure account:

```powershell
az account show `
  --query "{User:user.name,Subscription:name,SubscriptionId:id,TenantId:tenantId}" `
  --output table



2. Create Resource Group
az group create `
  --name rg-az104-identity-03 `
  --location eastus `
  --output table

Verify:

az group show `
  --name rg-az104-identity-03 `
  --query "{Name:name,Location:location,ProvisioningState:properties.provisioningState}" `
  --output table
3. Create Storage Account
az storage account create `
  --name staz104idmi03 `
  --resource-group rg-az104-identity-03 `
  --location eastus `
  --sku Standard_LRS `
  --output table

Verify:

az storage account show `
  --name staz104idmi03 `
  --resource-group rg-az104-identity-03 `
  --query "{Name:name,Location:location,SKU:sku.name,ProvisioningState:provisioningState}" `
  --output table
4. Enable System-Assigned Managed Identity
az storage account update `
  --name staz104idmi03 `
  --resource-group rg-az104-identity-03 `
  --assign-identity `
  --output table

Verify:

az storage account show `
  --name staz104idmi03 `
  --resource-group rg-az104-identity-03 `
  --query "{Name:name,PrincipalId:identity.principalId,TenantId:identity.tenantId,IdentityType:identity.type}" `
  --output table

Expected identity type:

SystemAssigned
5. Query the Managed Identity Service Principal

Use the system-assigned identity's Principal ID:

az ad sp show `
  --id "fdc8d71b-241c-4ada-8203-c02837da0ca5" `
  --query "{DisplayName:displayName,AppId:appId,ObjectId:id,ServicePrincipalType:servicePrincipalType}" `
  --output table

This demonstrates the relationship between the managed identity and its Microsoft Entra service principal.

6. Assign Storage Blob Data Reader to System Identity
az role assignment create `
  --assignee-object-id "fdc8d71b-241c-4ada-8203-c02837da0ca5" `
  --assignee-principal-type ServicePrincipal `
  --role "Storage Blob Data Reader" `
  --scope "/subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec/resourceGroups/rg-az104-identity-03/providers/Microsoft.Storage/storageAccounts/staz104idmi03" `
  --output table

Verify:

az role assignment list `
  --assignee-object-id "fdc8d71b-241c-4ada-8203-c02837da0ca5" `
  --all `
  --query "[].{Role:roleDefinitionName,Scope:scope,PrincipalType:principalType}" `
  --output table
7. Inspect Storage Blob Data Reader
az role definition list `
  --name "Storage Blob Data Reader" `
  --query "[].{Name:roleName,Description:description,Actions:permissions[0].actions,DataActions:permissions[0].dataActions,NotActions:permissions[0].notActions,NotDataActions:permissions[0].notDataActions}" `
  --output json

Important permissions observed in the lab:

Actions:
- Microsoft.Storage/storageAccounts/blobServices/containers/read
- Microsoft.Storage/storageAccounts/blobServices/generateUserDelegationKey/action


DataActions:
- Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read
8. Verify System Identity and RBAC Together
az storage account show `
  --name staz104idmi03 `
  --resource-group rg-az104-identity-03 `
  --query "{Name:name,IdentityType:identity.type,PrincipalId:identity.principalId,TenantId:identity.tenantId}" `
  --output table

Then:

az role assignment list `
  --assignee-object-id "fdc8d71b-241c-4ada-8203-c02837da0ca5" `
  --all `
  --query "[].{Role:roleDefinitionName,Scope:scope,PrincipalType:principalType}" `
  --output table
9. Create User-Assigned Managed Identity
az identity create `
  --name id-az104-identity-03 `
  --resource-group rg-az104-identity-03 `
  --location eastus `
  --output table

Verify:

az identity show `
  --name id-az104-identity-03 `
  --resource-group rg-az104-identity-03 `
  --query "{Name:name,PrincipalId:principalId,ClientId:clientId,TenantId:tenantId,Location:location}" `
  --output table

Identity created during the lab:

Name:
id-az104-identity-03


Principal ID:
aa5c5a7f-1d0f-4aea-a8f3-a1a85c304748


Client ID:
59c36ae6-e38f-4de5-acd5-74db55e59587
10. Store the User-Assigned Identity Resource ID
$identityId = az identity show `
  --name id-az104-identity-03 `
  --resource-group rg-az104-identity-03 `
  --query id `
  --output tsv

Verify:

$identityId
11. Assign RBAC to User-Assigned Identity
az role assignment create `
  --assignee-object-id "aa5c5a7f-1d0f-4aea-a8f3-a1a85c304748" `
  --assignee-principal-type ServicePrincipal `
  --role "Storage Blob Data Reader" `
  --scope "/subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec/resourceGroups/rg-az104-identity-03/providers/Microsoft.Storage/storageAccounts/staz104idmi03" `
  --output table

Verify:

az role assignment list `
  --assignee-object-id "aa5c5a7f-1d0f-4aea-a8f3-a1a85c304748" `
  --all `
  --query "[].{Role:roleDefinitionName,Scope:scope,PrincipalType:principalType}" `
  --output table
12. Create Second Storage Account

A second storage account was used to demonstrate a resource with a user-assigned identity independently from the original system-assigned identity example.

az storage account create `
  --name staz104idmi032 `
  --resource-group rg-az104-identity-03 `
  --location eastus `
  --sku Standard_LRS `
  --output table
13. Attach User-Assigned Identity to Storage Account

The working Storage Account command was:

az storage account update `
  --name staz104idmi032 `
  --resource-group rg-az104-identity-03 `
  --identity-type UserAssigned `
  --user-identity-id $identityId `
  --output table

Verify:

az storage account show `
  --name staz104idmi032 `
  --resource-group rg-az104-identity-03 `
  --query "{Name:name,IdentityType:identity.type,UserAssignedIds:identity.userAssignedIdentities}" `
  --output json

Expected:

IdentityType:
UserAssigned

The returned identity information included:

Client ID:
59c36ae6-e38f-4de5-acd5-74db55e59587


Principal ID:
aa5c5a7f-1d0f-4aea-a8f3-a1a85c304748


Tenant ID:
21da5ae3-adeb-4df2-8b96-488c5ed06672
14. Assign RBAC at Correct User-Assigned Resource Scope

The user-assigned identity was assigned Storage Blob Data Reader on the second storage account:

az role assignment create `
  --assignee-object-id "aa5c5a7f-1d0f-4aea-a8f3-a1a85c304748" `
  --assignee-principal-type ServicePrincipal `
  --role "Storage Blob Data Reader" `
  --scope "/subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec/resourceGroups/rg-az104-identity-03/providers/Microsoft.Storage/storageAccounts/staz104idmi032" `
  --output table

Verify:

az role assignment list `
  --assignee-object-id "aa5c5a7f-1d0f-4aea-a8f3-a1a85c304748" `
  --all `
  --query "[].{Role:roleDefinitionName,Scope:scope,PrincipalType:principalType}" `
  --output table
15. Remove Unnecessary RBAC Assignment

The earlier assignment to the original storage account was removed so the final user-assigned identity configuration contained only the intended resource-level assignment.

az role assignment delete `
  --assignee-object-id "aa5c5a7f-1d0f-4aea-a8f3-a1a85c304748" `
  --role "Storage Blob Data Reader" `
  --scope "/subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec/resourceGroups/rg-az104-identity-03/providers/Microsoft.Storage/storageAccounts/staz104idmi03"

Final verification:

az role assignment list `
  --assignee-object-id "aa5c5a7f-1d0f-4aea-a8f3-a1a85c304748" `
  --all `
  --query "[].{Role:roleDefinitionName,Scope:scope,PrincipalType:principalType}" `
  --output table

Expected final assignment:

Storage Blob Data Reader
.../storageAccounts/staz104idmi032
16. Compare System-Assigned Identity
az storage account show `
  --name staz104idmi03 `
  --resource-group rg-az104-identity-03 `
  --query "{Resource:name,IdentityType:identity.type,PrincipalId:identity.principalId}" `
  --output table

Expected:

IdentityType:
SystemAssigned
17. Compare User-Assigned Identity
az storage account show `
  --name staz104idmi032 `
  --resource-group rg-az104-identity-03 `
  --query "{Resource:name,IdentityType:identity.type,UserAssignedIds:identity.userAssignedIdentities}" `
  --output json

Expected:

IdentityType:
UserAssigned
18. Cleanup

Delete the entire Module 03 resource group:

az group delete `
  --name rg-az104-identity-03 `
  --yes

Verify deletion:

az group show `
  --name rg-az104-identity-03

Expected result:

(ResourceGroupNotFound)
19. Troubleshooting Notes
Unsupported --user-assigned-identities

An initial Storage Account command attempted to use:

--user-assigned-identities

The Azure CLI returned:

unrecognized arguments

The command was not used further.

The working Storage Account-specific syntax was:

--identity-type UserAssigned
--user-identity-id $identityId
az resource update Identity Property Issue

An attempt was made to update the nested identity property using:

az resource update

The CLI interpreted the nested property path incorrectly.

The resource state was verified afterward and remained:

IdentityType:
SystemAssigned


UserAssignedIds:
null

No unintended change occurred.

The dedicated Storage Account command was then used successfully.

RBAC Scope Verification

The user-assigned identity initially had a role assignment against the first storage account.

The assignment was corrected so the final configuration used:

User-Assigned Identity
        |
        v
Storage Blob Data Reader
        |
        v
staz104idmi032

This reinforced the importance of verifying the complete RBAC tuple:

Principal
+
Role
+
Scope
20. PowerShell Best Practices Used

Use the PowerShell backtick for multiline Azure CLI commands:

az command `
  --argument value `
  --another-argument value `
  --output table

When a value is reused, store it in a variable:

$identityId = az identity show `
  --name id-az104-identity-03 `
  --resource-group rg-az104-identity-03 `
  --query id `
  --output tsv

Then reuse it:

--user-identity-id $identityId

Always verify Azure state after important operations.

21. Verification Pattern

The lab followed this operational pattern:

Create
  ↓
Configure
  ↓
Query
  ↓
Verify
  ↓
Capture Screenshot
  ↓
Continue

For RBAC:

Assign
  ↓
List Assignment
  ↓
Confirm Principal
  ↓
Confirm Role
  ↓
Confirm Scope

For managed identities:

Enable/Create Identity
        ↓
Get Principal ID
        ↓
Inspect Entra Service Principal
        ↓
Assign RBAC
        ↓
Verify Resource Configuration
Module 03 CLI Summary

The primary Azure CLI commands used were:

az account show
az group create
az group show
az storage account create
az storage account show
az storage account update
az identity create
az identity show
az ad sp show
az role assignment create
az role assignment list
az role assignment delete
az role definition list
az group delete