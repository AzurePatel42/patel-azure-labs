# Identity & Governance — Mistakes & Corrections

## 1. Contributor vs Guest OS Access

### Mistake

Assuming an Azure Contributor can automatically RDP into a Windows VM
or administer the guest operating system.

### Correction

Azure RBAC and guest OS permissions are separate.

- Contributor -> Azure resource management
- Virtual Machine User Login -> normal guest OS login
- Virtual Machine Administrator Login -> administrator-level guest OS login

### Lesson

Azure resource permissions do not automatically provide guest OS access.

---

## 2. UAMI Reattachment

### Mistake

Assuming a replacement workload automatically receives the same
user-assigned managed identity.

### Correction

A UAMI has its own lifecycle.

The replacement workload must have the existing UAMI explicitly attached.

### Lesson

UAMI survives the workload, but attachment does not automatically return
with a recreated workload.

---

## 3. Management Plane vs Data Plane

### Mistake

Assuming a management role such as Contributor automatically provides
blob data access.

### Correction

Management-plane permissions and data-plane permissions are separate.

- Contributor -> management plane
- Storage Blob Data Reader -> blob data read
- Storage Blob Data Contributor -> blob data read/write/delete

### Lesson

Management access does not automatically equal data access.

---

## 4. Authentication vs Authorization

### Mistake

Assuming successful Entra ID authentication automatically grants access
to blob data.

### Correction

Authentication establishes identity.

Authorization determines what that identity is permitted to access.

### Lesson

Authentication != Authorization.

---

## 5. Least Privilege

### Mistake

Using Contributor when an application only needs to read blobs.

### Correction

Use Storage Blob Data Reader when read-only blob access is required.

### Lesson

Choose the narrowest role that satisfies the requirement.

---

## 6. RBAC Scope

### Mistake

Assuming a role assigned at Container A applies to Container B.

### Correction

A role assigned at Container A scope applies to Container A,
not sibling Container B.

### Lesson

Always verify both the role and its scope.

---

# Retest Status

All Identity & Governance scenarios completed successfully.

Status: MASTERED
