# AZ-104 Identity & Governance - Troubleshooting

## Troubleshooting Mental Model

Always separate:

Authentication
    =
Who are you?

Authorization
    =
What are you allowed to do?

---

## Problem 1 - Token Acquisition Fails

Symptoms:
- Application cannot obtain a Microsoft Entra token
- Authentication fails before accessing the target service

Investigate:
1. Is managed identity enabled or attached?
2. Is the application requesting the correct identity?
3. Is the target identity available to the workload?
4. Is the authentication configuration correct?

Mental Model:

No valid token
    ->
Investigate authentication first

---

## Problem 2 - Token Succeeds but Service Returns 403

Symptoms:
- Managed identity successfully obtains a token
- Key Vault or another Azure service returns HTTP 403

Interpretation:
Authentication likely succeeded.

Investigate:
1. Which principal actually obtained the token?
2. Does that principal have the required role?
3. Is the role a management-plane or data-plane role?
4. Is the assignment at the correct scope?
5. Is the service using the expected access-control model?
6. Are network restrictions involved?

Mental Model:

Token works
    +
403
    ->
Investigate authorization and service access controls

---

## Problem 3 - Key Vault 403 After Resource Recreation

Situation:
An application previously worked with a user-assigned managed identity but fails after the application resource is recreated.

Investigate:
1. Verify the user-assigned identity is attached to the new resource.
2. Verify the application is selecting the intended identity.
3. Verify the managed identity still exists.
4. Verify its principal ID.
5. Verify Key Vault role assignments and scope.
6. Verify Key Vault network configuration if necessary.

Important:
A recreated resource does not automatically inherit the identity configuration of the deleted resource.

---

## Problem 4 - Storage Account Reader but Blob Access Returns 403

Situation:
An identity has Reader on the Storage Account but cannot download blobs.

Cause:
Reader is a management-plane role.

It does not grant blob data access.

Resolution:
Assign an appropriate data-plane role.

For read-only access:

Storage Blob Data Reader

Mental Model:

Reader
    !=
Storage Blob Data Reader

---

## Problem 5 - Contributor but Blob Access Fails

Situation:
An identity has Contributor but cannot perform a blob data operation.

Cause:
Contributor primarily provides Azure resource management permissions.

Do not assume Contributor grants Storage data-plane access.

Resolution:
Determine the required blob operation and assign the appropriate Storage Blob Data role.

---

## Problem 6 - Contributor Cannot Assign Reader

Error:

Microsoft.Authorization/roleAssignments/write

Meaning:
The caller lacks permission to create an Azure RBAC role assignment.

Contributor:
    -> Can manage resources
    -> Cannot assign RBAC roles

Investigate:
1. Caller's effective role assignments
2. Assignment scopes
3. Whether access management is actually required

Possible access-management roles:

User Access Administrator
Owner

Use the least-privileged role and smallest required scope.

---

## Problem 7 - User Has More Access Than Expected

Situation:
A user has access to a resource even though there is no direct role assignment on that resource.

Investigate inherited role assignments.

Scope hierarchy:

Management Group
    ->
Subscription
    ->
Resource Group
    ->
Resource

A role assigned at a parent scope can apply to child scopes.

Example:

Reader at subscription
    ->
Reader on resource groups
    ->
Reader on resources

Resolution:
Move an overly broad assignment to the smallest required scope when appropriate.

---

## Problem 8 - User Cannot Access One Storage Container

Requirement:
Application should read container-a only.

Investigate:
1. Is Storage Blob Data Reader assigned?
2. Is the correct principal used?
3. Is the role scoped to container-a?
4. Has the RBAC assignment propagated?
5. Are Storage networking rules blocking access?

Least-privilege design:

Principal
    +
Storage Blob Data Reader
    +
container-a
    =
Read-only access to required container

---

## Managed Identity Decision Tree

Question:
Should the identity disappear when the workload is deleted?

YES
    ->
Consider system-assigned managed identity

NO
    ->
Consider user-assigned managed identity

