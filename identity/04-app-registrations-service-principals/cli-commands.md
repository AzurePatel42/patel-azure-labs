@'
# Module 04 CLI Commands

## Subscription Baseline

az account show `
  --query "{Subscription:name,SubscriptionId:id,TenantId:tenantId,User:user.name}" `
  --output table

## Application Object

az ad app show `
  --id "37d2f223-2725-4c4d-8227-133ccd6a3d2a" `
  --output table

## Service Principal

az ad sp show `
  --id "da1d7b12-bb81-4056-b750-42c7906f23bc" `
  --output table

## API Permissions

az ad app permission list `
  --id "37d2f223-2725-4c4d-8227-133ccd6a3d2a" `
  --output json

## Add Microsoft Graph User.Read

az ad app permission add `
  --id "37d2f223-2725-4c4d-8227-133ccd6a3d2a" `
  --api "00000003-0000-0000-c000-000000000000" `
  --api-permissions "e1fe6dd8-ba31-4d61-89e7-88639da4683d=Scope"

## Grant Admin Consent

az ad app permission admin-consent `
  --id "37d2f223-2725-4c4d-8227-133ccd6a3d2a"

## Verify Grants

az ad app permission list-grants `
  --id "37d2f223-2725-4c4d-8227-133ccd6a3d2a" `
  --output table

## Inspect Client Credentials

az ad app credential list `
  --id "37d2f223-2725-4c4d-8227-133ccd6a3d2a" `
  --output table

## Create Lab Client Secret

az ad app credential reset `
  --id "37d2f223-2725-4c4d-8227-133ccd6a3d2a" `
  --display-name "az104-module04-lab-secret" `
  --years 0 `
  --append

Never store the returned secret value in Git.

## Temporary Resource Group

az group create `
  --name rg-az104-identity-04 `
  --location eastus `
  --output table

## Temporary Storage Account

az storage account create `
  --name staz104idapp04 `
  --resource-group rg-az104-identity-04 `
  --location eastus `
  --sku Standard_LRS `
  --output table

## Get Storage Resource ID

$storageId = az storage account show `
  --name staz104idapp04 `
  --resource-group rg-az104-identity-04 `
  --query id `
  --output tsv

## Assign Reader RBAC

az role assignment create `
  --assignee-object-id "da1d7b12-bb81-4056-b750-42c7906f23bc" `
  --assignee-principal-type ServicePrincipal `
  --role "Reader" `
  --scope $storageId `
  --output table

## Verify RBAC

az role assignment list `
  --assignee-object-id "da1d7b12-bb81-4056-b750-42c7906f23bc" `
  --all `
  --query "[].{Role:roleDefinitionName,Scope:scope,PrincipalType:principalType}" `
  --output table

## Inspect Reader Role

az role definition list `
  --name "Reader" `
  --query "[].{Name:roleName,Description:description,Actions:permissions[0].actions,DataActions:permissions[0].dataActions}" `
  --output json

## Remove RBAC

az role assignment delete `
  --assignee-object-id "da1d7b12-bb81-4056-b750-42c7906f23bc" `
  --role "Reader" `
  --scope $storageId

## Delete Temporary Resource Group

az group delete `
  --name rg-az104-identity-04 `
  --yes

## Delete Lab Secret

az ad app credential delete `
  --id "37d2f223-2725-4c4d-8227-133ccd6a3d2a" `
  --key-id "a74d7ae0-b7e1-496e-a82d-0a2cad936418"

## Final Credential Verification

az ad app credential list `
  --id "37d2f223-2725-4c4d-8227-133ccd6a3d2a" `
  --output table

## Final Permission Verification

az ad app permission list `
  --id "37d2f223-2725-4c4d-8227-133ccd6a3d2a" `
  --output json

az ad app permission list-grants `
  --id "37d2f223-2725-4c4d-8227-133ccd6a3d2a" `
  --output table
'@ | Set-Content .\cli-commands.md