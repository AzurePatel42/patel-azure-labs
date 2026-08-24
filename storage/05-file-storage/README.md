
# Lab 05 - Azure File Storage

## Objective

Create, configure, validate, and document an Azure File Share using an existing Azure Storage Account.

This lab demonstrates:

- Azure File Shares
- File share quotas
- Directory creation
- File upload and download
- Azure CLI administration
- Azure Portal administration
- SMB concepts
- Authentication and authorization
- Encryption at rest and in transit
- Azure Files security considerations
- File Storage versus Blob Storage and Managed Disks

---

## Lab Environment

| Setting | Value |
|---|---|
| Subscription | `patel-platform-service-template` |
| Resource Group | `rg-az104-storage-01` |
| Region | `eastus` |
| Storage Account | `staz104az01` |
| Storage Account Kind | `StorageV2` |
| Storage Account SKU | `Standard_LRS` |
| File Share | `lab-files` |
| File Share Quota | `100 GiB` |
| Directory | `documents` |
| Test File | `sample.txt` |

---

## Learning Objectives

After completing this lab, you should be able to:

- Explain Azure Files and File Shares
- Create an Azure File Share
- Configure a File Share quota
- Create directories inside an Azure File Share
- Upload files
- Download files
- Validate Azure Files with Azure CLI
- Understand SMB-based file access
- Understand authentication versus authorization
- Understand encryption at rest versus encryption in transit
- Identify appropriate Azure Files use cases
- Compare Azure Files with Blob Storage and Managed Disks

---

## Azure Files Overview

Azure Files provides managed file shares in Azure.

Conceptually:

```text
Azure Storage Account
        |
        +-- Blob Containers
        |
        +-- File Shares
        |
        +-- Queues
        |
        +-- Tables




Azure Files provides hierarchical file and directory access.

Example:

lab-files
    |
    +-- documents
    |     |
    |     +-- sample.txt
    |
    +-- other directories

This differs from Blob Storage, which uses containers and blobs rather than a traditional file-share hierarchy.

Azure Files Architecture

A simplified Azure Files access model is:

Windows Client
      |
      | SMB
      v
Azure File Share
      |
      +-- Authentication
      |
      +-- Authorization
      |
      +-- Encryption

Azure Files can also be accessed through:

Azure Portal
Azure CLI
PowerShell
SMB
REST APIs
Azure Storage Explorer
Azure SDKs
Authentication

Azure Files supports multiple authentication approaches depending on configuration.

Examples include:

Storage account keys
Microsoft Entra ID-based authentication
Active Directory Domain Services
Microsoft Entra Domain Services
Other supported identity-based configurations

Authentication answers:

Who are you?

Authorization answers:

What are you allowed to access?

For this hands-on lab, Azure CLI file operations used a Storage Account key stored temporarily in a PowerShell variable.

The key was never displayed in the documentation or committed to GitHub.

SMB

Azure Files commonly uses SMB for Windows-based file access.

Conceptually:

Windows Client
      |
      | SMB
      v
Azure File Share

SMB provides file and directory access over the network.

SMB channel encryption helps protect SMB traffic while it is traveling between the client and Azure Files.

Encryption

Two important concepts must be distinguished.

Encryption at Rest

Protects data stored in Azure.

Azure File Share
      |
      v
Encrypted stored data
Encryption in Transit

Protects data while it travels across the network.

Client
      |
      | Encrypted communication
      v
Azure File Share

For SMB access, SMB encryption is an important example of protecting data in transit.

Security Model

A useful AZ-104 mental model is:

Azure Files
    |
    +-- Authentication
    |       |
    |       +-- Who are you?
    |
    +-- Authorization
    |       |
    |       +-- What can you access?
    |
    +-- Encryption
            |
            +-- How is the data protected?

Security considerations include:

Use identity-based authentication where appropriate
Follow least-privilege principles
Protect Storage Account keys
Use private networking when required
Use encryption in transit
Use encryption at rest
Configure appropriate permissions
Monitor access and activity
Avoid unnecessary public exposure
Hands-On Workflow

The completed lab followed this sequence:

Environment Inventory
        |
        v
File Shares Menu
        |
        v
Create File Share
        |
        v
File Share Created
        |
        v
Create documents Directory
        |
        v
Upload sample.txt
        |
        v
Download sample.txt
        |
        v
Final CLI Validation
File Share Configuration

The lab File Share was configured as:

Name:        lab-files
Quota:       100 GiB

The File Share was created inside:

Storage Account:
staz104az01
Directory and File

The following directory was created:

documents

A local test file was created:

sample.txt

The file was uploaded to:

documents/sample.txt

The file was then downloaded from Azure Files and its contents were verified locally.

Expected test content:

Azure File Storage test document - AZ-104 Module 05
Azure CLI Validation

The Storage Account was validated with:

az storage account show `
  --name staz104az01 `
  --resource-group rg-az104-storage-01 `
  --query "{Name:name,Location:location,Kind:kind,SKU:sku.name,ProvisioningState:provisioningState}" `
  --output table

The File Share was validated with:

az storage share-rm show `
  --resource-group rg-az104-storage-01 `
  --storage-account staz104az01 `
  --name lab-files `
  --output table

The directory was validated with:

az storage directory list `
  --account-name staz104az01 `
  --share-name lab-files `
  --account-key $storageKey `
  --output table

The uploaded file was validated with:

az storage file list `
  --account-name staz104az01 `
  --share-name lab-files `
  --path documents `
  --account-key $storageKey `
  --output table

