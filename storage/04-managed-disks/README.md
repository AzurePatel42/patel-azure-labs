# Lab 04 - Azure Managed Disks

## Objective

The objective of this lab is to create and manage an Azure Managed Disk while understanding how Azure provides persistent block storage for Azure Virtual Machines.

This lab demonstrates Managed Disk configuration, disk performance tiers, encryption, disk lifecycle management, Azure CLI administration, and validation.

---

## Learning Objectives

After completing this lab, you should be able to:

- Understand Azure Managed Disks
- Explain the purpose of Managed Disks
- Create an Azure Managed Disk
- Understand OS disks versus data disks
- Understand Managed Disk performance tiers
- Understand disk encryption
- Understand basic disk configuration options
- Understand the relationship between Managed Disks and Azure Virtual Machines
- Use Azure CLI to manage Managed Disks
- Validate a Managed Disk deployment
- Understand Managed Disk lifecycle and cleanup
- Explain how Managed Disks fit into Azure infrastructure

---

## Azure Services Used

- Azure Resource Group
- Azure Managed Disk

---

## Prerequisites

- Azure Subscription
- Azure Portal access
- Azure CLI installed
- Azure CLI authenticated
- Completed Lab 01 - Azure Storage Account
- Completed Lab 02 - Azure Blob Storage
- Completed Lab 03 - Azure Queue Storage
- Basic understanding of Azure Resource Groups
- Basic understanding of Azure Virtual Machines

---

## Lab Environment

This lab uses the existing Azure Storage learning environment created in the previous modules.

| Setting | Value |
|---|---|
| Resource Group | `rg-az104-storage-01` |
| Region | `eastus` |
| Managed Disk | `disk-az104-managed-01` |
| Disk Size | `32 GiB` |
| Disk SKU | `Standard SSD` |
| Source Type | `None` |
| Encryption | Platform-managed keys |
| Purpose | AZ-104 hands-on training |

The existing Resource Group is reused to keep the Storage labs organized within the same Azure environment.

---

## Architecture

Azure Managed Disks provide persistent block storage for Azure Virtual Machines.

```text
Azure Subscription
        |
        v
Resource Group
rg-az104-storage-01
        |
        v
Azure Managed Disk
disk-az104-managed-01
        |
        v
Azure Virtual Machine
       / \
      /   \
 OS Disk  Data Disk


 What Is an Azure Managed Disk?

Azure Managed Disks are block-level storage volumes managed by Azure.

Azure manages the underlying storage infrastructure, reducing the administrative overhead associated with manually managing storage accounts and VHD files.

Managed Disks are commonly used with Azure Virtual Machines.

OS Disk vs Data Disk
OS Disk

The OS disk contains the operating system used by an Azure Virtual Machine.

Examples include:

Windows Server
Ubuntu
Red Hat Enterprise Linux
Other supported operating systems
Data Disk

A data disk provides additional persistent storage for application and workload data.

Common uses include:

Application data
Database files
Logs
Uploaded files
Business data

A Virtual Machine can typically have:

1 OS Disk
+
0 or more Data Disks

The supported number of data disks depends on the VM size and workload requirements.

Managed Disk Types

Azure provides multiple Managed Disk performance options.

Common options include:

Standard HDD
Standard SSD
Premium SSD
Premium SSD v2
Ultra Disk

Disk selection should be based on workload requirements.

Important factors include:

Capacity
IOPS
Throughput
Latency
Availability
Workload requirements
Cost

The highest-performance disk is not automatically the correct choice.

The engineering objective is to meet application requirements while controlling cost.

Lab Disk Configuration

The introductory lab uses:

Setting	Configuration
Resource Group	rg-az104-storage-01
Disk Name	disk-az104-managed-01
Region	eastus
Size	32 GiB
SKU	Standard SSD
Source Type	None
Encryption	Platform-managed keys
Networking	Default configuration
Tags	None

The disk is created as an empty Managed Disk.

It can later be attached to an Azure Virtual Machine as a data disk.

Encryption

Azure Managed Disks support encryption at rest.

Common approaches include:

Platform-Managed Keys

Azure manages the encryption keys.

Advantages:

Simple configuration
Minimal administrative overhead
Appropriate default for many workloads
Customer-Managed Keys

The organization manages the encryption keys.

Advantages:

Greater control
Support for certain compliance requirements
Custom key lifecycle management

Customer-managed keys introduce additional operational responsibilities.

For this introductory lab, platform-managed encryption is used.

Networking

Managed Disks integrate with Azure storage infrastructure.

The Managed Disk configuration workflow may expose networking and advanced configuration options depending on the disk type and Azure Portal experience.

For this introductory lab:

Review the available options
Retain the appropriate default configuration
Do not enable advanced features unless required by the lab

Advanced disk access and security scenarios can be explored in later Azure labs.

Managed Disk Lifecycle

A typical Managed Disk lifecycle is:

Create
  |
  v
Configure
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

A Managed Disk can exist independently of a Virtual Machine.

This allows administrators to create storage first and attach it to a VM later.

Snapshots

A Managed Disk can be copied using a snapshot.

Snapshots can be useful for:

Backup workflows
Testing
Creating disk copies
Recovery scenarios

A snapshot represents a point-in-time copy of a disk.

Snapshots should be protected and managed according to organizational security and retention requirements.

Cost Awareness

Managed Disk costs can depend on:

Disk type
Provisioned capacity
Performance configuration
Redundancy
Additional features

Training resources should be deleted when they are no longer required.

Always verify the Resource Group and resource name before deleting Azure resources.

Validation Checklist

The following validation will be performed during the lab:

 Existing Azure environment verified
 Resource Group verified
 Managed Disk creation workflow opened
 Disk name configured
 Region verified
 Disk size configured
 Disk SKU reviewed
 Source type reviewed
 Encryption reviewed
 Networking reviewed
 Advanced settings reviewed
 Configuration reviewed
 Managed Disk created
 Managed Disk properties verified
 Provisioning state verified
 Final CLI validation completed
Screenshots

The lab evidence will follow a chronological workflow.

Screenshot	Description
00-managed-disk-environment-inventory.png	Azure environment before Managed Disk work
01-resource-group.png	Existing Resource Group verified
02-create-managed-disk.png	Managed Disk configuration
03-review-and-create.png	Configuration review before deployment
04-managed-disk-created.png	Managed Disk successfully created
05-managed-disk-properties.png	Managed Disk properties and CLI validation
06-managed-disk-final-validation.png	Final Managed Disk validation
Azure CLI Validation

The Azure CLI will be used to verify:

Resource Group
Managed Disk existence
Disk size
Disk SKU
Region
Provisioning state
Disk state
Encryption configuration
Resource ID

Example:

az disk show `
  --resource-group rg-az104-storage-01 `
  --name disk-az104-managed-01 `
  --output table
