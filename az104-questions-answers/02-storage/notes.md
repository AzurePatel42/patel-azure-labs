# AZ-104 Storage — Notes

## 1. Storage Hierarchy

Subscription
  +-- Resource Group
       +-- Storage Account
            +-- Container
                 +-- Blobs

Important distinction:

- Resource Group organizes Azure resources.
- Storage Account is the top-level Azure Storage resource.
- Container organizes blobs.
- Blob is the actual object/data.


## 2. Storage Account Mental Model

A Storage Account provides:

- Namespace
- Security boundary
- Configuration boundary

Storage services include:

- Blob Storage
- Azure Files
- Queue Storage
- Table Storage


## 3. Blob Storage

Blob Storage is object storage for unstructured data.

Examples:

- Images
- PDFs
- Videos
- Documents
- Backups
- Logs

Think:

Blob = object/data


## 4. Container

A container is a logical grouping and separation boundary for blobs.

Example:

Storage Account
  +-- invoices
  +-- images
  +-- reports

Important:

A container contains blobs, not arbitrary Azure resources.


## 5. Management Plane vs Data Plane

Management Plane:

Reader
Contributor
Owner

Used for managing or viewing Azure resources.

Data Plane:

Storage Blob Data Reader
Storage Blob Data Contributor

Used for accessing blob data.

Critical troubleshooting rule:

Reader ≠ permission to read blob contents.


## 6. RBAC Mental Model

Principal + Role + Scope = Effective Access

Example:

Developer
   +
Storage Blob Data Reader
   +
customer-a container
   =
Read blob data only in customer-a


## 7. Least Privilege

If a developer only needs to read blobs from one container:

Prefer:

Storage Blob Data Reader
at container scope

rather than granting broader access at the entire Storage Account.


## 8. Blob Access Tiers

| Tier | Typical Access Pattern | Main Idea |
|---|---|---|
| Hot | Frequent | Frequent access |
| Cool | Infrequent | Lower storage cost |
| Cold | Rare | Lower storage cost |
| Archive | Very rare | Lowest storage cost, slower retrieval |

Decision trigger:

How frequently will the data actually be accessed?


## 9. Lifecycle Management

Lifecycle Management automates blob tier transitions and deletion based on conditions.

Example:

Hot
  ? 30 days
Cool
  ? 180 days
Archive
  ? 7 years
Delete


## 10. Redundancy Mental Model

LRS
? Local redundancy

ZRS
? Availability-zone redundancy

GRS
? Geo-redundancy

GZRS
? Zone + geo-redundancy


## 11. ZRS vs Regional Failure

ZRS protects against an availability-zone failure within the primary Azure region.

ZRS alone does NOT protect against a complete regional outage.

For zone + regional protection:

GZRS


## 12. Important Interview Distinctions

Reader:
Management-plane access.

Storage Blob Data Reader:
Data-plane read access to blob contents.

Container:
Logical grouping of blobs.

Storage Account:
Top-level Azure Storage resource.

Lifecycle Management:
Automates tier transitions and deletion.

GZRS:
Protects against zone failure and regional failure.
## 13. Managed Identity

Managed Identity allows an Azure resource such as a VM or App Service to authenticate to Azure services without storing application credentials.

Mental model:

Azure Application
  |
  +-- Managed Identity
          |
          +-- Microsoft Entra ID
                  |
                  +-- Azure RBAC
                          |
                          +-- Storage Blob Data Reader


Important:

Managed Identity handles authentication.

Azure RBAC determines authorization.


## 14. Authentication vs Authorization

Authentication answers:

"Who are you?"

Example:

Managed Identity
  |
  +-- Microsoft Entra ID
  |
  +-- Identity established


Authorization answers:

"What are you allowed to do?"

Example:

Managed Identity
  |
  +-- Storage Blob Data Reader
  |
  +-- Read blob data


Mental model:

Authentication = identity

Authorization = permissions


## 15. Managed Identity vs SAS

Managed Identity:

- Identity-based authentication
- Uses Microsoft Entra ID
- Works with Azure RBAC
- Avoids storing application secrets
- Appropriate for Azure workloads accessing Azure resources


SAS:

- Delegated access mechanism
- Can be limited by scope
- Can specify permissions
- Can have an expiration time
- Useful for temporary or external access


Example:

Managed Identity
  =
Azure workload accessing Azure resource


SAS
  =
Temporary delegated access to specific data


Critical distinction:

SAS permissions are not Azure RBAC roles.


## 16. Key Vault vs Managed Identity

Azure Key Vault is designed to securely store and manage secrets, keys, and certificates.

Managed Identity can eliminate the need for an application to store a secret in the first place.

Example:

Secret-based approach:

Application
  |
  +-- Secret
        |
        +-- Key Vault
              |
              +-- Storage access


Managed Identity approach:

Application
  |
  +-- Managed Identity
          |
          +-- Microsoft Entra ID
                  |
                  +-- Azure RBAC
                          |
                          +-- Storage


Key idea:

If an Azure workload can use Managed Identity directly, do not introduce a stored secret unnecessarily.


