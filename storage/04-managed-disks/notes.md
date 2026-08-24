# Azure Managed Disks - Notes

## Key Concepts Learned

- Azure Managed Disks provide persistent block-level storage for Azure Virtual Machines.
- Managed Disks are managed by Azure, reducing storage infrastructure administration.
- Managed Disks can exist independently of Virtual Machines.
- A Virtual Machine normally uses an OS disk for its operating system.
- Additional Managed Disks can be attached as data disks.
- Disk performance should be selected according to workload requirements.
- Different Managed Disk SKUs provide different performance and cost characteristics.
- Standard SSD provides a balance between performance and cost for many general workloads.
- Premium and Ultra disk options are intended for higher-performance workloads.
- Azure Managed Disks support encryption at rest.
- Platform-managed keys provide a simple encryption configuration.
- Customer-managed keys provide greater control but require additional administration.
- Managed Disk capacity, performance, and configuration affect cost.
- Azure CLI can be used to inspect and manage Managed Disks.
- Managed Disks should be deleted when no longer required to avoid unnecessary charges.

---

## OS Disk vs Data Disk

### OS Disk

The OS disk contains the operating system used by an Azure Virtual Machine.

Examples:

- Windows Server
- Ubuntu
- Red Hat Enterprise Linux

The OS disk is required for a VM to boot.

### Data Disk

A data disk provides additional persistent storage for application and workload data.

Common examples:

- Application files
- Database files
- Logs
- Business data
- Processing data

A common VM storage design is:

```text
Azure Virtual Machine
        |
        +---- OS Disk
        |
        +---- Data Disk
        |
        +---- Data Disk


Managed Disk Types

Common Azure Managed Disk types include:

Standard HDD
Standard SSD
Premium SSD
Premium SSD v2
Ultra Disk

Disk selection should consider:

Workload requirements
IOPS
Throughput
Latency
Capacity
Availability
Cost

The goal is to select the appropriate performance level rather than automatically choosing the most expensive option.

Lab Configuration

The Managed Disk used in this lab is:

Setting	Value
Resource Group	rg-az104-storage-01
Disk Name	disk-az104-managed-01
Region	eastus
Size	32 GiB
SKU	Standard SSD
Source Type	None
Encryption	Platform-managed keys

The disk is created as an empty Managed Disk.

It is not attached to a Virtual Machine during this introductory lab.

Encryption

Azure Managed Disks support encryption at rest.

Platform-Managed Keys

Azure manages the encryption keys.

Benefits:

Simple configuration
Low administrative overhead
Suitable default for many workloads
Customer-Managed Keys

The organization manages the encryption keys.

Benefits can include:

Greater control
Custom key lifecycle management
Support for certain compliance requirements

Customer-managed keys require additional operational responsibility.

For this lab, platform-managed encryption is used.

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

A Managed Disk can exist independently of a VM.

This makes it possible to prepare storage before attaching it to a workload.

Snapshots

Managed Disks can be copied using snapshots.

Snapshots can support:

Backup workflows
Testing
Recovery scenarios
Disk copying
Point-in-time protection

Snapshots should be managed according to organizational retention and security requirements.

Cost Awareness

Managed Disk costs depend on factors such as:

Disk type
Provisioned capacity
Performance requirements
Additional configuration
Redundancy

For AZ-104 labs:

Use only the required capacity.
Avoid unnecessarily expensive disk tiers.
Delete resources when the lab is complete.
Verify the Resource Group before cleanup.
Azure CLI Skills

Important commands practiced in this lab include:

az disk list
az disk show
az disk create
az disk delete

These commands allow administrators to:

Discover Managed Disks
Inspect configuration
Create disks
Validate disk properties
Delete unused disks
Troubleshooting Notes
Managed Disk Not Found

Check:

Subscription
Resource Group
Disk name

Example:

az disk list `
  --resource-group rg-az104-storage-01 `
  --output table
Provisioning State

Check:

az disk show `
  --resource-group rg-az104-storage-01 `
  --name disk-az104-managed-01 `
  --query provisioningState `
  --output tsv

Expected successful state:

Succeeded
Disk Configuration

Check:

az disk show `
  --resource-group rg-az104-storage-01 `
  --name disk-az104-managed-01 `
  --query "{Name:name,SizeGB:diskSizeGb,SKU:sku.name,Location:location,State:diskState}" `
  --output table
Challenges Encountered

This lab focuses on understanding:

Managed Disk creation
Disk SKU selection
Disk sizing
Encryption configuration
Portal-based resource creation
Azure CLI validation
Managed Disk lifecycle
Cost awareness

Any Azure Portal configuration differences should be documented during the actual lab execution.

Lessons Learned

Azure Managed Disks provide a standardized way to deliver persistent block storage for Virtual Machines.

The important engineering decision is not simply creating a disk.

The administrator must understand:

Workload
   |
   v
Storage Requirement
   |
   +---- Capacity
   |
   +---- Performance
   |
   +---- Availability
   |
   +---- Security
   |
   +---- Cost
   |
   v
Managed Disk Selection

This is an important part of Azure infrastructure design.

AZ-104 Exam Thinking

When evaluating Managed Disks, think about:

Capacity

How much storage does the workload require?

Performance

What IOPS, throughput, and latency are required?

Cost

Can the workload use a lower-cost disk tier?

Availability

Does the workload require additional resilience?

Security

What encryption and access controls are required?

Lifecycle

How will the disk be created, attached, backed up, detached, and deleted?

PPST Integration

Managed Disks are relevant to PPST when backend infrastructure requires VM-based persistent storage.

For example:

Azure Virtual Machine
        |
        +---- OS Managed Disk
        |
        +---- Data Managed Disk

However, application documents should generally be handled by object storage rather than Managed Disks when the workload requires scalable object storage.

The PPST document ingestion architecture uses:

User Upload
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
Document Processing
     |
     v
OpenAI Embeddings
     |
     v
PostgreSQL / pgvector

This demonstrates an important architecture principle:

Choose the Azure storage service based on the workload rather than using one storage technology for everything.

Engineering Takeaway

Managed Disks provide persistent block storage for Azure Virtual Machines.

Blob Storage provides object storage.

Queue Storage provides asynchronous messaging.

These services solve different problems:

Managed Disks
     |
     +---- Persistent block storage
     |
     v
Virtual Machines


Blob Storage
     |
     +---- Object storage
     |
     v
Documents / Files / Objects


Queue Storage
     |
     +---- Asynchronous messaging
     |
     v
Background Workers

Understanding these differences is important for both AZ-104 and real-world cloud architecture.

Final Validation

Before marking this lab complete, confirm:

 Resource Group verified
 Managed Disk created
 Disk name verified
 Region verified
 Size verified
 SKU verified
 Encryption reviewed
 Provisioning state verified
 Disk state verified
 Azure CLI validation completed
 Screenshots captured
 Documentation updated
 Git changes reviewed
 Git commit created
 Changes pushed to GitHub
Outcome

Successfully understand, create, validate, and document an Azure Managed Disk.

This lab provides practical AZ-104 experience with:

Persistent block storage
Managed Disk configuration
Disk performance tiers
Encryption
Azure Portal
Azure CLI
Disk lifecycle management
Cost awareness
Virtual Machine storage architecture