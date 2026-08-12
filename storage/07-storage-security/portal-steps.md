# Lab 07 — Azure Storage Security — Portal Steps

## 1. Lab Objective

Configure and review the major security controls available for an Azure Storage Account using the Azure Portal.

This lab covers:

- Public network access
- Firewall and IP restrictions
- Virtual network access
- Network Security Perimeter
- Access Control (IAM)
- Azure RBAC
- Storage Access Keys
- Shared Access Signatures (SAS)
- Storage Service Encryption
- Microsoft-managed keys
- Customer-managed keys
- Infrastructure encryption
- Secure transfer

---

# 2. Prerequisites

Before starting:

- Azure subscription
- Azure Portal access
- Existing Storage Account
- Appropriate permissions to view Storage Account configuration
- Web browser

Open:

**Azure Portal → Storage Accounts**

Select the Storage Account used for this lab.

---

# 3. Open Storage Account Networking

Navigate to:

**Storage Account → Security + networking → Networking**

Locate:

**Public network access**

The configuration may show:

> Enabled from all networks

This means the Storage Account's public endpoint is accessible from the public network, subject to authentication and authorization.

---

# 4. Review Public Network Access

Review the available options:

- Enabled from all networks
- Enabled from selected virtual networks and IP addresses
- Disabled

For this lab, first observe the existing configuration.

Do not change settings until instructed.

### Screenshot

Capture:

