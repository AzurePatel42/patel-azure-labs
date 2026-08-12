# Lab 07 — Azure Storage Security

## Overview

This lab focuses on securing Azure Storage Accounts using multiple layers of security controls.

The objective is not simply to enable security features, but to understand how the controls work together to provide **defense in depth**.

The lab covers:

- Network security
- Public network access
- IP firewall rules
- Virtual network rules
- Network Security Perimeter
- Azure RBAC
- Management-plane vs data-plane access
- Storage Account access keys
- Shared Access Signatures (SAS)
- Encryption at rest
- Microsoft-managed keys
- Customer-managed keys
- Infrastructure encryption
- HTTPS/TLS
- Least privilege
- Defense in depth

---

# Architecture

```text
                         Internet
                            |
                    Network Security
                            |
             +--------------+--------------+
             |                             |
       IP / Firewall                 VNet / Private
          Rules                       Connectivity
             |                             |
             +--------------+--------------+
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
```

The architecture demonstrates that storage security is a combination of multiple controls.

---

# Learning Objectives

By completing this lab, I should be able to:

1. Explain Azure Storage network security.
2. Configure and understand public network access.
3. Understand IP-based firewall restrictions.
4. Understand virtual network restrictions.
5. Explain the purpose of Network Security Perimeter.
6. Understand Azure RBAC for Storage.
7. Distinguish management-plane and data-plane permissions.
8. Explain the security risks of Storage Account access keys.
9. Explain Shared Access Signatures.
10. Configure restricted delegated access concepts.
11. Explain encryption at rest.
12. Understand Microsoft-managed encryption keys.
13. Understand customer-managed keys.
14. Understand infrastructure encryption.
15. Explain HTTPS/TLS protection.
16. Apply least-privilege principles.
17. Design Storage security using defense in depth.

---

# Azure Storage Security Model

Azure Storage security can be viewed as several layers:

```text
Network Security
       ↓
Authentication
       ↓
Authorization
       ↓
Data Access
       ↓
Encryption
       ↓
Monitoring
```

Each layer solves a different security problem.

---

# 1. Network Security

Azure Storage supports network controls that determine where requests can originate.

Important controls include:

- Public network access
- IP address rules
- Virtual network rules
- Private endpoints
- Network Security Perimeter

Network security answers:

> **Where can the request come from?**

Network security does not replace authentication or authorization.

---

# 2. Public Network Access

Storage Accounts can provide public network access through their public endpoint.

Possible configurations include:

- Enabled from all networks
- Enabled from selected virtual networks and IP addresses
- Disabled

A public endpoint being reachable does not automatically mean the data is publicly accessible.

Authentication and authorization still determine whether access is allowed.

---

# 3. IP Firewall Rules

Storage Accounts can restrict public network access using IP addresses or ranges.

Conceptually:

```text
Approved IP
     |
     ↓
Storage Account
     |
     ↓
Allowed
```

while:

```text
Unapproved IP
     |
     ↓
Storage Account
     |
     ↓
Blocked
```

This creates a network-level security boundary.

---

# 4. Virtual Network Rules

Storage Accounts can restrict access to approved virtual networks and subnets.

Example:

```text
Virtual Network
      |
   Subnet
      |
      ↓
Storage Account
```

This allows network architecture to be part of the Storage security model.

---

# 5. Network Security Perimeter

Azure provides Network Security Perimeter capabilities for supported resources.

A Network Security Perimeter can help organizations centrally manage network access boundaries.

The important architectural concept is:

> Network boundaries can be managed centrally instead of configuring every resource independently.

For this lab, the feature was reviewed but no unnecessary perimeter infrastructure was created.

---

# 6. Authentication

Authentication answers:

> **Who are you?**

Azure Storage can use several authentication approaches.

Examples include:

- Microsoft Entra ID
- Storage Account access keys
- Shared Access Signatures

For Azure-native applications, identity-based authentication is often preferred when supported by the workload.

---

# 7. Authorization

Authorization answers:

> **What are you allowed to do?**

Azure RBAC provides role-based authorization.

Examples include:

- Reader
- Contributor
- Owner
- Storage Blob Data Reader
- Storage Blob Data Contributor
- Storage Blob Data Owner

The role should match the actual requirement.

---

# 8. Management Plane vs Data Plane

This distinction is critical.

## Management Plane

Controls the Azure resource.

Examples:

- View the Storage Account
- Change configuration
- Manage networking
- Modify resource settings

Examples of management roles:

```text
Reader
Contributor
Owner
```

## Data Plane

Controls access to the actual data.

Examples:

- Read blobs
- Write blobs
- Delete blobs
- Manage blob contents

Examples:

```text
Storage Blob Data Reader
Storage Blob Data Contributor
Storage Blob Data Owner
```

---

# 9. Important RBAC Lesson

Having:

```text
Reader
```

on a Storage Account does not necessarily mean:

