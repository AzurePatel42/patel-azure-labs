# AZ-104 Storage — Scenarios Q1–Q10

## Scenario 1 — Choosing Blob Storage

Requirement:
Store images and PDFs.

Decision:
Use Blob Storage.

Reason:
Images and PDFs are unstructured/object data.


## Scenario 2 — Organizing Customer Data

Requirement:
Separate blobs for customer-a, customer-b, and customer-c.

Decision:
Use separate containers.

Example:

Storage Account
  +-- customer-a
  +-- customer-b
  +-- customer-c


## Scenario 3 — Read-Only Blob Access

Requirement:
Developer can download blobs but cannot modify or delete them.

Decision:
Storage Blob Data Reader.

Scope:
Specific container when possible.

Reason:
Least privilege + data-plane read access.


## Scenario 4 — Zone Failure

Requirement:
Protect storage from an availability-zone failure.

Decision:
ZRS.

Reason:
Data is replicated across availability zones within the primary region.


## Scenario 5 — Regional Failure

Requirement:
Protect storage from an Azure regional outage.

Decision:
Use geo-redundancy.

When both zone and regional resilience are required:

GZRS.


## Scenario 6 — Frequently Accessed Data

Requirement:
Application frequently reads blobs.

Decision:
Hot tier.

Reason:
The access pattern is frequent.


## Scenario 7 — Changing Access Pattern

Requirement:
Data is frequently accessed initially but becomes less frequently accessed over time.

Decision:
Use Lifecycle Management.

Example:

Hot ? Cool ? Archive


## Scenario 8 — Retention Policy

Requirement:
Invoices must eventually be deleted after 7 years.

Decision:
Use Lifecycle Management with a deletion condition.

Example:

Hot ? Cool ? Archive ? Delete


## Scenario 9 — Management vs Data Plane

Requirement:
Developer can see the Storage Account but cannot download blobs.

Existing role:
Reader.

Problem:
Reader is management-plane access.

Solution:
Assign Storage Blob Data Reader for blob data access.


## Scenario 10 — Least Privilege Design

Requirement:
Developer needs read-only access to one customer container.

Preferred design:

Principal:
Developer

Role:
Storage Blob Data Reader

Scope:
customer-a container

Avoid unnecessarily granting access at the entire Storage Account scope.
## Scenario 11 — Azure Workload Without Stored Credentials

Requirement:
An Azure application needs to access Blob Storage without storing a storage key, password, or other secret.

Decision:
Use Managed Identity with Microsoft Entra ID and Azure RBAC.

Example:

Application
  +-- Managed Identity
       +-- Microsoft Entra ID
            +-- Storage Blob Data Reader

Reason:
Managed Identity allows the Azure workload to authenticate without storing application credentials.


## Scenario 12 — Automatic Tier Transition

Requirement:
Blobs are frequently accessed for the first 30 days and then become infrequently accessed.

Decision:
Use Lifecycle Management.

Example:

Hot
  ? after 30 days
Cool

Reason:
Lifecycle Management automatically changes the blob access tier based on conditions such as blob age.


## Scenario 13 — Availability-Zone Protection

Requirement:
Storage must remain resilient if an entire availability zone fails. Regional outage protection is not required.

Decision:
Use ZRS.

Reason:
ZRS replicates data across availability zones within the primary Azure region.


## Scenario 14 — Application Upload and Read Access

Requirement:
An application must upload and read invoice blobs in customer-a but does not need access to other containers.

Decision:
Storage Blob Data Contributor.

Scope:
customer-a container.

Reason:
The role provides the required data-plane read/write/delete permissions while keeping access limited to the required container.


## Scenario 15 — Long-Term Invoice Lifecycle

Requirement:
Invoices are frequently accessed for 30 days, rarely accessed after 30 days, almost never accessed after 180 days, and must be deleted after 7 years.

Decision:
Use Lifecycle Management.

Example:

Hot
  ? 30 days
Cool
  ? 180 days
Archive
  ? 7 years
Delete