```text
screenshots/01-storage-networking-public-access.png

The screenshot should show:

Public network access
Network Security Perimeter
Resource network settings
5. Configure Selected Networks and IP Addresses

Under:

Public network access

select:

Enabled from selected virtual networks and IP addresses

Additional configuration options should appear.

These may include:

Virtual networks
Subnets
IP addresses
Exceptions
6. Configure an IP Restriction

Locate the firewall/IP address section.

If the portal provides:

Add your client IP address

use the current client IP when appropriate for the lab.

Alternatively, enter an approved public IP address/range that you control.

Do not enter arbitrary IP addresses.

Save the configuration.

The objective is to demonstrate that network access can be restricted to approved sources.

Screenshot

Capture:

screenshots/02-network-firewall-ip-restriction.png
7. Understand the Network Security Perimeter

On the Networking page, review:

Network security perimeter

A Network Security Perimeter can provide centralized network access management for supported Azure resources.

For this lab:

Review the feature
Understand its purpose
Do not create or associate a perimeter unnecessarily

The purpose of the lab is to understand the control rather than introduce additional infrastructure.

8. Review Storage Security Configuration

Navigate to:

Storage Account → Configuration

Review security-related settings.

Look for:

Secure transfer required
Minimum TLS version
Blob anonymous access settings
Infrastructure encryption
Other security-related configuration options available in the current portal

For a secure production workload, secure transport should normally remain enabled.

Screenshot

Capture:

screenshots/03-storage-security-configuration.png
9. Open Access Control (IAM)

Navigate to:

Storage Account → Access Control (IAM)

This is where Azure Role-Based Access Control is managed.

Review:

Check access
View my access
Role assignments
Add role assignment

Do not assign unnecessary permissions.

10. Review Current Access

Select:

Check access

or:

View my access

depending on the current portal interface.

Review the permissions assigned to your identity.

Understand the difference between:

Management-plane permissions
Data-plane permissions
11. Review Storage Data Roles

Select:

Add → Add role assignment

Browse the available roles.

Search for:

Storage Blob Data Reader

Review the role description.

Also review:

Storage Blob Data Reader
Storage Blob Data Contributor
Storage Blob Data Owner

Do not select:

Review + assign

unless the lab specifically requires assigning the role.

The objective here is to understand the permission model.

Screenshot

Capture:

screenshots/04-rbac-access-control.png

If this screenshot was already captured during the lab, keep the existing file.

12. Understand Management Plane vs Data Plane

Management-plane roles control the Azure resource.

Examples:

Reader
Contributor
Owner
Storage Account Contributor

Data-plane roles control access to storage data.

Examples:

Storage Blob Data Reader
Storage Blob Data Contributor
Storage Blob Data Owner

Important:

Reader access to the Storage Account does not automatically mean the user can read blob contents.

13. Open Access Keys

Navigate to:

Storage Account → Security + networking → Access keys

The Storage Account normally provides:

key1
key2
Connection strings

These are sensitive credentials.

Important

Do not:

Copy the actual keys into documentation
Paste them into GitHub
Put them in source code
Share them in chat
Include them in screenshots

Review the interface only.

14. Understand Key Rotation

Azure provides two access keys to support credential rotation.

Conceptual process:

Application uses key1
        ↓
Rotate key2
        ↓
Update application to use key2
        ↓
Rotate key1
        ↓
Continue operation

This allows credential rotation without unnecessarily interrupting applications.

Screenshot

Capture the Access Keys page only if the key values can be safely hidden or excluded.

Use:

screenshots/05-access-keys.png

Do not expose actual key values.

15. Open Shared Access Signature

Navigate to:

Storage Account → Shared access signature

Depending on the current portal interface, this may appear under:

Security + networking

or another Storage Account security section.

Review the Account SAS configuration.

16. Review SAS Services

Review:

Allowed services

Possible services include:

Blob
File
Queue
Table

Do not generate a SAS token simply for the purpose of taking a screenshot.

17. Review SAS Resource Types

Review:

Allowed resource types

Possible choices include:

Service
Container
Object

The selected resource types determine the scope of access.

18. Review SAS Permissions

Review available permissions such as:

Read
Write
Delete
List
Add
Create
Update
Process

The principle of least privilege should be applied.

Only permissions required by the client or application should be granted.

19. Review SAS Time Restrictions

Review:

Start and expiry date/time

A SAS should normally have an appropriate expiration time.

Avoid unnecessary long-lived SAS tokens.

Conceptual example:

Start
  ↓
Temporary access
  ↓
Expiration
  ↓
Access ends
20. Review SAS IP Restrictions

Review:

Allowed IP addresses

A SAS can be restricted to specific IP addresses or ranges.

This provides an additional security layer.

21. Review SAS Protocol

Review:

Allowed protocols

Available options may include:

HTTPS only
HTTPS and HTTP

For secure workloads:

HTTPS only should normally be preferred.

22. SAS Screenshot

Capture the SAS configuration page.

Do not generate or expose a SAS token.

Use:

screenshots/06-sas-configuration.png

The screenshot should show the configuration controls without exposing secrets.

23. Open Encryption Settings

Navigate to:

Storage Account → Security + networking → Encryption

Depending on the current portal interface, encryption settings may be located under:

Settings → Encryption

Review:

Storage service encryption

24. Review Encryption Type

Review the available encryption options:

Microsoft-managed keys
Customer-managed keys

The lab Storage Account uses:

Microsoft-managed keys

Microsoft-managed keys allow Azure to manage the encryption key lifecycle.

25. Review Customer-Managed Keys

Review:

Enable support for customer-managed keys

Customer-managed keys can provide additional organizational control over encryption keys.

They commonly involve:

Azure Key Vault → Customer-managed key → Storage encryption

Do not configure customer-managed keys unless specifically required.

26. Review Infrastructure Encryption

Review:

Infrastructure encryption

The lab configuration shows:

Disabled

Infrastructure encryption provides an additional encryption layer for supported configurations.

For this lab, review the setting without enabling it.

27. Encryption Screenshot

Capture the encryption configuration.

Use:

screenshots/07-storage-encryption.png

The screenshot should show:

Storage service encryption
Encryption type
Microsoft-managed keys
Customer-managed key option
Infrastructure encryption

Do not expose sensitive information.

28. Review Secure Transfer

Return to:

Storage Account → Configuration

Locate:

Secure transfer required

For secure workloads, this should normally be:

Enabled

Secure transfer requires supported requests to use secure transport.

This protects data while it is transmitted.

29. Understand HTTPS and TLS

The security model is:

Client
  |
  | HTTPS / TLS
  |
  v
Azure Storage

Encryption at rest protects stored data.

TLS protects data in transit.

Both are important security controls.

30. Review Anonymous Access

Review the Storage Account configuration for settings related to anonymous access.

Anonymous access should not be enabled unless there is an explicit business requirement.

For sensitive workloads, access should normally be authenticated and authorized.

31. Security Architecture Review

The final architecture can be understood as:

                    Internet
                       |
                Network Controls
                       |
            +----------+----------+
            |                     |
       Firewall/IP            VNet/Private
         Rules                 Connectivity
            |                     |
            +----------+----------+
                       |
                Authentication
                       |
             Microsoft Entra ID
                 or SAS
                       |
                Authorization
                       |
                  Azure RBAC
                       |
                  Storage Data
                       |
                  Encryption
                       |
                Protected Data
32. Security Validation Checklist

Before completing the lab, verify:

 Public network access reviewed
 IP firewall configuration reviewed
 Network Security Perimeter reviewed
 Storage security configuration reviewed
 Access Control (IAM) reviewed
 RBAC roles reviewed
 Access Keys reviewed
 SAS configuration reviewed
 Storage encryption reviewed
 Microsoft-managed keys reviewed
 Customer-managed keys reviewed
 Infrastructure encryption reviewed
 Secure transfer reviewed
 Screenshots captured
 No secrets exposed in screenshots
33. Lab Evidence

The lab screenshots should be stored under:

07-storage-security/
└── screenshots/
    ├── 01-storage-networking-public-access.png
    ├── 02-network-firewall-ip-restriction.png
    ├── 03-storage-security-configuration.png
    ├── 04-rbac-access-control.png
    ├── 05-access-keys.png
    ├── 06-sas-configuration.png
    └── 07-storage-encryption.png

If an access-key screenshot exposes credentials, remove it or replace it with a sanitized screenshot.

34. Cleanup

If temporary firewall or network restrictions were added specifically for the lab and are no longer required, review them before finishing.

Do not delete the Storage Account if it is used by other labs.

Do not delete resources that belong to other workloads.

Review any temporary permissions or configurations created during the lab.

35. Final Portal Review

Before leaving the Azure Portal, confirm that you understand:

How network access is controlled
How IP restrictions work
How Azure RBAC controls access
Difference between management-plane and data-plane roles
Why Storage Account keys are sensitive
How SAS provides delegated access
How SAS permissions can be restricted
How SAS expiration works
How encryption at rest works
How Microsoft-managed and customer-managed keys differ
How HTTPS/TLS protects data in transit
How defense in depth applies to Azure Storage
36. Lab Completion Statement

Lab 07 demonstrates that Azure Storage security is not a single configuration.

A secure Storage Account combines:

Network Security
        +
Authentication
        +
Authorization
        +
Encryption
        +
Least Privilege
        +
Secure Transport
        +
Monitoring

The solution architect's responsibility is to select the appropriate combination of controls based on the workload, data sensitivity, compliance requirements, network architecture, and operational requirements.