# Lab 04 - Azure Managed Disks

## Objective

The objective of this lab is to create and configure an Azure Managed Disk while understanding how Azure provides persistent block storage for Azure Virtual Machines.

This lab introduces Azure Managed Disks, disk configuration options, encryption, networking considerations, and common managed disk use cases.

---

## Learning Objectives

After completing this lab, you should be able to:

- Understand Azure Managed Disks
- Explain the purpose of Managed Disks
- Create an Azure Managed Disk
- Understand managed disk configuration options
- Understand disk encryption options
- Understand basic disk networking considerations
- Identify common managed disk use cases
- Understand the relationship between Managed Disks and Azure Virtual Machines
- Use Azure CLI to manage Managed Disks
- Validate successful Managed Disk deployment

---

## Azure Services Used

- Azure Resource Group
- Azure Managed Disk

---

## Prerequisites

- Active Azure Subscription
- Azure Portal access
- Azure CLI installed
- Azure CLI authenticated
- Basic understanding of Azure Resource Groups
- Basic understanding of Azure Virtual Machines

---

## Architecture

Azure Managed Disks provide persistent block storage for Azure Virtual Machines.

```text
Azure Subscription
        |
        v
Resource Group
rg-ppst-storage-lab
        |
        v
Azure Managed Disk
        |
        v
Azure Virtual Machine
       / \
      /   \
 OS Disk  Data Disk

Azure manages the underlying storage infrastructure, reducing the administrative overhead associated with manually managing storage accounts and VHD files.

Lab Implementation

The lab creates an Azure Managed Disk using the Azure Portal.

The disk can later be attached to an Azure Virtual Machine as a data disk.

The following areas were reviewed:

Subscription
Resource Group
Region
Disk name
Source type
Encryption
Networking
Advanced configuration
Tags
Review and validation
Lab Configuration
Setting	Configuration
Subscription	patel-platform-service-template
Resource Group	rg-ppst-storage-lab
Managed Disk Name	disk-managed-lab-01
Source Type	None
Encryption	Platform-managed keys
Networking	Default configuration
Tags	None

Azure Portal configuration options and available disk SKUs may change over time. This table documents the configuration used during this lab.

Managed Disk Types

Azure provides multiple managed disk options for different workload requirements:

Standard HDD
Standard SSD
Premium SSD
Premium SSD v2
Ultra Disk

Disk selection should consider:

Capacity
IOPS
Throughput
Latency
Availability
Workload requirements
Cost
OS Disk vs Data Disk
OS Disk

The OS disk contains the operating system used by an Azure Virtual Machine.

Data Disk

A data disk provides persistent storage for application and workload data.

Common uses include:

Database files
Application data
Logs
Uploaded files
Business data
Encryption

Azure Managed Disks support encryption at rest.

Common approaches include:

Platform-managed keys
Customer-managed keys

Platform-managed keys provide a simple default configuration.

Customer-managed keys provide organizations with greater control over encryption key management and may be required for certain compliance scenarios.

Validation

The deployment was successfully completed.

Validation included:

Opening the Managed Disk creation workflow.
Selecting the lab Resource Group.
Configuring the Managed Disk.
Reviewing encryption and networking settings.
Reviewing the configuration.
Creating the disk.
Opening the deployed Managed Disk resource.
Confirming successful deployment.
Screenshots

The following screenshots were captured during the lab:

screenshots/01-resource-group.png
screenshots/02-create-managed-disk.png
screenshots/03-review-and-create.png
screenshots/04-managed-disk-created.png
Cleanup

If the Managed Disk is no longer required, delete it to avoid unnecessary Azure charges.

Azure Portal

Navigate to:

Managed Disk
    -> Overview
    -> Delete
Azure CLI
az disk delete `
  --resource-group rg-ppst-storage-lab `
  --name disk-managed-lab-01 `
  --yes

Verify the disk name before deleting the resource.

AZ-104 Takeaways
Managed Disks provide persistent block storage for Azure Virtual Machines.
Azure manages the underlying storage infrastructure.
OS disks contain the operating system.
Data disks provide additional persistent storage.
Different disk types provide different performance and cost characteristics.
Encryption protects data at rest.
Disk selection should match workload requirements.
Managed Disks can be created independently and later attached to Virtual Machines.
Azure CLI can be used to create, inspect, list, and delete Managed Disks.