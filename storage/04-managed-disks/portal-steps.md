# Azure Managed Disks - Portal Steps

## Objective

Create and validate an Azure Managed Disk using the Azure Portal.

---

## Step 1 - Open Azure Portal

Sign in to the Azure Portal.

Navigate to:

```text
Resource Groups

Open the lab Resource Group:

rg-ppst-storage-lab
Step 2 - Start Managed Disk Creation

From the Azure Portal, select:

Create a resource

Search for:

Managed Disks

Select:

Managed Disks

Start the Managed Disk creation workflow.

Step 3 - Configure Basic Settings

Configure the basic Managed Disk settings.

Setting	Value
Subscription	patel-platform-service-template
Resource Group	rg-ppst-storage-lab
Managed Disk Name	disk-managed-lab-01
Region	Lab region
Source Type	None

For this lab, the Managed Disk is created as an empty disk.

Screenshot
screenshots/01-resource-group.png
screenshots/02-create-managed-disk.png
Step 4 - Review Encryption

Open the:

Encryption

section.

Review the available encryption configuration.

For this introductory lab, use the default platform-managed encryption configuration.

Azure Managed Disks support encryption at rest using platform-managed keys and customer-managed keys.

Step 5 - Review Networking

Open the:

Networking

section.

Review the available networking configuration.

For this introductory lab, retain the default configuration.

Advanced disk access and security scenarios can be explored in later labs.

Step 6 - Review Advanced Settings

Open the:

Advanced

section.

Review the available options.

For this introductory lab, retain the default configuration.

Advanced Managed Disk capabilities may include features such as:

Shared disks
Host caching
Disk performance options
Other workload-specific configurations
Step 7 - Review Tags

Open the:

Tags

section.

No tags are required for this introductory lab.

In production environments, organizations should use a consistent tagging strategy for:

Cost management
Ownership
Environment
Application
Department
Governance
Step 8 - Review Configuration

Select:

Review + create

Azure validates the configuration.

Review the configuration carefully before deployment.

Confirm:

Subscription
Resource Group
Region
Disk name
Disk configuration
Encryption
Networking
Advanced settings
Tags
Screenshot
screenshots/03-review-and-create.png
Step 9 - Create the Managed Disk

After validation succeeds, select:

Create

Wait for the deployment to complete.

Azure creates the Managed Disk in the selected Resource Group.

Step 10 - Validate the Deployment

After deployment completes, select:

Go to resource

Review the Managed Disk Overview page.

Confirm that:

The Managed Disk exists.
The Resource Group is correct.
The disk provisioning state is successful.
The disk configuration is available.
The resource is accessible from the Azure Portal.
Screenshot
screenshots/04-managed-disk-created.png
Validation Checklist
 Azure Portal opened
 Lab Resource Group selected
 Managed Disk creation started
 Managed Disk name configured
 Source type reviewed
 Encryption reviewed
 Networking reviewed
 Advanced settings reviewed
 Tags reviewed
 Configuration validated
 Managed Disk created
 Deployment verified
Cleanup

If the Managed Disk is no longer required, delete it to avoid unnecessary Azure charges.

From the Managed Disk Overview page:

Delete

Confirm the deletion.

Alternatively, use the Azure CLI commands documented in:

cli-commands.md
Important Notes

Azure Portal interfaces and available configuration options may change over time.

This documentation reflects the Portal workflow observed during the execution of this lab.

The Managed Disk created in this lab is an independent storage resource. It can later be attached to an Azure Virtual Machine as a data disk.