## 17. Blob Data RBAC Roles

Storage Blob Data Reader:

- Read blob data
- Download blobs
- Does not provide write or delete permissions


Storage Blob Data Contributor:

- Read blob data
- Write blob data
- Delete blob data


Mental model:

Storage Blob Data Reader
  |
  +-- Read


Storage Blob Data Contributor
  |
  +-- Read
  +-- Write
  +-- Delete


Use the least-privilege role required by the workload.


## 18. SAS Permission Model

SAS does not use Azure RBAC role names.

Instead, a SAS can define delegated permissions such as:

- Read
- Write
- Delete

A SAS can also define:

- Resource scope
- Start time
- Expiration time

Example:

External Customer
  |
  +-- SAS
        |
        +-- Specific Blob
              |
              +-- Read
              +-- 24-hour expiration


This is different from:

Microsoft Entra ID
  |
  +-- RBAC Role
        |
        +-- Storage Blob Data Reader


## 19. AuthorizationPermissionMismatch

A successful authentication does not guarantee that an operation is authorized.

Example:

Application
  |
  +-- Managed Identity
          |
          +-- Authentication SUCCESS
                  |
                  +-- Storage Blob Data Reader
                          |
                          +-- Upload
                                |
                                +-- 403 AuthorizationPermissionMismatch


The identity is valid, but the assigned data-plane role does not allow the requested operation.

For blob upload, use:

Storage Blob Data Contributor

at the required scope.


Troubleshooting sequence:

1. Verify authentication.
2. Verify the assigned data-plane role.
3. Verify the RBAC scope.
4. Verify the requested operation is allowed by the role.
5. Check for other authorization or network restrictions.


## 20. Azure Files vs Blob Storage

Azure Blob Storage:

- Object storage
- Designed for unstructured data
- Images, PDFs, videos, backups, logs
- Accessed as blobs


Azure Files:

- Managed file shares
- Shared file-system access
- Supports protocols such as SMB
- Useful for applications expecting traditional file-share paths


Mental model:

Blob
  =
Object


Azure Files
  =
File share


## 21. Storage Q11-Q20 Core Mental Model

Azure workload
  |
  +-- Authentication
  |      |
  |      +-- Managed Identity
  |             |
  |             +-- Microsoft Entra ID
  |
  +-- Authorization
  |      |
  |      +-- Azure RBAC
  |             |
  |             +-- Storage Blob Data Reader
  |             +-- Storage Blob Data Contributor
  |
  +-- Temporary delegated access
         |
         +-- SAS

Key troubleshooting distinction:

Valid identity ≠ permission to perform every operation.

A 403 authorization error requires checking:

Identity
  +
Role
  +
Scope
  +
Requested operation
---

# Advanced Storage Notes - Q21-Q30

## 12. Managed Identity + Storage RBAC

For an Azure-hosted application that needs to access Blob Storage:

Application
    |
    +-- Managed Identity
            |
            v
      Microsoft Entra ID
            |
            v
       Azure RBAC
            |
            v
      Blob Storage

Authentication:
- Managed Identity
- Microsoft Entra ID

Authorization:
- Azure RBAC
- Storage Blob Data roles

Avoid storing Storage Account access keys in the application when Managed Identity can be used.

---

## 13. Storage Blob Data Roles

### Storage Blob Data Reader

Allows read access to blob data.

Use when:
- Application only needs to read blobs
- Developer needs read-only access
- Service should not modify data

### Storage Blob Data Contributor

Allows applications or users to read, write, and delete blob data.

Use when:
- Application uploads blobs
- Application modifies blobs
- Application deletes blobs

Mental model:

Read only
    |
    +-- Storage Blob Data Reader

Read + Write + Delete
    |
    +-- Storage Blob Data Contributor

---

## 14. Management Plane vs Data Plane - Advanced

Management plane examples:
- Create Storage Account
- Change Storage Account configuration
- Configure networking
- Assign RBAC roles

Data plane examples:
- Upload blob
- Download blob
- Delete blob
- Read blob contents

Important:

Reader
    |
    +-- Can view Azure resource metadata
    |
    +-- Does NOT automatically allow blob data access

For blob contents:

- Storage Blob Data Reader
- Storage Blob Data Contributor

---

## 15. RBAC Scope and Least Privilege

RBAC access should be granted at the narrowest practical scope.

Example:

Storage Account
    |
    +-- invoices
    |
    +-- reports
    |
    +-- images

If a developer only needs access to invoices:

Developer
    |
    +-- Storage Blob Data Reader
            |
            +-- invoices container

Do not grant Storage Account-wide access when container-level access is sufficient.

Mental model:

Principal + Role + Scope = Effective Access

---

## 16. Managed Identity vs SAS

Managed Identity is preferred for Azure-hosted applications when supported.

Managed Identity:

Azure Application
    |
    +-- Managed Identity
            |
            +-- Entra ID
                    |
                    +-- RBAC

SAS is useful for:
- Temporary access
- Delegated access
- External users or applications
- Specific resource access
- Limited permissions
- Limited lifetime

