# Bicep Storage Account Lab

## Objective

Deploy an Azure Storage Account using Bicep.

## What I Built

The Bicep template creates:

- Resource type: Microsoft.Storage/storageAccounts
- API version: 2023-05-01
- Kind: StorageV2
- SKU: Standard_LRS
- Location: eastus

## Files

- main.bicep - Bicep infrastructure template
- main.bicepparam - deployment parameters
- failure-lab.bicep - intentional failure template
- failure-lab.bicepparam - parameters for the failure lab

## Deployment

Resource group:

rg-az104-storage-01

Storage account:

patelbicepstorage001

Deployment command:

az deployment group create `
  --resource-group rg-az104-storage-01 `
  --template-file .\main.bicep `
  --parameters .\main.bicepparam

## Verification

The deployed Storage Account was independently verified with Azure CLI.

Result:

Name: patelbicepstorage001
Location: eastus
SKU: Standard_LRS
Kind: StorageV2
ProvisioningState: Succeeded

## Intentional Failure

I created a separate failure template and changed the Storage Account SKU to:

Invalid_SKU

The first validation attempt exposed another Bicep-specific issue because the original parameter file contained:

using './main.bicep'

while the deployment was using:

failure-lab.bicep

I created a separate parameter file:

failure-lab.bicepparam

with:

using './failure-lab.bicep'

After correcting that relationship, validation succeeded.

The intentionally invalid Storage Account configuration then failed during actual deployment with:

DeploymentFailed

and:

InvalidAccountType

## Troubleshooting

I investigated the deployment operation using:

az deployment operation group list `
  --resource-group rg-az104-storage-01 `
  --name failure-lab `
  --query "[].properties" `
  -o json

The operation showed:

- Provisioning state: Failed
- Status code: BadRequest
- Resource type: Microsoft.Storage/storageAccounts
- Resource name: patelbicepfailure001
- Error code: InvalidAccountType
- Error message: AccountType Invalid_SKU is invalid

## Recovery

I changed the SKU in failure-lab.bicep back to:

Standard_LRS

I redeployed the template successfully.

The repaired Storage Account was independently verified:

Name: patelbicepfailure001
Location: eastus
SKU: Standard_LRS
Kind: StorageV2
ProvisioningState: Succeeded

## What I Learned

Bicep provides a simpler authoring language for Azure infrastructure while still using the Azure Resource Manager deployment model.

The deployment flow is:

Bicep
  |
ARM template
  |
Azure Resource Manager
  |
Azure Resource Provider
  |
Azure resource

I also learned that a .bicepparam file is associated with a Bicep file through its using declaration.

The failure exercise demonstrated that successful validation does not guarantee successful resource provisioning.

## ARM vs Bicep

The same Storage Account infrastructure was implemented in both ARM JSON and Bicep.

ARM:

- More verbose JSON syntax
- Explicit ARM template structure
- More difficult to read and maintain

Bicep:

- Cleaner syntax
- Stronger readability
- Parameters are easier to express
- Resources are easier to understand
- Compiles to ARM for Azure deployment

## AZ-104 Connection

This lab reinforces:

- Azure Storage Accounts
- Resource Groups
- Azure Resource Manager
- Azure CLI
- Storage SKUs
- Infrastructure as Code
- Deployment validation
- Deployment troubleshooting
- Resource verification

## Next

Next I will implement the same Storage Account infrastructure using Terraform and compare ARM, Bicep, and Terraform.