```text
Read blob contents
```

Data-plane permissions are separate.

This distinction prevents a common misunderstanding when designing Azure permissions.

---

# 10. Access Keys

Azure Storage Accounts normally provide two access keys:

```text
key1
key2
```

Access keys are highly privileged credentials and must be protected.

Never commit them to source control.

Never place them in:

- GitHub
- README files
- Source code
- Screenshots
- Public documentation
- Chat messages

---

# 11. Key Rotation

Two keys allow applications to rotate credentials without unnecessary downtime.

Typical process:

```text
Application
    |
    | Uses key1
    ↓
Rotate key2
    |
    ↓
Update application
    |
    | Uses key2
    ↓
Rotate key1
```

This is a practical operational security pattern.

---

# 12. Shared Access Signature (SAS)

A Shared Access Signature provides delegated access to Azure Storage.

Instead of giving a client the Storage Account access key, a SAS can provide limited permissions.

A SAS can restrict:

- Services
- Resource types
- Permissions
- Start time
- Expiry time
- IP addresses
- Protocols

Conceptually:

```text
Storage Account
       |
       ↓
     SAS
       |
       +---- Scope
       +---- Permissions
       +---- Expiration
       +---- IP restriction
       +---- HTTPS
```

---

# 13. SAS Least Privilege

A SAS should follow:

```text
Minimum Scope
      +
Minimum Permissions
      +
Minimum Lifetime
      +
HTTPS
      +
Optional IP Restriction
```

A SAS should not provide broader access than necessary.

A SAS token should be treated as a secret.

---

# 14. SAS Services

Account-level SAS can potentially provide access to:

- Blob
- File
- Queue
- Table

The exact services should be selected based on the workload requirement.

---

# 15. SAS Permissions

Possible permissions include:

- Read
- Write
- Delete
- List
- Add
- Create
- Update
- Process

Grant only the permissions required.

---

# 16. SAS Time Restrictions

SAS supports start and expiry times.

Example:

```text
Start
  ↓
Temporary Access
  ↓
Expiration
  ↓
Access Ends
```

Short-lived access is generally preferable to unnecessarily long-lived credentials.

---

# 17. SAS Protocol

SAS can restrict protocols.

Options include:

- HTTPS only
- HTTPS and HTTP

For secure workloads:

> **HTTPS only should normally be preferred.**

---

# 18. Encryption at Rest

Azure Storage Service Encryption protects data at rest.

Conceptually:

```text
Application
     |
     ↓
Azure Storage
     |
     ↓
Storage Encryption
     |
     ↓
Encrypted Data
```

Azure automatically handles encryption and decryption for authorized access.

---

# 19. Microsoft-Managed Keys

The lab uses:

> **Microsoft-managed keys**

Microsoft manages the encryption key lifecycle.

This is the simpler operational model and is appropriate for many workloads.

---

# 20. Customer-Managed Keys

Azure Storage can support customer-managed keys for supported scenarios.

The architecture can look like:

```text
Organization
      |
      ↓
Azure Key Vault
      |
      ↓
Customer-Managed Key
      |
      ↓
Storage Encryption
```

Customer-managed keys provide additional control but also introduce additional responsibilities.

These include:

- Key lifecycle management
- Rotation
- Access control
- Monitoring
- Availability

They should be used when business, regulatory, or architectural requirements justify the added complexity.

---

# 21. Infrastructure Encryption

Infrastructure encryption provides an additional encryption layer for supported Storage configurations.

Conceptually:

```text
Data
 ↓
Storage Service Encryption
 ↓
Infrastructure Encryption
 ↓
Azure Infrastructure
```

For this lab:

> Infrastructure encryption was reviewed but not enabled.

---

# 22. Encryption in Transit

Encryption at rest protects stored data.

Encryption in transit protects data while it moves between systems.

Example:

```text
Client
   |
   | HTTPS / TLS
   ↓
Azure Storage
```

Both controls are important.

---

# 23. Secure Transfer

Azure Storage supports secure transfer requirements.

For secure workloads:

> **Secure transfer should normally remain enabled.**

This helps ensure supported requests use secure transport.

---

# 24. Defense in Depth

Storage security should not depend on a single control.

A layered architecture looks like:

```text
                Internet
                   |
             Network Rules
                   |
        +----------+----------+
        |                     |
     Firewall             Private Access
        |                     |
        +----------+----------+
                   |
             Authentication
                   |
          Microsoft Entra ID
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
```

If one layer is incorrectly configured, other layers can still provide protection.

---

# 25. Least Privilege

Least privilege means giving an identity only the permissions it needs.

Bad design:

```text
Application
     |
     ↓
Storage Account Key
     |
     ↓
Broad Access
```

Better design:

```text
Application
     |
     ↓
Microsoft Entra ID
     |
     ↓
Specific RBAC Role
     |
     ↓
Required Data
```

Least privilege reduces the potential impact of compromised credentials.

