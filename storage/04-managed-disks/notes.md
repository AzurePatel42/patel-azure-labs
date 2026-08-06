# Azure Managed Disks - Notes

## What Is an Azure Managed Disk?

Azure Managed Disks are block-level storage volumes managed by Azure.

They are primarily used as persistent storage for Azure Virtual Machines.

Azure manages the underlying storage infrastructure, reducing the administrative overhead associated with manually managing storage accounts and VHD files.

---

## Managed Disk Architecture

```text
Azure Virtual Machine
        |
        +----------------+
        |                |
        v                v
     OS Disk         Data Disk
        |                |
        +--------+-------+
                 |
                 v
          Azure Managed Disk
                 |
                 v
       Azure-managed storage
OS Disk vs Data Disk
OS Disk

The OS disk contains the operating system for an Azure Virtual Machine.

Examples include:

Windows Server
Ubuntu
Red Hat Enterprise Linux
Other supported operating systems
Data Disk

A data disk provides additional persistent storage for workloads running on a Virtual Machine.

Common uses include:

Application data
Database files
Logs
Uploaded files
Business data
Managed Disk Types

Azure provides different Managed Disk types for different workload requirements.

Standard HDD

Standard HDD provides economical storage for workloads that do not require high performance.

Typical use cases:

Backup
Archive
Development
Low-I/O workloads
Standard SSD

Standard SSD provides better performance and lower latency than Standard HDD.

Typical use cases:

Web servers
Application servers
Development environments
General-purpose workloads
Premium SSD

Premium SSD is designed for workloads requiring higher performance and lower latency.

Typical use cases:

Production applications
Databases
Business-critical workloads
Premium SSD v2

Premium SSD v2 provides more granular performance configuration for demanding workloads.

It can be useful when applications require independently configurable performance characteristics.

Ultra Disk

Ultra Disk is designed for extremely demanding workloads requiring very high IOPS and low latency.

Typical use cases include:

Mission-critical databases
High-performance transactional workloads
Disk Selection

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

Encryption

Azure Managed Disks support encryption at rest.

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

Networking

Managed Disks are integrated with Azure storage infrastructure.

The Networking section provides configuration options for advanced disk access scenarios.

For a basic VM disk deployment, the default configuration is generally sufficient.

Advanced scenarios should be evaluated based on workload and security requirements.

Snapshots

An Azure Managed Disk can be copied using a snapshot.

Snapshots can be useful for:

Backup workflows
Testing
Creating disk copies
Recovery scenarios

A snapshot represents a point-in-time copy of a disk.

Managed Disk and Virtual Machine Relationship

An Azure Virtual Machine typically uses:

1 OS Disk
+
0 or more Data Disks

The number of supported data disks depends on the Virtual Machine size and workload requirements.

VM capabilities and disk performance should be evaluated together.

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

Managed Disks can exist independently of a Virtual Machine.

This allows a disk to be created first and attached to a VM later.

Cost Awareness

Managed Disk costs can depend on:

Disk type
Provisioned capacity
Performance configuration
Redundancy
Additional features

Training resources should be deleted when they are no longer required.

Always verify the resource name and Resource Group before deleting resources.

Security Considerations

For production environments:

Use appropriate encryption.
Apply least-privilege access through Azure RBAC.
Protect snapshots and disk resources.
Follow organizational tagging and governance standards.
Monitor resource usage and cost.
Use customer-managed keys when required by organizational or compliance requirements.
Azure Managed Disks vs Unmanaged Disks

Managed Disks are the recommended approach for most modern Azure VM deployments.

With Managed Disks:

Azure manages the underlying storage.
Administrators do not need to manage storage accounts for VM disks.
Disk management is simplified.
Integration with Azure VM infrastructure is easier.
Azure provides multiple disk performance options.

Unmanaged disks required administrators to manage the storage account containing the VHD files.

Azure CLI

The core Azure CLI commands used to manage Managed Disks include:

az disk create
az disk list
az disk show
az disk delete

These commands allow administrators to create, inspect, list, and remove Managed Disk resources.

Lab Configuration

The Managed Disk created during this lab used the following configuration:

Setting	Value
Subscription	patel-platform-service-template
Resource Group	rg-ppst-storage-lab
Managed Disk Name	disk-managed-lab-01
Source Type	None
Encryption	Platform-managed keys
Networking	Default configuration
Tags	None