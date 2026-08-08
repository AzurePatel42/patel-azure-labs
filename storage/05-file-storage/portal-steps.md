# Azure File Storage - Portal Steps

## Objective

Create and manage an Azure File Share using an existing Azure Storage Account through the Azure Portal.

This lab demonstrates the basic Azure Files workflow, including creating a file share, configuring the quota, creating directories, uploading files, and reviewing access and security concepts.

---

## Prerequisites

Before beginning:

- Active Azure subscription
- Access to Azure Portal
- Existing Azure Storage Account
- Appropriate permissions to manage the Storage Account

---

# Step 1 - Open the Storage Account

1. Sign in to the Azure Portal.
2. Open **Storage accounts**.
3. Select the Storage Account used for the storage labs.
4. Confirm that the Storage Account is in the expected Resource Group.

---

# Step 2 - Open File Shares

From the Storage Account:

1. Select **Data storage**.
2. Select **File shares**.
3. Review the File shares blade.

The File shares section displays the file shares associated with the Storage Account.

### Screenshot

Capture:

```text
screenshots/01-file-shares-menu.png
Step 3 - Create a File Share

From File shares:

Select + File share.
Enter a file share name.

Example:

lab-files
Configure the share quota according to the lab requirements.
Review the available options.
Select Review + create or Create, depending on the portal experience.
Screenshot

Capture the creation configuration:

screenshots/02-create-file-share.png
Step 4 - Verify the File Share

After deployment:

Return to Data storage → File shares.
Confirm that the new file share appears.
Select the file share.

Verify:

Share name
Quota
Provisioned capacity where applicable
Current usage
Configuration options
Screenshot

Capture the created file share:

screenshots/03-file-share-created.png
Step 5 - Create a Directory

Open the file share.

Select + Add directory.
Enter a directory name.

Example:

documents
Select OK or Create.

The directory should now appear inside the file share.

Screenshot

Capture the directory:

screenshots/04-directory-created.png
Step 6 - Upload a File

Open the directory created in the previous step.

Select Upload.
Select a small test file from the local computer.
Upload the file.
Confirm that the file appears in the directory.

Example:

documents/
└── test.txt
Screenshot

Capture the uploaded file:

screenshots/05-file-uploaded.png
Step 7 - Review File Share Configuration

Return to the file share overview.

Review the available configuration options.

Pay attention to:

Capacity
Quota
Protocol
Access configuration
Security settings
Networking
Data protection
Monitoring

The exact options displayed can vary depending on the Storage Account configuration and Azure portal experience.

Step 8 - Understand SMB Access

Azure Files commonly uses SMB for Windows-based file sharing.

Conceptually:

Windows Client
      │
      │ SMB
      ▼
Azure File Share

SMB allows applications and users to interact with remote files using familiar file-system operations.

Step 9 - Review Authentication

Authentication answers:

Who are you?

Depending on the configuration, Azure Files can support authentication mechanisms such as:

Storage account keys
Microsoft Entra ID-based authentication
Active Directory Domain Services
Microsoft Entra Domain Services
Other supported identity-based configurations

Authentication should be considered separately from authorization.

Step 10 - Review Authorization

Authorization answers:

What are you allowed to access?

An authenticated identity still requires appropriate permissions.

Conceptually:

Authentication
      ↓
Identity established
      ↓
Authorization
      ↓
Access permitted or denied

Follow the principle of least privilege when assigning permissions.

Step 11 - Understand SMB Channel Encryption

SMB channel encryption protects SMB traffic while it travels between the client and Azure Files.

Conceptually:

Client
  │
  │ encrypted SMB traffic
  ▼
Azure Files

This protects data in transit.

It should not be confused with encryption at rest.

Step 12 - Understand Kerberos

Kerberos is a ticket-based authentication protocol used in supported identity-based SMB scenarios.

Conceptually:

User
 │
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

Kerberos provides authentication; it does not replace authorization.

Step 13 - Review Networking

Open the Storage Account networking configuration.

Review whether the Storage Account allows:

Public network access
Selected networks
Private endpoints
Other network restrictions

For production environments, network access should follow organizational security requirements.

Step 14 - Review Security

Review the Storage Account security configuration.

Important concepts include:

Encryption at rest
Encryption in transit
Authentication
Authorization
Network restrictions
Access keys
Identity-based access

Avoid exposing storage resources more broadly than required.

Step 15 - Validate the Lab

Confirm:

 Storage Account exists
 File share was created
 File share quota was reviewed
 File share is visible in the portal
 Directory was created
 Test file was uploaded
 SMB concepts were reviewed
 Authentication mechanisms were reviewed
 Authorization concepts were reviewed
 SMB channel encryption was reviewed
 Kerberos concepts were reviewed
 Networking configuration was reviewed
 Security configuration was reviewed
 Screenshots were captured
Portal Navigation Summary

The primary navigation used in this lab is:

Azure Portal
    │
    ▼
Storage Accounts
    │
    ▼
Storage Account
    │
    ├── Data storage
    │      └── File shares
    │
    ├── Security + networking
    │      ├── Networking
    │      └── Configuration
    │
    └── Monitoring
Expected Result

At the end of the lab, the Storage Account should contain a working Azure File Share.

Example:

Storage Account
│
└── lab-files
    │
    └── documents
        │
        └── test.txt

The lab should also provide a basic understanding of how Azure Files uses file shares, SMB, authentication, authorization, encryption, and networking controls.