---

# 26. Access Method Comparison

| Method | Scope | Lifetime | Typical Use |
|---|---|---|---|
| Access Key | Broad | Long-lived until rotated | Application/storage authentication |
| SAS | Restricted | Time-limited | Delegated access |
| Entra ID + RBAC | Role-based | Identity controlled | Identity-based access |

General architectural preference:

```text
Microsoft Entra ID + RBAC
            ↓
Preferred for identity-based access
            ↓
SAS when delegated access is required
            ↓
Avoid distributing account keys when possible
```

The correct choice depends on the workload.

---

# Lab Portal Evidence

Screenshots collected during the lab are stored under:

```text
screenshots/
```

Expected evidence includes:

```text
01-storage-networking-public-access.png
02-network-firewall-ip-restriction.png
03-storage-security-configuration.png
04-rbac-access-control.png
05-access-keys.png
06-sas-configuration.png
07-storage-encryption.png
```

If a screenshot contains sensitive credentials, it must be sanitized or removed.

---

# CLI Security Review

Useful Azure CLI commands include:

### Storage Account

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount
```

### HTTPS

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query "enableHttpsTrafficOnly"
```

### Network Rules

```powershell
az storage account network-rule list `
  --resource-group $resourceGroup `
  --account-name $storageAccount
```

### Encryption

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query "encryption"
```

### RBAC

```powershell
az role assignment list `
  --scope $storageId `
  --output table
```

### Access Keys

```powershell
az storage account keys list `
  --resource-group $resourceGroup `
  --account-name $storageAccount
```

**Never commit the output of the Access Keys command.**

---

# Security Checklist

## Network

- [x] Public network access reviewed
- [x] IP firewall rules reviewed
- [x] Virtual network rules reviewed
- [x] Network Security Perimeter reviewed

## Identity

- [x] Authentication reviewed
- [x] Azure RBAC reviewed
- [x] Management-plane access reviewed
- [x] Data-plane access reviewed

## Credentials

- [x] Access Keys reviewed
- [x] Key rotation understood
- [x] SAS reviewed
- [x] SAS permissions reviewed
- [x] SAS expiration reviewed
- [x] SAS protocol restrictions reviewed

## Encryption

- [x] Storage Service Encryption reviewed
- [x] Microsoft-managed keys reviewed
- [x] Customer-managed keys reviewed
- [x] Infrastructure encryption reviewed
- [x] HTTPS/TLS reviewed

## Security Principles

- [x] Least privilege
- [x] Defense in depth
- [x] Secure transport
- [x] Credential protection
- [x] Network restriction

---

# What I Learned

This lab reinforced an important Azure architecture principle:

> **Security is layered.**

Network controls answer:

> Where can traffic originate?

Authentication answers:

> Who is making the request?

Authorization answers:

> What can that identity do?

Encryption answers:

> How is the data protected?

SAS answers:

> How can limited access be delegated?

RBAC answers:

> How can permissions be controlled?

Least privilege answers:

> How much access should an identity receive?

Defense in depth answers:

> What happens if one security layer fails?

---

# Solution Architect Perspective

A solution architect should not simply enable every available security feature.

The correct question is:

> **What security controls does this workload actually require?**

The design should consider:

- Data sensitivity
- Business requirements
- Compliance
- Network architecture
- Identity architecture
- Application architecture
- Operational complexity
- Cost
- Disaster recovery
- Monitoring

For example:

A simple development workload may use:

```text
Public Endpoint
      +
Microsoft Entra ID
      +
RBAC
      +
Microsoft-Managed Encryption
```

A highly sensitive production workload may require:

```text
Private Connectivity
      +
Network Restrictions
      +
Microsoft Entra ID
      +
Least-Privilege RBAC
      +
Customer-Managed Keys
      +
Monitoring
      +
Defense in Depth
```

The architecture should match the business requirement.

---

# Key AZ-104 Takeaways

Remember these concepts:

```text
NETWORK
Where can the request originate?

AUTHENTICATION
Who are you?

AUTHORIZATION
What can you do?

RBAC
What role does the identity have?

SAS
How can limited temporary access be delegated?

ACCESS KEYS
Why are broad credentials dangerous?

ENCRYPTION
How is data protected?

TLS
How is data protected in transit?

LEAST PRIVILEGE
How much access is actually required?

DEFENSE IN DEPTH
How do multiple controls work together?
```

---

# Final Lab Summary

Lab 07 demonstrates the major security controls available for Azure Storage.

The most important architectural lesson is:

> **Azure Storage security is a layered system combining network controls, identity, authorization, encryption, secure transport, and controlled data access.**

A strong Azure solution does not depend on a single security feature.

It combines the right controls according to:

```text
Business Requirements
        +
Data Sensitivity
        +
Compliance
        +
Network Architecture
        +
Identity Architecture
        +
Operational Requirements
        =
Security Architecture