Cleanup

If the Managed Disk is no longer required, delete it to avoid unnecessary Azure charges.

Azure Portal

Navigate to:

Managed Disk
    -> Overview
    -> Delete
Azure CLI
az disk delete `
  --resource-group rg-az104-storage-01 `
  --name disk-az104-managed-01 `
  --yes

Verify the disk name and Resource Group before deleting the resource.

AZ-104 Takeaways

Key concepts demonstrated in this lab:

Managed Disks provide persistent block storage for Azure Virtual Machines.
Azure manages the underlying storage infrastructure.
OS disks contain the operating system.
Data disks provide additional persistent storage.
Different disk types provide different performance and cost characteristics.
Disk selection should match workload requirements.
Managed Disks support encryption at rest.
Platform-managed keys provide a simple default encryption configuration.
Customer-managed keys provide greater organizational control.
Managed Disks can exist independently of Virtual Machines.
Managed Disks can later be attached to Virtual Machines.
Azure CLI can be used to create, inspect, validate, and delete Managed Disks.
Training resources should be cleaned up when they are no longer required.
PPST Relevance

Managed Disks are relevant to the PPST platform because cloud applications may require persistent infrastructure storage for:

Application workloads
Database infrastructure
Worker infrastructure
VM-based services
Logs
Temporary processing workloads
Backup and recovery scenarios

The PPST architecture should use the appropriate Azure storage service based on the workload rather than treating all storage requirements the same.

For example:

Application Documents
        |
        v
Azure Blob Storage
        |
        v
Azure Queue Storage
        |
        v
PPST Worker
        |
        v
Processing / Embeddings

Whereas VM infrastructure may use:

Azure Virtual Machine
        |
        +---- OS Managed Disk
        |
        +---- Data Managed Disk

This distinction is important when designing cloud-native backend systems.

Outcome

Successfully create, configure, validate, and document an Azure Managed Disk using the existing AZ-104 Storage learning environment.

The lab provides hands-on experience with Azure block storage, Managed Disk configuration, encryption, lifecycle management, Azure CLI administration, and Virtual Machine storage concepts.