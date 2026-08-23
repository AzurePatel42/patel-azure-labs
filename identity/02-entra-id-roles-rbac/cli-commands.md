
---

# 2. `cli-commands.md`

Use this as the actual command record.

```markdown
# AZ-104 Identity Module 02 — CLI Commands

## Azure Context

Subscription:

```text
patel-platform-service-template



Subscription ID:

39896053-eeca-4bfb-99ca-cf10b0494eec

Tenant ID:

21da5ae3-adeb-4df2-8b96-488c5ed06672
1. Create Resource Group
az group create `
  --name rg-az104-identity-02 `
  --location eastus `
  --output table
2. Verify Resource Group
az group show `
  --name rg-az104-identity-02 `
  --query "{Name:name,Location:location,ProvisioningState:properties.provisioningState}" `
  --output table
3. Create Storage Account
az storage account create `
  --name staz104idrbac02 `
  --resource-group rg-az104-identity-02 `
  --location eastus `
  --sku Standard_LRS `
  --output table
4. Verify Storage Account
az storage account show `
  --name staz104idrbac02 `
  --resource-group rg-az104-identity-02 `
  --query "{Name:name,Location:location,ProvisioningState:provisioningState,SKU:sku.name}" `
  --output table
5. Identify Signed-In User
az ad signed-in-user show `
  --query "{Name:displayName,Id:id}" `
  --output table
6. Assign Reader to Administrator
az role assignment create `
  --assignee-object-id "0563a187-761f-4cbe-83d7-cbf337d0be33" `
  --assignee-principal-type User `
  --role "Reader" `
  --scope "/subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec/resourceGroups/rg-az104-identity-02" `
  --output table
7. Verify Reader Assignment
az role assignment list `
  --scope "/subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec/resourceGroups/rg-az104-identity-02" `
  --query "[].{Role:roleDefinitionName,Principal:principalName,Type:principalType,Scope:scope}" `
  --output table
8. Inspect Azure RBAC Assignments
az role assignment list `
  --assignee-object-id "0563a187-761f-4cbe-83d7-cbf337d0be33" `
  --all `
  --query "[].{Role:roleDefinitionName,Scope:scope}" `
  --output table
9. Test Resource Read
az storage account show `
  --name staz104idrbac02 `
  --resource-group rg-az104-identity-02 `
  --query "{Name:name,Location:location,SKU:sku.name}" `
  --output table
10. Test Resource Modification
az storage account update `
  --name staz104idrbac02 `
  --resource-group rg-az104-identity-02 `
  --tags Lab=RBAC02 Test=Reader `
  --output table

The operation succeeded because the administrator also had Owner permissions at subscription scope.

This demonstrated cumulative RBAC permissions and inheritance.

11. Create Test User
az ad user create `
  --display-name "AZ104 RBAC Test User" `
  --user-principal-name "az104-rbac-test@patel42maheshoutlook.onmicrosoft.com" `
  --password "TEMPORARY_PASSWORD" `
  --force-change-password-next-sign-in true `
  --output table

The real temporary password was not stored in this documentation.

12. Get Test User Object ID
az ad user show `
  --id "az104-rbac-test@patel42maheshoutlook.onmicrosoft.com" `
  --query "id" `
  --output tsv
13. Assign Reader to Test User
az role assignment create `
  --assignee-object-id "6313f0be-1228-456f-811c-c9110771fcf8" `
  --assignee-principal-type User `
  --role "Reader" `
  --scope "/subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec/resourceGroups/rg-az104-identity-02" `
  --output table
14. Verify Test User Reader
az role assignment list `
  --assignee-object-id "6313f0be-1228-456f-811c-c9110771fcf8" `
  --all `
  --query "[].{Role:roleDefinitionName,Scope:scope}" `
  --output table
