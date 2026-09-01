# AZ-104 Identity & Governance - Troubleshooting

## Problem 1

Error:
Microsoft.Authorization/roleAssignments/write

Diagnosis:
The caller does not have permission to create an RBAC role assignment.

First checks:
- Effective RBAC roles
- Assignment scope
- Access-management permissions

---

## Problem 2

Developer can manage a VM but cannot assign Reader.

Diagnosis:
Contributor allows resource management but does not allow RBAC role assignment.

---

## Problem 3

User can see a Storage Account but cannot read blob data.

Diagnosis:
Separate management-plane access from data-plane access.

Reader provides management-plane visibility.
Storage Blob Data Reader provides blob-data read access.

---

## Problem 4

User can see resources outside the intended resource group.

Diagnosis:
Check the scope where the RBAC assignment was made.

A subscription-level assignment is inherited by child resource groups and resources.

Corrective action:
Use the smallest scope that satisfies the requirement.
