# ARM Storage Account Lab

## Objective

Deploy an Azure Storage Account using an ARM template.

## What I Built

The ARM template creates:

- Resource type: Microsoft.Storage/storageAccounts
- Kind: StorageV2
- SKU: Standard_LRS
- Location: eastus

## Files

- main.json - ARM infrastructure template
- parameters.json - deployment parameters
- failure-lab.json - intentional failure template
- failure-parameters.json - isolated failure-test parameters

## Deployment

Resource group:

rg-az104-storage-01

Storage account:

patelarmstorage001

Deployment command:

az deployment group create `
  --resource-group rg-az104-storage-01 `
  --template-file .\01-arm\01-storage-account\main.json `
  --parameters .\01-arm\01-storage-account\parameters.json

## Verification

The deployed storage account was independently verified with Azure CLI.

Expected result:

Name: patelarmstorage001
Location: eastus
SKU: Standard_LRS
Kind: StorageV2
ProvisioningState: Succeeded

## Failure Lab

I intentionally changed the Storage Account SKU to:

Invalid_SKU

ARM validation succeeded, but the actual deployment failed.

Azure returned:

DeploymentFailed

with the resource provider error:

InvalidAccountType

## Troubleshooting

I investigated the failed deployment using:

az deployment operation group list `
  --resource-group rg-az104-storage-01 `
  --name failure-lab `
  -o table

The operation identified the failed Storage Account resource and the InvalidAccountType error.

I then changed the SKU back to:

Standard_LRS

The deployment succeeded after the correction.

## What I Learned

This lab demonstrated the ARM deployment lifecycle:

1. Create template
2. Create parameters
3. Validate
4. Deploy
5. Verify
6. Introduce failure
7. Investigate
8. Fix
9. Redeploy
10. Verify again

The important troubleshooting lesson was that a successful ARM validation does not guarantee that the resource provider will accept the configuration during deployment.

## AZ-104 Connection

This lab reinforces:

- Azure Storage Accounts
- Resource Groups
- Azure Resource Manager
- Azure CLI
- Storage SKUs
- Deployment validation
- Deployment troubleshooting
- Resource verification

## Next

Next I will build the same Storage Account using Bicep and compare the implementation with ARM JSON.