15. Assign Contributor at Storage Account Scope
az role assignment create `
  --assignee-object-id "6313f0be-1228-456f-811c-c9110771fcf8" `
  --assignee-principal-type User `
  --role "Contributor" `
  --scope "/subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec/resourceGroups/rg-az104-identity-02/providers/Microsoft.Storage/storageAccounts/staz104idrbac02" `
  --output table
16. Verify Reader + Contributor
az role assignment list `
  --assignee-object-id "6313f0be-1228-456f-811c-c9110771fcf8" `
  --all `
  --query "[].{Role:roleDefinitionName,Scope:scope}" `
  --output table
17. Inspect Contributor Role
az role definition list `
  --name "Contributor" `
  --query "[].{Name:roleName,Description:description,Actions:permissions[0].actions,NotActions:permissions[0].notActions}" `
  --output json
18. Inspect Owner Role
az role definition list `
  --name "Owner" `
  --query "[].{Name:roleName,Description:description,Actions:permissions[0].actions,NotActions:permissions[0].notActions}" `
  --output json
19. Inspect Reader Role
az role definition list `
  --name "Reader" `
  --query "[].{Name:roleName,Description:description,Actions:permissions[0].actions,NotActions:permissions[0].notActions}" `
  --output json
20. Inspect Entra Directory Roles
az rest `
  --method GET `
  --url "https://graph.microsoft.com/v1.0/roleManagement/directory/roleAssignments?`$filter=principalId eq '0563a187-761f-4cbe-83d7-cbf337d0be33'" `
  --query "value[].{PrincipalId:principalId,RoleDefinitionId:roleDefinitionId,DirectoryScopeId:directoryScopeId}" `
  --output table

Resolve role names:

az rest `
  --method GET `
  --url "https://graph.microsoft.com/v1.0/roleManagement/directory/roleDefinitions" `
  --query "value[?id=='62e90394-69f5-4237-9190-012177145e10' || id=='9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3' || id=='d2562ede-74db-457e-a7b6-544e236ebb61'].{Role:displayName,Id:id,Description:description}" `
  --output table

Observed Entra roles:

Global Administrator
Application Administrator
AI Administrator
21. Explicit Tenant Login
az login --tenant 21da5ae3-adeb-4df2-8b96-488c5ed06672

Verify:

az account show `
  --query "{User:user.name,Subscription:name,SubscriptionId:id,TenantId:tenantId}" `
  --output table
Cleanup Commands
22. Remove Test User Contributor Assignment
az role assignment delete `
  --assignee-object-id "6313f0be-1228-456f-811c-c9110771fcf8" `
  --role "Contributor" `
  --scope "/subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec/resourceGroups/rg-az104-identity-02/providers/Microsoft.Storage/storageAccounts/staz104idrbac02"
23. Remove Test User Reader Assignment
az role assignment delete `
  --assignee-object-id "6313f0be-1228-456f-811c-c9110771fcf8" `
  --role "Reader" `
  --scope "/subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec/resourceGroups/rg-az104-identity-02"
24. Delete Test User
az ad user delete `
  --id "az104-rbac-test@patel42maheshoutlook.onmicrosoft.com"
25. Remove Administrator's Temporary Reader Assignment
az role assignment delete `
  --assignee-object-id "0563a187-761f-4cbe-83d7-cbf337d0be33" `
  --role "Reader" `
  --scope "/subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec/resourceGroups/rg-az104-identity-02"
26. Delete Storage Account
az storage account delete `
  --name staz104idrbac02 `
  --resource-group rg-az104-identity-02 `
  --yes
27. Delete Resource Group
az group delete `
  --name rg-az104-identity-02 `
  --yes
28. Final RBAC Safety Check
az role assignment list `
  --assignee-object-id "0563a187-761f-4cbe-83d7-cbf337d0be33" `
  --all `
  --query "[].{Role:roleDefinitionName,Scope:scope}" `
  --output table

Expected remaining assignments:

Owner → Subscription
Owner → Subscription

These were pre-existing assignments and were not removed by the lab.