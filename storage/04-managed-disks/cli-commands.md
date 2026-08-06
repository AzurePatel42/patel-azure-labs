# Azure Managed Disks - CLI Commands

## Objective

Use Azure CLI to inspect, create, validate, and delete Azure Managed Disk resources.

The actual Managed Disk deployment for this lab was performed through the Azure Portal. The commands below document the equivalent Azure CLI workflow and provide additional administration practice for AZ-104.

---

## Prerequisites

Azure CLI must be installed and authenticated.

Verify the Azure CLI installation:

```powershell
az version

Verify the current Azure account:

az account show

List available subscriptions:

az account list --output table

Set the lab subscription:

az account set --subscription "patel-platform-service-template"

Verify the active subscription:

az account show --output table
Resource Group

List Resource Groups:

az group list --output table

Show the lab Resource Group:

az group show `
  --name rg-ppst-storage-lab `
  --output table
Create a Managed Disk

The following command creates an empty Managed Disk:

az disk create `
  --resource-group rg-ppst-storage-lab `
  --name disk-managed-lab-01 `
  --size-gb 32 `
  --sku StandardSSD_LRS `
  --output table
Parameters
Parameter	Purpose
--resource-group	Resource Group containing the disk
--name	Name of the Managed Disk
--size-gb	Disk capacity in GB
--sku	Managed Disk SKU
--output table	Displays readable table output

The actual lab deployment was completed through the Azure Portal. This command demonstrates the equivalent Azure CLI creation workflow.

List Managed Disks

List Managed Disks in the lab Resource Group:

az disk list `
  --resource-group rg-ppst-storage-lab `
  --output table

List all Managed Disks in the active subscription:

az disk list `
  --output table
Show a Managed Disk

Display the complete Managed Disk configuration:

az disk show `
  --resource-group rg-ppst-storage-lab `
  --name disk-managed-lab-01

Display the disk using table format:

az disk show `
  --resource-group rg-ppst-storage-lab `
  --name disk-managed-lab-01 `
  --output table
Get Disk Resource ID

Retrieve the Managed Disk resource ID:

az disk show `
  --resource-group rg-ppst-storage-lab `
  --name disk-managed-lab-01 `
  --query id `
  --output tsv
Get Disk Size

Retrieve the provisioned disk size:

az disk show `
  --resource-group rg-ppst-storage-lab `
  --name disk-managed-lab-01 `
  --query diskSizeGb
Get Disk SKU

Retrieve the Managed Disk SKU:

az disk show `
  --resource-group rg-ppst-storage-lab `
  --name disk-managed-lab-01 `
  --query sku.name
Get Disk Provisioning State

Check the disk provisioning state:

az disk show `
  --resource-group rg-ppst-storage-lab `
  --name disk-managed-lab-01 `
  --query provisioningState

A successfully created disk should report:

Succeeded
Get Disk Location

Retrieve the Azure region:

az disk show `
  --resource-group rg-ppst-storage-lab `
  --name disk-managed-lab-01 `
  --query location
Get Disk Encryption Information

Display encryption configuration:

az disk show `
  --resource-group rg-ppst-storage-lab `
  --name disk-managed-lab-01 `
  --query encryption
Get Disk State

Retrieve the disk state:

az disk show `
  --resource-group rg-ppst-storage-lab `
  --name disk-managed-lab-01 `
  --query diskState
Delete a Managed Disk

If the Managed Disk is no longer required:

az disk delete `
  --resource-group rg-ppst-storage-lab `
  --name disk-managed-lab-01 `
  --yes

Verify that the disk has been removed:

az disk list `
  --resource-group rg-ppst-storage-lab `
  --output table

Always verify the Resource Group and disk name before deleting Azure resources.

Useful Administration Commands

List all Managed Disks:

az disk list --output table

Get complete Managed Disk properties:

az disk show `
  --resource-group rg-ppst-storage-lab `
  --name disk-managed-lab-01 `
  --output json

Retrieve only selected properties:

az disk show `
  --resource-group rg-ppst-storage-lab `
  --name disk-managed-lab-01 `
  --query "{Name:name, SizeGB:diskSizeGb, SKU:sku.name, Location:location, State:diskState}"
Azure CLI Managed Disk Lifecycle

The basic Managed Disk lifecycle can be represented as:

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

The primary Azure CLI commands are:

az disk create
az disk list
az disk show
az disk delete
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