Question:
Do multiple workloads need to share the same identity?

YES
    ->
User-assigned managed identity

Question:
Does every workload need a unique identity?

YES
    ->
System-assigned managed identity is often appropriate

---

## RBAC Troubleshooting Decision Tree

Access denied
    ->

Did authentication succeed?

NO
    ->
Investigate identity and token acquisition

YES
    ->

Is the operation resource management or data access?

Resource management
    ->
Check management-plane role

Data access
    ->
Check service-specific data-plane role

Then verify:

Principal
    +
Role
    +
Scope

Finally check:

Inheritance
Propagation
Service access model
Network restrictions

---

## Interview Troubleshooting Pattern

When asked why access is failing, answer in this order:

1. Identify the principal.
2. Determine whether authentication succeeded.
3. Identify the attempted operation.
4. Determine management plane vs data plane.
5. Identify the exact required role or permission.
6. Verify the assignment scope.
7. Check inheritance.
8. Check service-specific access controls.
9. Check network restrictions when relevant.
10. Apply least privilege rather than increasing permissions blindly.

---

## Problem 9 - Blob Download Returns AuthorizationPermissionMismatch

Symptoms:
- Contributor on Storage Account
- Blob download fails
- Error indicates authorization failure

Diagnosis:
Blob download is a data-plane operation.

Contributor provides resource-management permissions but does not automatically provide blob data access.

Resolution:
Assign Storage Blob Data Reader for read-only access.

Use container scope when only one container is required.

---

## Problem 10 - Developer Cannot Sign Into VM

Symptoms:
- Developer has Contributor on VM
- VM resource can be managed
- Guest OS login fails

Diagnosis:
Contributor does not provide guest OS login.

Resolution:
Use:
- Virtual Machine User Login for normal users
- Virtual Machine Administrator Login for administrators

---

## Problem 11 - UAMI Missing After App Service Recreation

Symptoms:
- Original App Service worked
- App Service deleted and recreated
- Same application name
- Key Vault returns 403

Diagnosis:
The new App Service does not automatically inherit the previous UAMI attachment.

Resolution:
1. Verify UAMI exists.
2. Verify UAMI is attached to the new App Service.
3. Verify the application is using the intended identity.
4. Verify principal/client ID.
5. Verify Key Vault role.
6. Verify role scope.
7. Verify Key Vault access model.
8. Check network restrictions.

---

## Problem 12 - Contributor Cannot Assign Reader

Error:

Microsoft.Authorization/roleAssignments/write

Diagnosis:
The caller lacks permission to create an Azure RBAC role assignment.

Contributor:
    -> Resource management

Access-management role:
    -> RBAC assignment capability

Resolution:
Use User Access Administrator when access-management responsibility is genuinely required.

Do not use Owner merely because it is powerful enough to solve the problem.

---

## Problem 13 - VM Access Architecture Is Over-Permissioned

Situation:
Developers only need guest OS login, but they were given Contributor.

Problem:
Contributor gives unnecessary Azure resource-management permissions.

Resolution:
Remove unnecessary Contributor access and assign Virtual Machine User Login at the appropriate scope.

Administrators who require OS administrative access should receive Virtual Machine Administrator Login.

---

## Advanced Troubleshooting Sequence

Access denied
    |
    v
Identify principal
    |
    v
Did authentication succeed?
    |
    +-- NO --> Investigate identity/token
    |
    +-- YES
          |
          v
    Identify exact operation
          |
          v
    Management plane or data plane?
          |
      +---+---+
      |       |
Management   Data
      |       |
      v       v
Azure RBAC   Service-specific
role         data role
      \       /
       \     /
        v   v
      Verify scope
          |
          v
      Check inheritance
          |
          v
      Check access model
          |
          v
      Check networking
          |
          v
      Apply least privilege

---

## Day 3 Troubleshooting Principle

A 403 does not automatically mean:

"Give the user more permissions."

Instead ask:

"Which exact permission is missing, and where should it be granted?"
