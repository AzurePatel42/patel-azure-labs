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
