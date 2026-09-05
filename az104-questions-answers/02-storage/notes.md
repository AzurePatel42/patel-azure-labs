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

Reader ? permission to read blob contents.


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
