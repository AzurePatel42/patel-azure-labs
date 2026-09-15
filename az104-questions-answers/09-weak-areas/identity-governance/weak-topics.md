# Identity & Governance — Weak Topics

## Purpose

This file contains Identity & Governance weak areas identified during AZ-104
question practice and subsequent brainstorming/retesting.

---

## 1. VM Guest OS Login vs Azure RBAC

### Core distinction

- Azure RBAC controls Azure resource management.
- Guest OS permissions control access inside the Windows/Linux operating system.
- Contributor does not automatically provide Windows Administrator or RDP/SSH access.

### Important roles

- Virtual Machine User Login -> normal guest OS login.
- Virtual Machine Administrator Login -> administrator-level guest OS login.
- Contributor -> Azure resource management; does not automatically grant guest OS login.

### Mental model

Azure Resource Management
        ->
Azure RBAC

Guest OS Access
        ->
VM User/Admin Login roles

These are separate permission layers.

### Status

MASTERED

---

## 2. User-Assigned Managed Identity Lifecycle

### Core distinction

- A UAMI is a separate Azure resource with its own lifecycle.
- Deleting a workload does not automatically delete the UAMI.
- Creating a replacement workload does not automatically attach the existing UAMI.
- The UAMI must be explicitly attached to the replacement workload.
- RBAC permissions assigned to the UAMI remain with the identity.

### Access chain

UAMI exists
    ->
Explicitly attach to workload
    ->
Assign appropriate RBAC
    ->
Workload accesses Azure resource

### Status

MASTERED

---

## 3. Authentication vs Authorization

### Core distinction

- Authentication = Who are you->
- Authorization = What are you allowed to do->
- Successful Entra ID authentication does not automatically provide access to blob data.
- Appropriate data-plane RBAC is required for blob data access.

### Example

Entra ID authentication
    ->
Authentication succeeds
    ->
Check authorization
    ->
Storage Blob Data Reader
    ->
Blob read access

### Status

MASTERED

---

## 4. Management Plane vs Data Plane

### Core distinction

Management plane:
- Create Azure resources.
- Delete Azure resources.
- Configure Azure resources.
- Change Storage Account networking/firewall configuration.

Data plane:
- Read blob data.
- Write blob data.
- Delete blob data.

### Important distinction

- Contributor is a management-plane/resource-management role.
- Storage Blob Data Reader is a data-plane role.
- Storage Blob Data Contributor is a data-plane role.

Management permissions do not automatically grant data access.

### Status

MASTERED

---

## 5. Least-Privilege Role Selection

### Core principle

Grant the narrowest permission that satisfies the required operation.

### Examples

Read blobs only:
-> Storage Blob Data Reader

Change Storage Account networking:
-> Appropriate management-plane permission

Restart a VM only:
-> Look for the narrowest permission/action required rather than automatically granting Contributor.

No RDP/SSH requirement:
-> Do not grant VM guest OS login permissions.

### Status

MASTERED

---

## 6. RBAC Scope and Inheritance

### Core model

Role = WHAT you can do

Scope = WHERE you can do it

Inheritance = permissions flow from parent scope to child scope

### Examples

Storage Blob Data Reader
    ->
Storage Account scope
    ->
All containers under that Storage Account

Storage Blob Data Reader
    ->
Container A scope
    ->
Container A only

A new container created under a Storage Account with the role
assigned at the Storage Account scope inherits that applicable permission.

### Status

MASTERED

---

# Cross-Domain Mental Model

Authentication
    ->
Authorization
    ->
Scope
    ->
Management Plane / Data Plane
    ->
Resource
    ->
Required Action
    ->
Least Privilege
