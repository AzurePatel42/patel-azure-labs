# Azure Managed Disks - CLI Commands

## Objective

Use Azure CLI to inspect, create, validate, and delete Azure Managed Disk resources.

The primary Managed Disk deployment for this lab will be performed through the Azure Portal. Azure CLI will then be used for administration and validation.

---

## Lab Environment

| Setting | Value |
|---|---|
| Resource Group | `rg-az104-storage-01` |
| Region | `eastus` |
| Managed Disk | `disk-az104-managed-01` |
| Disk Size | `32 GiB` |
| Disk SKU | `Standard SSD` |

---

## Prerequisites

Azure CLI must be installed and authenticated.

Verify Azure CLI:

```powershell
az version


Verify the current Azure account:

az account show `
  --query "{User:user.name,Subscription:id}" `
  --output table
Verify Resource Group

Show the lab Resource Group:

az group show `
  --name rg-az104-storage-01 `
  --output table
List Managed Disks

List Managed Disks in the lab Resource Group:

az disk list `
  --resource-group rg-az104-storage-01 `
  --output table

List all Managed Disks visible to the active subscription:

az disk list `
  --output table
Create a Managed Disk with Azure CLI

The primary lab deployment is performed through the Azure Portal.

The following command demonstrates the equivalent Azure CLI creation workflow:

az disk create `
  --resource-group rg-az104-storage-01 `
  --name disk-az104-managed-01 `
  --size-gb 32 `
  --sku StandardSSD_LRS `
  --location eastus `
  --output table
Important

Do not run the CLI creation command if the Managed Disk has already been created through the Portal.

Otherwise, Azure CLI may return an error because the resource already exists.

Show Managed Disk

Display the complete Managed Disk configuration:

az disk show `
  --resource-group rg-az104-storage-01 `
  --name disk-az104-managed-01

Display the disk using table format:

az disk show `
  --resource-group rg-az104-storage-01 `
  --name disk-az104-managed-01 `
  --output table
Get Disk Resource ID

Retrieve the Managed Disk resource ID:

az disk show `
  --resource-group rg-az104-storage-01 `
  --name disk-az104-managed-01 `
  --query id `
  --output tsv
Get Disk Size

Retrieve the provisioned disk size:

az disk show `
  --resource-group rg-az104-storage-01 `
  --name disk-az104-managed-01 `
  --query diskSizeGb `
  --output tsv
Get Disk SKU

Retrieve the Managed Disk SKU:

az disk show `
  --resource-group rg-az104-storage-01 `
  --name disk-az104-managed-01 `
  --query sku.name `
  --output tsv
Get Disk Location

Retrieve the Azure region:

az disk show `
  --resource-group rg-az104-storage-01 `
  --name disk-az104-managed-01 `
  --query location `
  --output tsv
Get Disk Provisioning State

Check the disk provisioning state:

az disk show `
  --resource-group rg-az104-storage-01 `
  --name disk-az104-managed-01 `
  --query provisioningState `
  --output tsv

A successfully created Managed Disk should report:

Succeeded
Get Disk State

Retrieve the current disk state:

az disk show `
  --resource-group rg-az104-storage-01 `
  --name disk-az104-managed-01 `
  --query diskState `
  --output tsv
Get Encryption Information

Display the Managed Disk encryption configuration:

az disk show `
  --resource-group rg-az104-storage-01 `
  --name disk-az104-managed-01 `
  --query encryption `
  --output json
Get Selected Disk Properties

Display important properties in one command:

az disk show `
  --resource-group rg-az104-storage-01 `
  --name disk-az104-managed-01 `
  --query "{Name:name,SizeGB:diskSizeGb,SKU:sku.name,Location:location,ProvisioningState:provisioningState,DiskState:diskState}" `
  --output table
Get Disk Tags

Display Managed Disk tags:

az disk show `
  --resource-group rg-az104-storage-01 `
  --name disk-az104-managed-01 `
  --query tags `
  --output json
Get Disk Zone Information

Display the availability zone configuration:

az disk show `
  --resource-group rg-az104-storage-01 `
  --name disk-az104-managed-01 `
  --query zones `
  --output json
Azure CLI Managed Disk Lifecycle

The basic Managed Disk lifecycle is:

Create
  |
  v
List
  |
  v
Show
  |
  v
Validate
  |
  v
Attach to VM
  |
  v
Use
  |
  v
Detach
  |
  v
Delete

The primary commands are:

az disk create
az disk list
az disk show
az disk delete
Delete a Managed Disk

If the Managed Disk is no longer required:

az disk delete `
  --resource-group rg-az104-storage-01 `
  --name disk-az104-managed-01 `
  --yes
Verify deletion
az disk list `
  --resource-group rg-az104-storage-01 `
  --output table

If the disk was successfully deleted, it should no longer appear in the Resource Group's Managed Disk list.

Important

Always verify:

Resource Group
Disk name
Subscription

before deleting Azure resources.

Useful Administration Commands

List all Managed Disks:

az disk list --output table

Get complete Managed Disk properties:

az disk show `
  --resource-group rg-az104-storage-01 `
  --name disk-az104-managed-01 `
  --output json

Retrieve selected properties:

az disk show `
  --resource-group rg-az104-storage-01 `
  --name disk-az104-managed-01 `
  --query "{Name:name,SizeGB:diskSizeGb,SKU:sku.name,Location:location,State:diskState}" `
  --output table
AZ-104 CLI Takeaways

Important commands to remember:

Create
az disk create
List
az disk list
Inspect
az disk show
Delete
az disk delete

These commands provide the foundation for managing Azure Managed Disks through Azure CLI.

Lab Validation

The final CLI validation should confirm:

Resource Group
Managed Disk Name
Disk Size
Disk SKU
Location
Provisioning State
Disk State
Encryption

A successful validation demonstrates that the Managed Disk exists and is configured correctly in the intended Azure environment.