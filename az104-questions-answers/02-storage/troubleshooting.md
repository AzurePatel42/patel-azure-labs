# AZ-104 Storage — Troubleshooting Q1–Q10

## Troubleshooting Pattern 1 — 403 Downloading Blob

### Symptom

Developer receives:

403 Forbidden

when attempting to download a blob.

### Existing Permission

Reader on the Storage Account.

### Diagnosis

Reader is a management-plane role.

It does not provide permission to read blob contents.

### Correct Direction

Check data-plane authorization.

Consider:

Storage Blob Data Reader

at the appropriate scope.


## Troubleshooting Pattern 2 — Wrong RBAC Role

### Symptom

User can view the Storage Account in Azure but cannot read a blob.

### Cause

Management-plane access was confused with data-plane access.

### Fix

Use a Blob Data role.

Read-only:

Storage Blob Data Reader

Read/write/delete:

Storage Blob Data Contributor


## Troubleshooting Pattern 3 — Wrong Scope

### Symptom

Developer has the correct data-plane role but can access more storage than intended.

### Cause

Role assigned at an overly broad scope.

### Fix

Apply least privilege.

Preferred hierarchy:

Container scope
   ?
Only when broader access is actually required
   ?
Storage Account scope


## Troubleshooting Pattern 4 — ZRS Misunderstanding

### Symptom

Architecture claims ZRS protects against a complete regional outage.

### Diagnosis

ZRS protects against availability-zone failure within the primary region.

### Correct Direction

If regional protection is required, use geo-redundancy.

For zone + regional protection:

GZRS.


## Troubleshooting Pattern 5 — Wrong Access Tier

### Symptom

Storage cost is unexpectedly high or access economics are poor.

### Investigation

Determine actual access frequency.

Frequent:
Hot

Infrequent:
Cool

Rare:
Cold

Very rare:
Archive


## Troubleshooting Pattern 6 — Manual Tier Management

### Symptom

Operations team manually changes blob tiers as data ages.

### Better Design

Use Blob Lifecycle Management.

Example:

After 30 days:
Hot ? Cool

After 180 days:
Cool ? Archive

After 7 years:
Delete


## Core Troubleshooting Rule

When troubleshooting Azure Storage:

1. Identify the operation.
2. Determine management plane vs data plane.
3. Check the assigned role.
4. Check the role scope.
5. Apply least privilege.
6. Check redundancy requirements.
7. Check access pattern and lifecycle policy.
## Troubleshooting Pattern 7 — SAS Chosen Instead of Managed Identity

### Symptom

An Azure application needs to access Blob Storage without storing credentials, but SAS is selected as the authentication solution.

### Diagnosis

SAS provides delegated, time-limited access.

For an Azure workload that needs to authenticate to Azure Storage, Managed Identity is generally the appropriate identity-based approach when supported.

### Correct Direction

Use:

Managed Identity
  |
  +-- Microsoft Entra ID
        |
        +-- Azure RBAC
              |
              +-- Storage Blob Data Reader/Contributor

Key distinction:

Managed Identity:
Identity-based authentication for Azure workloads.

SAS:
Delegated, time-limited access to storage resources.


## Troubleshooting Pattern 8 — Key Vault Used When No Secret Is Needed

### Symptom

An Azure VM needs Blob Storage access without storing credentials, but the proposed design stores a storage credential in Key Vault.

### Diagnosis

Key Vault securely stores and manages secrets, but using Key Vault does not eliminate the secret itself.

If the Azure workload supports Managed Identity, the workload can authenticate without storing a storage key or SAS token.

### Correct Direction

Prefer:

VM
  |
  +-- Managed Identity
        |
        +-- Microsoft Entra ID
              |
              +-- Storage Blob Data Reader
                    |
                    +-- Container

Key idea:

Key Vault protects secrets.

Managed Identity can eliminate the need for the secret.


## Troubleshooting Pattern 9 — Reader Cannot Upload Blob

### Symptom

An application successfully authenticates using Managed Identity but receives:

403 AuthorizationPermissionMismatch

when uploading a blob.

### Existing Permission

Storage Blob Data Reader.

### Diagnosis

Authentication is working.

Authorization is failing because Storage Blob Data Reader provides read-only data-plane access.

### Correct Direction

For read/write/delete blob operations:

Storage Blob Data Contributor

at the appropriate scope.

Mental model:

Authentication
  |
  +-- Managed Identity
        |
        +-- SUCCESS

Authorization
  |
  +-- Storage Blob Data Reader
        |
        +-- Upload denied


## Troubleshooting Pattern 10 — Reader Cannot Delete Blob

### Symptom

A developer can download blobs successfully but receives HTTP 403 when attempting to delete a blob.

### Existing Permission

Storage Blob Data Reader.

### Diagnosis

Storage Blob Data Reader allows reading blob data but does not allow deletion.

### Correct Direction

If deletion is required, use:

Storage Blob Data Contributor

at the required scope.

Do not grant a broader role than necessary.


## Troubleshooting Pattern 11 — SAS RBAC Confusion

### Symptom

