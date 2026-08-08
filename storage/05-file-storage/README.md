# Lab 05 - Azure File Storage

## Objective

The objective of this lab is to create and manage an Azure File Share using an existing Azure Storage Account.

This lab introduces Azure Files as a managed cloud file system and demonstrates how file shares, directories, files, SMB, authentication, authorization, encryption, and networking work together.

---

## Learning Objectives

After completing this lab, you should be able to:

- Explain Azure Files
- Explain the purpose of Azure File Shares
- Create an Azure File Share
- Configure a file share quota
- Create directories within a file share
- Upload and manage files
- Understand SMB
- Understand SMB channel encryption
- Explain authentication mechanisms
- Explain authorization
- Understand Kerberos-based authentication
- Understand encryption at rest and encryption in transit
- Review Azure Storage networking
- Use Azure Portal to manage Azure Files
- Use Azure CLI to manage Azure Files
- Compare Azure Files with Blob Storage
- Compare Azure Files with Managed Disks

---

## Azure Services Used

- Azure Resource Group
- Azure Storage Account
- Azure Files
- Azure File Share

---

## Prerequisites

Before starting this lab:

- Active Azure Subscription
- Azure Portal access
- Azure CLI installed
- Azure CLI authentication configured
- Existing Azure Storage Account
- Basic understanding of Azure Storage

---

# Architecture

