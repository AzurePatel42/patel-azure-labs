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