The file was downloaded with:

az storage file download `
  --account-name staz104az01 `
  --share-name lab-files `
  --path "documents/sample.txt" `
  --dest ".\validation\sample-downloaded.txt" `
  --account-key $storageKey `
  --output table
Storage Account Key Handling

For Azure Files CLI operations requiring a key:

$resourceGroup = "rg-az104-storage-01"
$storageAccount = "staz104az01"
$fileShare = "lab-files"

$storageKey = (
    az storage account keys list `
      --account-name $storageAccount `
      --resource-group $resourceGroup `
      --query "[0].value" `
      --output tsv
)

Never display or commit the key.

Do not place any of the following in GitHub:

Storage Account keys
Passwords
Connection strings
SAS tokens
Access tokens
Azure Files Use Cases

Azure Files is useful for:

Shared application configuration
Shared documents
File-based application workloads
Legacy applications requiring file shares
Lift-and-shift workloads
Departmental file shares
Shared application data
Cloud-based file servers
Azure Files vs Other Azure Storage
Service	Primary Storage Model
Blob Storage	Object storage
Azure Files	Shared file storage
Queue Storage	Message storage
Table Storage	NoSQL entity storage
Managed Disks	Block storage

A key AZ-104 distinction:

Blob Storage
    -> Object storage

Azure Files
    -> Shared file storage

Managed Disks
    -> Block storage

Queue Storage
    -> Message storage

Table Storage
    -> NoSQL entity storage
Azure Files vs Managed Disks

Managed Disks provide block storage primarily for Azure Virtual Machines.

Azure Files provides shared file storage that can be accessed by multiple clients depending on configuration.

Managed Disk
    |
    +-- VM storage
    +-- OS disk
    +-- Data disk

Azure Files
    |
    +-- File Share
    +-- Directories
    +-- Files
    +-- SMB access
Screenshot Evidence

The complete hands-on evidence is stored in:

screenshots/

Expected screenshots:

screenshots/
├── 00-file-storage-environment-inventory.png
├── 01-file-shares-menu.png
├── 02-create-file-share.png
├── 03-file-share-created.png
├── 04-directory-created.png
├── 05-file-uploaded.png
├── 06-file-download-and-validation.png
└── 07-final-file-share-validation.png

The screenshots document:

Initial Storage environment
File Shares blade
File Share configuration
Successfully created File Share
Created documents directory
Uploaded sample.txt
Download and local file validation
Final Azure File Share validation
Validation Checklist

Before considering this lab complete:

 Azure subscription verified
 Resource Group verified
 Storage Account verified
 File Shares blade reviewed
 File Share created
 File Share quota configured
 Directory created
 Test file uploaded
 Uploaded file verified
 Test file downloaded
 Downloaded file contents verified
 Azure CLI validation completed
 SMB concepts reviewed
 Authentication concepts reviewed
 Authorization concepts reviewed
 Encryption concepts reviewed
 Security considerations reviewed
 Screenshots captured
 Documentation updated
 No secrets committed to GitHub
Key AZ-104 Takeaways

The most important lessons from this lab are:

Azure Files provides managed shared file storage.
File Shares provide a hierarchical directory/file model.
Azure Files commonly uses SMB for Windows-based access.
Authentication establishes identity.
Authorization controls access.
Encryption protects data.
Storage Account keys must be protected.
Azure Files is different from Blob Storage.
Azure Files is different from Managed Disks.
Azure CLI can be used to validate the actual deployed resource.
Portal configuration should always be verified against the deployed resource.
Security and cost should be considered when designing Azure Storage.
Outcome

Successfully created, configured, validated, and documented an Azure File Share using the existing AZ-104 Storage learning environment.

The lab provides practical experience with:

Azure Files
File Shares
Directories
File upload/download
Azure Portal
Azure CLI
SMB
Authentication
Authorization
Encryption
Security
Storage architecture
Cost awareness
Resource validation

This completes the AZ-104 Storage Module 05 - Azure File Storage hands-on lab.