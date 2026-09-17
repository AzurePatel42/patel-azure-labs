# AZ-104 Mistakes & Corrections

## Identity & Governance

### Mistake 1 — Azure RBAC vs Guest OS Permissions

**Concept:**
Azure resource permissions and permissions inside the guest operating system are separate security layers.

**Common Reasoning Error:**
Assuming that having the Azure Contributor role automatically provides administrator access to the Windows VM.

**Why This Is Wrong:**
Azure RBAC controls what a user can do to Azure resources through the Azure management plane.

Guest OS permissions control what a user can do inside Windows or Linux.

**Correct Reasoning:**

Azure RBAC
    ->
Azure Resource Management
    ->
VM Resource

Separate layer:

Guest OS Authentication
    ->
Windows / Linux Permissions
    ->
Administrator or User Access

**Key Correction:**
Contributor -> Windows Administrator

A user may be able to manage the VM resource in Azure without being able to log into the guest operating system.

**AZ-104 Role Distinction:**
- Virtual Machine User Login -> standard VM login access
- Virtual Machine Administrator Login -> administrator-level VM login access
- Contributor -> manage Azure resources, but does not automatically grant guest OS login privileges

**Retest Required:**
Yes

---

## Mistake 2 — User-Assigned Managed Identity Lifecycle

**Concept:**
A User-Assigned Managed Identity (UAMI) is an independent Azure resource.

**Common Reasoning Error:**
Assuming that deleting and recreating a workload automatically recreates or reattaches its UAMI.

**Why This Is Wrong:**
The UAMI has its own lifecycle.

Deleting the workload does not delete the UAMI.

Recreating the workload does not automatically attach the existing UAMI.

**Correct Reasoning:**

UAMI
  ->
Independent Azure Resource
  ->
Attached to Workload

Delete Workload
  ->
UAMI remains

Recreate Workload
  ->
UAMI must be explicitly attached again

**Key Correction:**
UAMI survives the workload, but the workload does not automatically come back with the UAMI attached.

**Retest Required:**
Yes

---

## Mistake 3 — Management Plane vs Data Plane

**Concept:**
Azure resource management permissions and data access permissions are different.

**Common Reasoning Error:**
Assuming that being able to manage a storage account automatically means being able to read or write blobs.

**Why This Is Wrong:**
Management-plane permissions control Azure resources.

Data-plane permissions control access to the data inside those resources.

**Correct Reasoning:**

Management Plane
    ->
Manage Azure Resource

Data Plane
    ->
Access Resource Data

**Key Correction:**
Management access -> automatic data access

For Blob data operations, select an appropriate Storage Blob Data role.

**Retest Required:**
Yes

---

## Mistake 4 — Authentication vs Authorization

**Concept:**
Authentication and authorization answer different questions.

**Common Reasoning Error:**
Treating successful authentication as proof that the user is allowed to perform the requested operation.

**Correct Reasoning:**

Authentication
    ->
Who are you?

Authorization
    ->
What are you allowed to do?

A successful authentication does not automatically provide authorization.

**Retest Required:**
Yes

