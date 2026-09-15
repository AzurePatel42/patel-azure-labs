# Identity & Governance — Retest

## Retest Objective

Validate understanding of previously identified Identity & Governance
weak areas without revealing the weak-area category during each scenario.

---

## Scenario 1 — VM Restart Permission

### Scenario

An operations engineer needs to restart a production VM.

They do not need:
- RDP/SSH access
- VM resize permissions
- Delete permissions
- Network configuration permissions

The engineer already has Storage Blob Data Reader.

### Answer

Give the engineer the least-privilege permission required to restart
the VM.

### Key reasoning

Storage Blob Data Reader is a Storage data-plane role and does not
provide VM restart capability.

Restarting a VM is a management-plane VM action.

No guest OS login role is required.

### Score

9/10

### Result

PASSED

---

## Scenario 2 — UAMI Lifecycle

### Scenario

A production App Service uses a UAMI called `prod-app-identity`.

The App Service is deleted and replaced.

The UAMI still exists and still has Storage Blob Data Reader on the
Storage Account, but the replacement application cannot read blobs.

### Answer

First check whether `prod-app-identity` is explicitly attached to the
replacement App Service.

### Key reasoning

A UAMI is a separate resource with its own lifecycle.

Deleting the App Service does not delete the UAMI.

Creating a replacement App Service does not automatically attach the
existing UAMI.

### Score

10/10

### Result

PASSED

---

## Scenario 3 — Authentication vs Authorization

### Scenario

An employee successfully authenticates to Azure using Entra ID.

They can open the Storage Account in the Azure portal but cannot read
a blob.

They have Contributor on the Storage Account.

### Answer

Investigate data-plane RBAC permissions.

### Key reasoning

Authentication is valid.

Contributor is a management-plane role and does not automatically
grant blob data access.

An appropriate Storage Blob Data role must be investigated.

### Score

10/10

### Result

PASSED

---

## Scenario 4 — RBAC Scope

### Scenario

An engineer has Storage Blob Data Reader assigned at Container A scope.

They attempt to read a blob in Container B and receive an authorization
error.

### Answer

The problem is the scope.

### Key reasoning

The role is correct, but it is assigned only at Container A scope.

Container B is outside that assignment.

### Score

10/10

### Result

PASSED

---

## Scenario 5 — Least Privilege

### Scenario

An application only needs to read blobs.

The team proposes assigning Contributor to the application's managed
identity.

### Answer

Do not approve the Contributor assignment.

Use Storage Blob Data Reader.

### Key reasoning

Contributor is a management-plane role.

Storage Blob Data Reader provides the required data-plane read access
with a narrower permission set.

### Score

10/10

### Result

PASSED

---

# Retest Summary

Scenarios: 5

Passed: 5

Average Score: 9.8/10

Overall Status: MASTERED

---

# Identity Mental Model

Authentication
    ->
Authorization
    ->
Role
    ->
Scope
    ->
Management Plane / Data Plane
    ->
Required Action
    ->
Least Privilege