```text
Azure Subscription
│
└── Resource Group
    │
    └── Storage Account
        │
        └── Azure File Share
            │
            ├── documents
            │   └── test.txt
            │
            └── other directories/files

Clients can access the file share through supported protocols and authentication mechanisms.

Windows Client
      │
      │ SMB
      ▼
Azure File Share
What is Azure Files?

Azure Files is a fully managed cloud file system provided by Azure Storage.

It provides shared file storage that can be accessed by applications, Azure Virtual Machines, Windows clients, Linux clients, and other supported environments.

Azure Files is particularly useful when an application requires traditional file-system semantics rather than object-based storage.

Azure File Share

A file share is the logical file-system resource created inside an Azure Storage Account.

Example:

Storage Account
│
└── File Share
    │
    ├── documents
    │   ├── invoice.pdf
    │   └── report.docx
    │
    └── backups
        └── backup.zip

The file share provides the namespace in which directories and files are stored.

SMB

SMB stands for:

Server Message Block

SMB is a network file-sharing protocol commonly used by Windows systems.

Azure Files supports SMB-based file sharing.

Typical access pattern:

Windows Client
      │
      │ SMB
      ▼
Azure Files

SMB allows applications and users to interact with remote files and directories using familiar file-system operations.

SMB Channel Encryption

SMB channel encryption protects SMB traffic while it travels between the client and Azure Files.

Conceptually:

Client
  │
  │ encrypted SMB traffic
  ▼
Azure Files

SMB channel encryption is a protection mechanism for data in transit.

It should not be confused with encryption at rest.

Authentication Mechanisms

Authentication answers:

Who are you?

Depending on the Azure Files configuration, supported authentication mechanisms can include:

Storage account keys
Microsoft Entra ID-based authentication
Active Directory Domain Services
Microsoft Entra Domain Services
Other supported identity-based configurations

Authentication establishes the identity attempting to access the file share.

Authorization

Authorization answers:

What are you allowed to access?

Authentication and authorization are separate concepts.

Authentication
      ↓
Who are you?
      ↓
Authorization
      ↓
What are you allowed to do?

An authenticated identity still requires appropriate permissions.

The principle of least privilege should be applied when assigning access.

Kerberos

Kerberos is a ticket-based network authentication protocol.

It is used in supported identity-based SMB scenarios.

Conceptually:

User
 │
 │ authenticate
 ▼
Identity / Domain
 │
 │ Kerberos ticket
 ▼
Client
 │
 │ SMB authentication
 ▼
Azure Files

Kerberos allows authentication using tickets rather than repeatedly transmitting a user's password to the file service.

Kerberos Ticket Encryption

Kerberos tickets are cryptographically protected.

This helps protect authentication information and prevents unauthorized modification of authentication exchanges.

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

These mechanisms solve different security problems.

Encryption

Azure Storage provides encryption at rest for stored data.

Azure Files can also use encryption in transit depending on the access protocol and configuration.

Encryption at Rest

Protects stored data:

Azure Files
    │
    └── encrypted stored data
Encryption in Transit

Protects data while it travels across the network:

Client
    │
    │ protected network traffic
    ▼
Azure Files
File Share Quota

A file share can have a configured quota.

The quota limits the amount of storage available to the share.

Example:

File Share
Quota: 100 GiB

Current Usage: 25 GiB

Remaining Capacity Within Quota: 75 GiB

The quota is associated with the file share.

Azure Files vs Blob Storage

These services provide different storage models.

Azure Files	Blob Storage
File storage	Object storage
File shares	Containers
Directories and files	Blobs
SMB/NFS scenarios	HTTP/API-based object access
Traditional file-system workloads	Unstructured object data
Azure Files
File Share
│
├── directory
│   └── file
└── file
Blob Storage
Container
│
├── image.jpg
├── document.pdf
└── data.json
Azure Files vs Managed Disks

Managed Disks provide block storage for Azure Virtual Machines.

Azure Files provides shared file storage.

Managed Disk
VM
│
└── Managed Disk
Azure Files
Client A ──┐
           │
Client B ──┼── Azure File Share
           │
Client C ──┘

Managed Disks are commonly attached to individual VM workloads.

Azure Files is designed for shared file access.

Azure Files vs Queue Storage

Azure Files provides file storage.

Azure Queue Storage provides asynchronous message storage.

Azure Files
    ↓
Shared files

Queue Storage
    ↓
Messages between application components

These services solve different architectural problems.

Azure Files vs Table Storage

Azure Files provides a hierarchical file system.

Azure Table Storage provides NoSQL entity storage.

Azure Files
    ↓
Files + directories

Table Storage
    ↓
Entities + PartitionKey + RowKey
Security Considerations

Important Azure Files security considerations include:

Use identity-based authentication where appropriate.
Follow least-privilege principles.
Protect Storage Account keys.
Avoid exposing storage unnecessarily.
Review Storage Account networking.
Use private networking where required.
Understand encryption at rest.
Understand encryption in transit.
Review SMB security.
Monitor access and activity.

Never commit secrets to GitHub.

Do not store the following in this repository:

Storage Account Keys
Passwords
Connection Strings
SAS Tokens
Access Tokens
Portal Lab

The Azure Portal portion of this lab demonstrates:

Opening the Storage Account
Navigating to File Shares
Creating a File Share
Configuring the quota
Opening the File Share
Creating a directory
Uploading a test file
Reviewing configuration
Reviewing networking
Reviewing security concepts

Detailed instructions are documented in:

portal-steps.md
CLI Lab

The Azure CLI portion demonstrates:

Listing Storage Accounts
Viewing Storage Account configuration
Retrieving Storage Account keys
Creating a File Share
Listing File Shares
Viewing File Share configuration
Creating directories
Uploading files
Listing files
Downloading files
Deleting files
Reviewing networking
Reviewing encryption

Detailed commands are documented in:

cli-commands.md
Screenshots

Screenshots captured during the lab are stored in:

screenshots/

Expected screenshots include:

screenshots/
├── 01-file-shares-menu.png
├── 02-create-file-share.png
├── 03-file-share-created.png
├── 04-directory-created.png
└── 05-file-uploaded.png

The exact screenshots may vary depending on the Azure Portal interface encountered during the lab.

Validation Checklist

Before considering the lab complete:

 Storage Account verified
 File Shares blade opened
 File Share created
 File Share quota configured/reviewed
 File Share verified
 Directory created
 Test file uploaded
 File contents verified
 SMB understood
 SMB channel encryption understood
 Authentication mechanisms reviewed
 Authorization understood
 Kerberos reviewed
 Kerberos ticket encryption understood
 Encryption at rest reviewed
 Encryption in transit reviewed
 Networking reviewed
 Azure CLI commands documented
 Portal steps documented
 Notes documented
 Screenshots captured
 No secrets committed to Git
Key AZ-104 Concepts

The most important concepts from this lab are:

Azure Storage
│
├── Blob Storage
│     └── Object storage
│
├── Azure Files
│     └── File storage
│
├── Queue Storage
│     └── Message storage
│
├── Table Storage
│     └── NoSQL entity storage
│
└── Managed Disks
      └── Block storage

Security model:

Authentication
      ↓
Who are you?

Authorization
      ↓
What can you access?

Encryption
      ↓
How is the data protected?

For SMB:

Client
  │
  │ SMB
  ▼
Azure Files
  │
  ├── Authentication
  │
  ├── Authorization
  │
  └── Encryption
What I Learned

Azure Files provides a managed file-system experience in Azure.

The most important distinction from this lab is that Azure Storage contains several different storage services, each designed for a different workload.

Blob Storage
    → Object storage

Azure Files
    → Shared file storage

Managed Disks
    → Block storage

Queue Storage
    → Message storage

Table Storage
    → NoSQL entity storage

The security concepts are equally important:

Authentication
    → Establish identity

Authorization
    → Control access

Encryption
    → Protect data

Understanding these distinctions is important for both the AZ-104 exam and real-world Azure architecture.