Reason:
The lifecycle policy automatically transitions data through appropriate storage tiers and eventually deletes it according to the retention requirement.


## Scenario 16 — VM Accessing Blob Storage

Requirement:
An Azure VM needs to read blobs without storing a storage key or SAS token in application configuration.

Decision:
Use the VM's Managed Identity with Storage Blob Data Reader.

Scope:
Required container.

Reason:
Managed Identity provides authentication through Microsoft Entra ID, while Azure RBAC provides authorization.


## Scenario 17 — Read Access but Delete Fails

Requirement:
A developer can download blobs but receives HTTP 403 when attempting to delete them.

Existing role:
Storage Blob Data Reader.

Problem:
Storage Blob Data Reader provides read-only blob data access.

Solution:
Use Storage Blob Data Contributor when read, write, and delete operations are required.

Scope:
Required container.

Reason:
The existing role authorizes reading but not deleting.


## Scenario 18 — Temporary External Blob Access

Requirement:
An external customer needs to download one specific blob for 24 hours. The customer must not receive the Storage Account key.

Decision:
Use a SAS token.

Configuration:

- Specific blob scope
- Read permission only
- 24-hour expiration

Reason:
SAS provides delegated and time-limited access without exposing the Storage Account key.

Important:
SAS permissions are not Azure RBAC roles.


## Scenario 19 — Legacy Shared File System

Requirement:
A legacy application running on multiple Azure VMs expects a traditional shared file-system path such as `\\server\share\file.txt`.

Decision:
Use Azure Files.

Reason:
Azure Files provides managed file shares and supports protocols such as SMB, making it appropriate for applications expecting traditional file-share access.


## Scenario 20 — 403 AuthorizationPermissionMismatch

Requirement:
An application successfully authenticates using Managed Identity but receives `403 AuthorizationPermissionMismatch` when uploading a blob.

Existing role:
Storage Blob Data Reader.

Scope:
Required container.

Problem:
Authentication is successful, but the assigned data-plane role does not permit blob uploads.

Solution:
Use Storage Blob Data Contributor at the required scope.

Troubleshooting model:

Authentication
  +-- Managed Identity
       +-- SUCCESS

Authorization
  +-- Storage Blob Data Reader
       +-- Upload denied

Fix:
Storage Blob Data Contributor.

Reason:
A valid identity does not automatically have permission to perform every storage operation.
---

# Advanced Storage Scenarios - Q21-Q30

## Scenario 21 - Secure Developer and Application Access

### Requirement

Developers need access to one production container.

The application also needs to upload and read blobs.

### Design

Developers:

Developer Security Group
    |
    +-- Storage Blob Data Reader
            |
            +-- invoices container

Application:

App Service
    |
    +-- Managed Identity
            |
            +-- Storage Blob Data Contributor
                    |
                    +-- invoices container

### Key Lesson

Different principals can receive different roles at the same container scope.

Least privilege should be designed separately for each workload.

---

## Scenario 22 - Zone and Regional Protection

### Requirement

A production Storage Account must survive an availability-zone failure and provide protection against a regional outage.

### Decision

Use GZRS.

### Reasoning

ZRS
    |
    +-- Zone protection

GRS
    |
    +-- Regional geo-replication

GZRS
    |
    +-- Zone protection
    +
    +-- Geo-replication

### Key Lesson

Always identify whether the scenario requires zone protection, regional protection, or both.

---

## Scenario 23 - Managed Identity Can Authenticate but Upload Fails

### Requirement

An App Service uses Managed Identity.

Authentication works, but blob uploads return 403.

### Investigation

Check data-plane authorization.

The application requires:

Storage Blob Data Contributor

at the required container scope.

### Common Mistake

Granting a management-plane role or a role-assignment permission does not automatically grant permission to upload blob data.

### Key Lesson

Authentication success does not prove authorization success.

---

## Scenario 24 - Private Storage Account

### Requirement

A Storage Account must not be reachable from the public internet.

An application inside a VNet requires access.

### Design

Application
    |
    v
VNet
    |
    v
Private Endpoint
    |
    v
Storage Account

