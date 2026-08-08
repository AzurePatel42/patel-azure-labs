# Azure File Storage - Notes

## Overview

Azure Files is a fully managed cloud file system that provides shared file storage through standard file-sharing protocols.

Azure Files is commonly used when applications or users need shared file-system access rather than object storage.

Azure Files can be accessed from:

- Azure Virtual Machines
- On-premises servers
- Windows clients
- Linux clients
- Applications
- Other Azure services

---

## Azure Files vs Blob Storage

Azure Files and Azure Blob Storage solve different storage problems.

### Azure Files

Provides a managed file system.

Typical characteristics:

- File shares
- Directories
- Files
- SMB access
- NFS support for supported configurations
- Shared access from multiple clients
- Useful for applications that expect a traditional file system

Example:

```text
File Share
│
├── documents
│   ├── invoice.pdf
│   └── report.docx
│
├── backups
│   └── database.bak
│
└── application
    └── config.json
Blob Storage

Provides object storage.

Typical characteristics:

Containers
Blobs
Object-based access
Large-scale unstructured data
Application and API-based access

Example:

Storage Account
│
└── Container
    │
    ├── image.jpg
    ├── document.pdf
    └── data.json
Azure File Share

An Azure file share is the logical file-system resource created inside an Azure Storage Account.

Hierarchy:

Azure Subscription
│
└── Resource Group
    │
    └── Storage Account
        │
        └── File Share
            │
            ├── Directory
            │   └── File
            │
            └── File

The storage account provides the underlying Azure Storage infrastructure.

The file share provides the file-system namespace used by clients.

SMB

SMB stands for:

Server Message Block

SMB is a network file-sharing protocol commonly used by Windows systems.

Azure Files supports SMB-based file sharing.

Typical scenario:

Windows Client
      │
      │ SMB
      ▼
Azure File Share

SMB allows users and applications to interact with remote files and directories using familiar file-system operations.

SMB Channel Encryption

SMB channel encryption protects SMB traffic while it travels between the client and the Azure file share.

Conceptually:

Client
  │
  │ encrypted SMB traffic
  ▼
Azure Files

The purpose of SMB encryption is to protect data moving across the network from being read or modified by unauthorized parties.

Important distinction:

SMB channel encryption protects the communication channel. It is different from authentication and authorization.

Authentication

Authentication answers:

Who are you?

Azure Files can use different authentication approaches depending on the deployment and configuration.

Common approaches include:

Storage account key
Microsoft Entra ID-based authentication
Active Directory Domain Services (AD DS)
Microsoft Entra Domain Services
Other identity-based configurations supported by Azure Files

Authentication establishes the identity attempting to access the file share.

Authorization

Authorization answers:

What are you allowed to do?

Authentication and authorization are different concepts.

Authentication
      ↓
Who are you?

Authorization
      ↓
What are you allowed to access?

An authenticated user does not automatically have permission to access every file or directory.

Permissions determine what the identity can read, write, modify, or delete.

Kerberos

Kerberos is a network authentication protocol used for identity-based authentication.

With Kerberos, a client obtains a ticket from the authentication infrastructure and uses that ticket to authenticate to the service.

Conceptually:

User
 │
 │ authentication
 ▼
Identity Provider / Domain
 │
 │ Kerberos ticket
 ▼
Client
 │
 │ SMB + Kerberos authentication
 ▼
Azure Files

Kerberos avoids repeatedly sending the user's password to the file service.

Kerberos Ticket Encryption

Kerberos tickets are cryptographically protected.

The encryption helps protect authentication information and prevents unauthorized parties from modifying or forging authentication exchanges.

Important distinction:

Kerberos
    ↓
Authentication

SMB Encryption
    ↓
Protection of SMB network traffic

Authorization
    ↓
Access permissions

These are related but different security mechanisms.

Share Quota

An Azure file share can have a configured quota.

The quota limits the amount of storage that the file share can consume.

Example:

File Share
Quota: 100 GiB

Current usage:
25 GiB

Available within quota:
75 GiB

The quota is associated with the file share rather than being a separate storage account.

File Share Performance

Azure Files performance depends on the storage account and file share configuration.

Factors include:

Storage account type
Performance tier
Provisioned capacity where applicable
File share configuration
Workload characteristics
Network conditions

For AZ-104, understand that storage performance should be selected according to workload requirements rather than simply choosing the most expensive option.

File Share Access

A file share can be accessed through different methods depending on the client and configuration.

Common methods include:

Azure Portal
Azure CLI
PowerShell
SMB
REST APIs
Azure Storage Explorer
Azure SDKs
Directory and File Structure

Azure Files provides a hierarchical file-system structure.

Example:

customer-share
│
├── customers
│   ├── customer001
│   │   └── profile.json
│   │
│   └── customer002
│       └── profile.json
│
├── invoices
│   ├── invoice001.pdf
│   └── invoice002.pdf
│
└── backups
    └── backup.zip

This differs from the container/blob model used by Blob Storage.

Storage Account Relationship

Azure Files is a service within an Azure Storage Account.

Conceptually:

Storage Account
│
├── Blob Containers
├── File Shares
├── Queues
└── Tables

A single storage account can provide multiple Azure Storage services.

Security Considerations

Important Azure Files security considerations include:

Use identity-based authentication where appropriate.
Follow least-privilege access principles.
Protect storage account keys.
Use private networking where required.
Use encryption in transit.
Use encryption at rest.
Configure appropriate share-level permissions.
Monitor access and activity.
Avoid exposing storage unnecessarily to the public internet.
Encryption at Rest vs Encryption in Transit

These concepts should not be confused.

Encryption at Rest

Protects stored data.

Client
  │
  ▼
Azure Files
  │
  └── encrypted stored data
Encryption in Transit

Protects data while traveling across the network.

Client
  │
  │ encrypted communication
  ▼
Azure Files

For SMB access, SMB encryption is an important example of protecting traffic in transit.

Authentication vs Authorization vs Encryption

A useful AZ-104 mental model:

                    Azure Files
                         │
        ┌────────────────┼────────────────┐
        │                │                │
        ▼                ▼                ▼
 Authentication     Authorization     Encryption
        │                │                │
   Who are you?     What can you do?   Protect data

Authentication establishes identity.

Authorization controls access.

Encryption protects data.

Common Azure Files Use Cases

Azure Files can be useful for:

Shared application configuration
Shared documents
File-based application workloads
Legacy applications requiring file shares
Lift-and-shift workloads
Centralized departmental file shares
Shared application data
Cloud-based file servers
Azure Files vs Managed Disks

Managed Disks provide block storage for Azure Virtual Machines.

Azure Files provides shared file storage.

Managed Disk
VM
│
└── Managed Disk

Typically associated with a VM workload.

Azure Files
Client A ──┐
           │
Client B ──┼── Azure File Share
           │
Client C ──┘

Multiple clients can access the same file share according to the configured authentication and permissions.

Azure Files vs Queue Storage

These services have completely different purposes.

Azure Files

Used for:

Shared file storage.

Queue Storage

Used for:

Asynchronous message processing.

Example:

Application
    │
    ▼
Queue
    │
    ▼
Worker

Do not confuse file storage with messaging.

Azure Files vs Table Storage

Azure Files:

Managed file system.

Azure Table Storage:

NoSQL key-value/entity storage.

The data model and access patterns are different.

Important AZ-104 Takeaways

Remember these concepts:

Azure Files provides managed cloud file shares.
SMB is a common protocol used to access Azure Files.
Authentication determines identity.
Authorization determines permissions.
Kerberos provides ticket-based authentication for supported identity-based SMB scenarios.
SMB channel encryption protects SMB traffic in transit.
Encryption at rest protects stored data.
File shares exist inside Azure Storage Accounts.
File shares can contain directories and files.
File share quotas control available capacity.
Managed Disks provide block storage, while Azure Files provides shared file storage.
Azure Files is useful for workloads that require traditional file-system semantics.
Lab Validation

During this lab, verify:

 Storage Account exists
 File share was created
 File share quota was configured
 File share is visible in the Azure Portal
 Directory/file operations were tested
 File share configuration was reviewed
 Authentication concepts were reviewed
 SMB security concepts were reviewed
 Screenshots were captured
 CLI commands were documented
 Portal steps were documented
Personal Learning Notes

The most important distinction from this lab:

Blob Storage
    ↓
Object storage

Azure Files
    ↓
File storage

Managed Disks
    ↓
Block storage

Queue Storage
    ↓
Message storage

Table Storage
    ↓
NoSQL entity storage

Azure Storage is not one single storage technology.

It is a family of storage services designed for different workload patterns.