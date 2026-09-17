# AZ-104 Weak-Area Retest Queue

## Purpose

This file contains concepts that require targeted retesting after
completion of the Identity & Governance, Storage, and Compute
question foundations.

The goal is reliable reasoning, not simply increasing question scores.

---

# Priority 1 — Highest Risk

## 1. VM Health vs Application Health
**Domain:** Compute

### Must Be Able To Explain
- A VM can be running while the application is unhealthy.
- VM-level health does not prove application-level health.
- Troubleshooting must distinguish infrastructure health from application health.

**Retest:** Complete
**Status:** PASSED

---

## 2. Management Plane vs Data Plane
**Domain:** Identity / Storage

### Must Be Able To Explain
- Management plane controls Azure resource management.
- Data plane controls access to resource data.
- Management permissions do not automatically provide data access.

**Retest:** Required
**Status:** NOT RETESTED

---

## 3. Managed Identity vs SAS
**Domain:** Identity / Storage

### Must Be Able To Explain
- Managed Identity provides workload identity.
- Microsoft Entra ID + Azure RBAC can provide access for supported Azure-hosted workloads.
- SAS provides temporary or delegated access.
- Choose the access model based on the scenario.

**Retest:** Required
**Status:** NOT RETESTED

---

## 4. Private Endpoint DNS Troubleshooting
**Domain:** Storage

### Must Be Able To Explain
- Private Endpoint provides private connectivity.
- DNS resolution must point the client toward the private endpoint.
- When public access is disabled, DNS configuration becomes especially important.
- Troubleshooting should separate RBAC problems from network/DNS problems.

**Retest:** Required
**Status:** NOT RETESTED

---

## 5. Capacity vs Traffic Distribution
**Domain:** Compute

### Must Be Able To Explain
- VMSS manages VM instances and scaling.
- Load Balancer distributes traffic.
- Scaling increases capacity.
- Load balancing distributes requests across healthy instances.

**Retest:** Complete
**Status:** PASSED

---

# Priority 2 — Important

## 6. VM Guest OS Login
**Domain:** Identity / Compute

### Must Be Able To Explain
- Azure RBAC and guest OS permissions are separate layers.
- Contributor does not automatically provide guest OS administrator access.
- Virtual Machine User Login provides standard login access.
- Virtual Machine Administrator Login provides administrator-level login access.

**Retest:** Required
**Status:** NOT RETESTED

---

## 7. User-Assigned Managed Identity Lifecycle
**Domain:** Identity

### Must Be Able To Explain
- UAMI is an independent Azure resource.
- Deleting a workload does not delete the UAMI.
- Recreating the workload does not automatically reattach the UAMI.

**Retest:** Required
**Status:** NOT RETESTED

---

## 8. GRS vs RA-GRS vs Failover
**Domain:** Storage

### Must Be Able To Explain
- GRS provides geo-replication.
- RA-GRS provides read access to the secondary.
- Failover promotes the secondary to the primary.

**Retest:** Required
**Status:** NOT RETESTED

---

## 9. Private Endpoint vs NSG
**Domain:** Storage / Networking

### Must Be Able To Explain
- Private Endpoint provides private connectivity.
- It does not replace authentication or authorization.
- Network controls and identity controls solve different problems.

**Retest:** Required
**Status:** NOT RETESTED

---

## 10. Layer-by-Layer VM Troubleshooting
**Domain:** Compute

### Troubleshooting Order

Client
  ?
Network
  ?
Load Balancer
  ?
VM
  ?
Operating System
  ?
Application
  ?
Dependencies

**Retest:** Complete
**Status:** PASSED

---

# Priority 3 — Reinforcement

## 11. Storage Blob Data Role Selection
**Domain:** Storage / Identity

### Must Be Able To Explain
- Storage Blob Data Reader = blob data read.
- Storage Blob Data Contributor = blob data read/write/delete.
- Data-plane roles are different from management-plane roles.

**Retest:** Required
**Status:** NOT RETESTED

---

## 12. Availability Zone Failure Behavior
**Domain:** Compute

### Must Be Able To Explain
- Understand what happens when one Availability Zone fails.
- Determine whether surviving capacity can handle the workload.

**Retest:** Complete
**Status:** PASSED

---

## 13. Production Incident Troubleshooting
**Domain:** Compute

### Must Be Able To Explain
- Use evidence instead of assumptions.
- Check CPU, memory, disk I/O, network, application health, dependencies,
  Load Balancer health probes, VMSS instance health, and recent changes.

**Retest:** Complete
**Status:** PASSED

---

## 14. Authentication vs Authorization
**Domain:** Identity

### Must Be Able To Explain
Authentication
    ?
Who are you?

Authorization
    ?
What are you allowed to do?

**Retest:** Required
**Status:** NOT RETESTED

---

## 15. Load Balancer vs VMSS Responsibilities
**Domain:** Compute

### Must Be Able To Explain
- Load Balancer distributes traffic.
- Health probes identify healthy/unhealthy backend instances.
- VMSS manages VM instances and scaling.

**Retest:** Required
**Status:** NOT RETESTED

---

# Cross-Domain Retest Model

For troubleshooting questions, reason through the layers in this order:

Authentication
      ?
Authorization
      ?
Scope
      ?
Network
      ?
Resource
      ?
Application
      ?
Health
      ?
Troubleshooting

---

# Completion Rule

A weak topic moves from:

NOT RETESTED
      ?
UNDER REVIEW
      ?
PASSED
      ?
MASTERED

A topic should only be marked **MASTERED** after the concept can be
explained and applied correctly in a scenario without relying on memorized
answer patterns.