Configure:

Public network access = Disabled

Authentication remains:

Managed Identity + Entra ID

Authorization remains:

Azure RBAC

### Key Lesson

Private networking does not replace identity-based authorization.

---

## Scenario 25 - Application Requests Storage Access Key

### Requirement

A production application asks for the Storage Account access key.

### Decision

Do not automatically approve it.

First evaluate whether:

Managed Identity
    +
Microsoft Entra ID
    +
Azure RBAC

can satisfy the requirement.

### Key Lesson

Access keys are credentials.

For Azure-hosted applications, Managed Identity is generally preferred when supported.

SAS remains useful for delegated or temporary access.

---

## Scenario 26 - Private Endpoint Selection

### Requirement

An App Service must access Storage privately.

Public network access must be disabled.

The Storage service must have a private IP reachable from the VNet.

### Decision

Use:

Private Endpoint

### Complete model

App Service
    |
    +-- VNet Integration
            |
            +-- Private Endpoint
                    |
                    +-- Storage Account

Identity:

Managed Identity
    +
Entra ID
    +
RBAC

### Key Lesson

Network connectivity and authorization are separate decisions.

---

## Scenario 27 - Regional Storage Outage

### Requirement

A Storage Account uses GRS.

The primary region becomes unavailable.

The team expects the secondary region to automatically become writable.

### Decision

The expectation is incorrect.

GRS provides the secondary replica but does not mean the secondary is automatically the active writable endpoint.

RA-GRS allows read access to the secondary.

A failover operation promotes the secondary.

### Key Lesson

Know the difference between:

Replication
Read access
Failover

---

## Scenario 28 - 403 After Private Endpoint Deployment

### Requirement

An application worked before a Private Endpoint was deployed.

After public access is disabled, uploads return 403.

Managed Identity and Storage Blob Data Contributor have already been verified.

### Investigation Order

1. Private Endpoint connection
2. Private DNS
3. DNS resolution
4. Private IP reachability
5. VNet connectivity
6. Storage networking configuration
7. RBAC

### Key Lesson

The most recent infrastructure change is an important troubleshooting clue.

If identity and authorization are already verified, investigate the new network path.

---

## Scenario 29 - Automated Invoice Lifecycle

### Requirement

Invoices are:

- Frequently accessed for 30 days
- Occasionally accessed through day 180
- Rarely accessed after day 180
- Retained for 7 years
- Deleted automatically afterward

### Design

Hot
 |
 | 30 days
 v
Cool
 |
 | 180 days
 v
Archive
 |
 | 7 years
 v
Delete

Use:

Azure Storage Lifecycle Management

### Key Lesson

Lifecycle policy should follow both access frequency and retention requirements.

---

## Scenario 30 - Complete Production Storage Architecture

### Requirement

An App Service must:

- Use Managed Identity
- Upload invoices
- Read invoices
- Avoid Storage Account keys
- Access Storage privately
- Allow developers read-only access
- Disable public network access

### Architecture

Azure
  |
  +-- App Service
  |       |
  |       +-- System-Assigned Managed Identity
  |       |
  |       +-- Entra ID
  |       |
  |       +-- Storage Blob Data Contributor
  |               |
  |               +-- invoices container
  |
  +-- Developers
          |
          +-- Security Group
                  |
                  +-- Storage Blob Data Reader
                          |
                          +-- invoices container

Network:

App Service VNet Integration
    |
    +-- Private Endpoint
            |
            +-- Storage Account

Public network access = Disabled

### Key Lesson

A strong production architecture separates:

Identity
+
Authorization
+
RBAC Scope
+
Network

Each layer solves a different problem.

---

## Advanced Storage Scenario Pattern

For complex Storage questions, reason in this order:

Requirement
    |
    v
Data
    |
    v
Access Pattern
    |
    v
Lifecycle
    |
    v
Redundancy
    |
    v
Authentication
    |
    v
Authorization
    |
    v
RBAC Scope
    |
    v
Network
    |
    v
Troubleshooting

This is the Storage engineering decision framework.