A SAS-based access design describes permissions using Azure RBAC role names such as Storage Blob Data Reader.

### Diagnosis

SAS permissions and Azure RBAC roles are different authorization mechanisms.

### Correct Direction

For SAS, specify delegated permissions such as:

- Read
- Write
- Delete

For Microsoft Entra ID-based access, use Azure RBAC roles such as:

- Storage Blob Data Reader
- Storage Blob Data Contributor

Key distinction:

SAS permission = delegated access permission.

RBAC role = identity-based authorization assignment.


## Troubleshooting Pattern 12 — SAS Scope Too Broad

### Symptom

An external customer only needs to download one blob, but the access mechanism provides broader storage access.

### Diagnosis

The delegated access scope is broader than the requirement.

### Correct Direction

Restrict the SAS to:

- Specific blob
- Read permission only
- Required expiration time

Example:

External Customer
  |
  +-- SAS
        |
        +-- invoice123.pdf
              |
              +-- Read
              +-- 24-hour expiration


## Troubleshooting Pattern 13 — Blob vs Azure Files Confusion

### Symptom

A legacy application expects a traditional shared file-system path but Blob Storage is selected.

### Diagnosis

Blob Storage is object storage and does not provide the traditional managed file-share model expected by the application.

### Correct Direction

Use Azure Files for managed file shares.

Example requirement:

\\server\share\file.txt

Decision:

Azure Files

Reason:

Azure Files supports shared file-system access and protocols such as SMB.


## Troubleshooting Pattern 14 — Authentication Success Misread as Authorization Success

### Symptom

An application successfully authenticates to Azure Storage but receives a 403 when performing a storage operation.

### Diagnosis

Authentication and authorization are separate.

A valid identity only establishes who the caller is.

The caller must also have a role that permits the requested operation at the required scope.

### Correct Direction

Check:

1. Identity
2. Authentication method
3. Data-plane role
4. RBAC scope
5. Requested operation
6. Whether the role permits that operation

Mental model:

Identity
  +
Role
  +
Scope
  +
Operation
  =
Effective Access


## Troubleshooting Pattern 15 — Wrong Scope for Blob Access

### Symptom

An application has the correct Storage Blob Data role but access is either broader or narrower than intended.

### Diagnosis

The RBAC role may have been assigned at the wrong scope.

### Correct Direction

Use the narrowest scope that satisfies the requirement.

Example:

Application
  +
Storage Blob Data Contributor
  +
customer-a container
  =
Read/write/delete blob data in customer-a

Avoid assigning Storage Account scope when only one container requires access.


## Troubleshooting Pattern 16 — Choosing Redundancy for the Wrong Failure Domain

### Symptom

A design claims ZRS protects against an entire Azure regional outage.

### Diagnosis

ZRS provides availability-zone resilience within the primary region.

It does not provide geo-redundancy for a complete regional outage.

### Correct Direction

Zone failure only:

ZRS

Zone + regional failure:

GZRS

Key troubleshooting question:

"What failure domain must the storage design survive?"


## Troubleshooting Pattern 17 — Lifecycle Policy Not Matching Access Pattern

### Symptom

Storage costs remain higher than expected even though data becomes infrequently accessed over time.

### Diagnosis

The lifecycle policy may not match the actual access pattern or may not be configured.

### Correct Direction

Analyze the data lifecycle.

Example:

Frequent access
  |
  +-- Hot
        |
        +-- after 30 days
              |
              +-- Cool
                    |
                    +-- after 180 days
                          |
                          +-- Archive

Use Lifecycle Management to automate the transitions.


## Troubleshooting Pattern 18 — Upload Failure Investigation Sequence

### Symptom

An application receives a 403 while uploading a blob.

### Investigation

Follow this sequence:

1. Verify the application identity.
2. Confirm authentication succeeds.
3. Identify whether the operation is data-plane.
4. Check the assigned Storage Blob Data role.
5. Verify the RBAC scope.
6. Confirm the role permits upload/write.
7. Check network and storage configuration if authorization is correct.

Example:

Managed Identity
  |
  +-- Authentication SUCCESS
        |
        +-- Storage Blob Data Reader
              |
              +-- Upload
                    |
                    +-- 403

Likely fix:

Storage Blob Data Contributor

at the required scope.


## Storage Troubleshooting Mental Model

For a storage authorization problem, reason in this order:

Who is calling?
  |
  +-- Identity

How are they authenticated?
  |
  +-- Managed Identity
  +-- Microsoft Entra ID
  +-- SAS
  +-- Other supported mechanism

What are they allowed to do?
  |
  +-- Role / delegated permission

Where does the permission apply?
  |
  +-- Scope

What operation are they attempting?
  |
  +-- Read
  +-- Write
  +-- Delete

What failure domain must storage survive?
  |
  +-- Local
  +-- Zone
  +-- Region

What is the data access pattern?
  |
  +-- Hot
  +-- Cool
  +-- Cold
  +-- Archive

Core rule:

Authentication identifies the caller.

Authorization determines what the caller can do.

Scope determines where the permission applies.

The requested operation determines whether the assigned permission is sufficient.