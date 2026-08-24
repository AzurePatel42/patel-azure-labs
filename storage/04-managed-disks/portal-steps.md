# Azure Managed Disks - Portal Steps

## Objective

Create and validate an Azure Managed Disk using the Azure Portal.

The lab uses the existing AZ-104 Storage Resource Group:

```text
rg-az104-storage-01


Step 1 - Verify the Azure Environment

Sign in to the Azure Portal.

Open:

Resource Groups

Locate:

rg-az104-storage-01

Confirm the Resource Group exists before creating the Managed Disk.

Screenshot
screenshots/00-managed-disk-environment-inventory.png
Step 2 - Open Managed Disks

From the Azure Portal:

Select:

Create a resource

Search for:

Managed Disks

Select:

Managed Disks

Start the Managed Disk creation workflow.

Step 3 - Configure Basic Settings

Configure the Managed Disk.

Use:

Setting	Value
Subscription	Current AZ-104 subscription
Resource Group	rg-az104-storage-01
Region	eastus
Disk Name	disk-az104-managed-01
Source Type	None

The disk will be created as an empty Managed Disk.

Step 4 - Configure Disk Size and SKU

Configure the disk capacity and performance tier.

Use:

Size: 32 GiB
SKU: Standard SSD

Review the available disk SKUs and understand that different tiers provide different performance and cost characteristics.

Common Managed Disk options include:

Standard HDD
Standard SSD
Premium SSD
Premium SSD v2
Ultra Disk

For this introductory AZ-104 lab, use:

Standard SSD
Screenshot
screenshots/02-create-managed-disk.png
Step 5 - Review Encryption

Open the:

Encryption

section.

Review the available encryption configuration.

For this introductory lab, use the default platform-managed encryption configuration.

Azure Managed Disks support encryption at rest using:

Platform-managed keys
Customer-managed keys

Platform-managed keys provide a simple default configuration.

Step 6 - Review Networking

Open the:

Networking

section.

Review the available networking configuration.

For this introductory lab:

Review the available options
Retain the appropriate default configuration
Do not enable advanced options unless required

Advanced disk access and security scenarios can be explored in later labs.

Step 7 - Review Advanced Settings

Open:

Advanced

Review the available options.

For this introductory lab, retain the appropriate default configuration.

Advanced Managed Disk capabilities may include:

Shared disks
Host caching
Performance configuration
Workload-specific options

Do not enable additional features unless required by the lab.

Step 8 - Review Tags

Open:

Tags

No tags are required for this introductory lab.

In production environments, organizations should use a consistent tagging strategy for:

Cost management
Ownership
Environment
Application
Department
Governance
Step 9 - Review Configuration

Select:

Review + create

Azure validates the configuration.

Review the configuration carefully before deployment.

Confirm:

Subscription
Resource Group
Region
Disk name
Disk size
Disk SKU
Source type
Encryption
Networking
Advanced settings
Tags
Screenshot
screenshots/03-review-and-create.png
Step 10 - Create the Managed Disk

After validation succeeds:

Select:

Create

Wait for the deployment to complete.

Azure creates the Managed Disk in:

rg-az104-storage-01
Step 11 - Validate the Managed Disk

After deployment completes:

Select:

Go to resource

Review the Managed Disk Overview page.

Confirm:

Managed Disk exists
Resource Group is correct
Region is correct
Disk size is correct
Disk SKU is correct
Provisioning state is successful
Disk configuration is available
Resource is accessible from the Azure Portal
Screenshot
screenshots/04-managed-disk-created.png
Step 12 - Validate Managed Disk Properties

Use Azure CLI to inspect the deployed resource.

Run:

az disk show `
  --resource-group rg-az104-storage-01 `
  --name disk-az104-managed-01 `
  --query "{Name:name,SizeGB:diskSizeGb,SKU:sku.name,Location:location,ProvisioningState:provisioningState,DiskState:diskState}" `
  --output table

Confirm that the returned values match the lab configuration.

Screenshot
screenshots/05-managed-disk-properties.png
Step 13 - Final Validation

Perform final validation using:

az disk list `
  --resource-group rg-az104-storage-01 `
  --output table

Then:

az disk show `
  --resource-group rg-az104-storage-01 `
  --name disk-az104-managed-01 `
  --output table

Confirm:

Resource Group
Managed Disk Name
Location
Size
SKU
Provisioning State
Disk State
Screenshot
screenshots/06-managed-disk-final-validation.png
Validation Checklist
 Azure Portal opened
 Existing Resource Group verified
 Managed Disk creation workflow opened
 Disk name configured
 Region verified
 Disk size configured
 Disk SKU configured
 Source type reviewed
 Encryption reviewed
 Networking reviewed
 Advanced settings reviewed
 Tags reviewed
 Configuration validated
 Managed Disk created
 Managed Disk properties verified
 CLI validation completed
 Final validation completed
Cleanup

If the Managed Disk is no longer required, delete it to avoid unnecessary Azure charges.

From the Managed Disk Overview page:

Delete

Confirm the deletion.

Alternatively, use Azure CLI:

az disk delete `
  --resource-group rg-az104-storage-01 `
  --name disk-az104-managed-01 `
  --yes

Verify the Resource Group and disk name before deleting the resource.

Important Notes

Azure Portal interfaces and available configuration options may change over time.

This documentation records the workflow used during this AZ-104 hands-on lab.

The Managed Disk created in this lab is an independent storage resource.

It can later be attached to an Azure Virtual Machine as a data disk.