Mental model:

Managed Identity
    =
Application identity

SAS
    =
Delegated temporary access

---

## 17. Storage Account Keys vs Managed Identity

Storage Account access keys provide broad access to the Storage Account.

For Azure-hosted applications, prefer:

Managed Identity
    +
Microsoft Entra ID
    +
Azure RBAC

This avoids distributing long-lived storage credentials.

If an application asks for an access key, first determine whether Managed Identity can satisfy the requirement.

---

## 18. Private Endpoint

A Private Endpoint provides private connectivity to an Azure service.

For Storage:

VNet
  |
  +-- Private Endpoint
          |
          +-- Private IP
                  |
                  v
             Storage Account

Private Endpoint is primarily a networking feature.

It does not replace authentication or authorization.

Complete model:

Private Endpoint
    =
Network connectivity

Managed Identity / Entra ID
    =
Authentication

Azure RBAC
    =
Authorization

---

## 19. Private Endpoint vs Service Endpoint

Private Endpoint:
- Provides a private IP address in the VNet
- Used for private connectivity
- Can support disabling public network access

Service Endpoint:
- Provides optimized connectivity from a VNet to an Azure service
- Does not provide a private IP for the service in the VNet

When the requirement specifically says:

"Storage must have a private IP reachable from the VNet"

choose:

Private Endpoint

---

## 20. Private DNS with Private Endpoint

A Private Endpoint requires correct name resolution for reliable application connectivity.

The application normally connects using the Storage hostname.

The hostname should resolve through private DNS to the Private Endpoint IP.

Application
    |
    v
Storage hostname
    |
    v
Private DNS
    |
    v
Private Endpoint IP
    |
    v
Storage Account

If DNS resolves to the public endpoint when public access has been disabled, the application may fail even when RBAC is correct.

---

## 21. NSG vs Private Endpoint

Do not confuse Network Security Groups with Private Endpoints.

NSG:
- Controls network traffic
- Applies network security rules

Private Endpoint:
- Provides private connectivity to an Azure service

Mental model:

NSG
    =
Traffic control

Private Endpoint
    =
Private service connectivity

If the requirement is:

"Storage must not be reachable through the public internet and must have a private IP in the VNet"

the key feature is:

Private Endpoint

---

## 22. GRS vs RA-GRS vs Failover

GRS:
- Provides geo-replication to a secondary region.

RA-GRS:
- Provides geo-replication
- Provides read access to the secondary endpoint

Failover:
- Promotes the secondary region to the primary region

Mental model:

GRS
    =
Geo-replicated secondary

RA-GRS
    =
Geo-replicated secondary + read access

Failover
    =
Secondary becomes primary

Do not assume the secondary automatically becomes writable simply because GRS is configured.

---

## 23. GZRS

GZRS combines zone redundancy with geo-replication.

Primary Region
    |
    +-- Zone 1
    +-- Zone 2
    +-- Zone 3
    |
    +-------- Geo-replication -------->
                                      Secondary Region

GZRS is appropriate when both are important:

- Protection from availability-zone failure
- Protection from regional failure

Compare:

ZRS
    =
Zone redundancy

GRS
    =
Geo-redundancy

GZRS
    =
Zone + geo-redundancy

---

## 24. Storage Network + Identity Layers

Storage security should be evaluated in separate layers.

Layer 1 - Network
    |
    +-- Public access
    +-- Private Endpoint
    +-- VNet connectivity
    +-- DNS

Layer 2 - Authentication
    |
    +-- Managed Identity
    +-- Microsoft Entra ID

Layer 3 - Authorization
    |
    +-- Azure RBAC
    +-- Storage Blob Data roles

Layer 4 - Scope
    |
    +-- Container
    +-- Storage Account

Layer 5 - Data Lifecycle
    |
    +-- Hot
    +-- Cool
    +-- Archive
    +-- Delete

This layered model is useful for both architecture and troubleshooting.

---

## 25. Complete Storage Security Mental Model

A secure Azure application accessing Storage can look like:

App Service
    |
    +-- System-Assigned Managed Identity
    |
    +-- Microsoft Entra ID
    |
    +-- Storage Blob Data Contributor
    |       |
    |       +-- invoices container
    |
    +-- VNet Integration
            |
            +-- Private Endpoint
                    |
                    +-- Storage Account

Developers:

Developer Security Group
    |
    +-- Storage Blob Data Reader
            |
            +-- invoices container

Network:

Public network access = Disabled

Security principle:

Private network
    +
Strong identity
    +
Least-privilege authorization
    +
Narrow RBAC scope

---

## 26. Storage Advanced Decision Framework

When given a Storage scenario, ask these questions in order:

1. What data is being stored?
2. How frequently is it accessed?
3. What retention period is required?
4. What redundancy is required?
5. How will the application authenticate?
6. What data-plane permissions are required?
7. What RBAC scope is appropriate?
8. Does the service require private networking?
9. Is Private Endpoint required?
10. How will failures be diagnosed?

This turns Storage questions into an engineering decision process instead of memorization.
