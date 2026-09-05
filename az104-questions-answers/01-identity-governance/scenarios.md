# AZ-104 Identity & Governance - Scenarios

## Scenario 1 - Resource Management Without Access Management

Requirement:
Developers can deploy and manage Azure resources inside rg-app-prod but must not manage user access.

Decision:
Contributor at resource-group scope.

Reason:
Contributor manages resources but does not include RBAC role assignment.

---

## Scenario 2 - Access Management

Requirement:
An identity must create Azure RBAC role assignments.

Decision:
Use an appropriate access-management role at the smallest required scope.

Important:
Do not automatically choose Owner when a more focused access-management role satisfies the requirement.

---

## Scenario 3 - Scope and Inheritance

A Reader role assigned at subscription scope is inherited by resource groups and resources below that scope.

To restrict access:
Assign Reader directly at the required resource-group or resource scope.

---

## Scenario 4 - Storage Control Plane vs Data Plane

Reader on a resource group can allow the user to view Azure resource information.

That does not automatically grant access to blob data.

For blob data access, an appropriate Storage Blob Data role is required.

---

## Scenario 5 - Passwordless VM Access to Key Vault

Requirement:
A VM must retrieve Key Vault secrets without storing application credentials.

Decision:
Enable a managed identity on the VM and grant that identity the required Key Vault data-plane permission.

Reason:
Managed identity provides workload authentication without application-managed credentials.

---

## Scenario 6 - Shared Identity Across Multiple VMs

Requirement:
Twenty VMs require the same identity and Key Vault permissions.

Decision:
Use a user-assigned managed identity.

Reason:
One user-assigned managed identity can be attached to multiple Azure resources and managed independently of their lifecycles.

---

## Scenario 7 - Unique Identity Per VM

Requirement:
Each VM needs its own unique identity, and that identity should disappear when the VM is deleted.

Decision:
Use a system-assigned managed identity.

Reason:
The system-assigned identity follows the lifecycle of its Azure resource.

---

## Scenario 8 - Shared App Service Identity

Requirement:
Multiple App Service applications need the same identity, and the identity must survive application replacement.

Decision:
Use a user-assigned managed identity.

Reason:
The identity is a separate Azure resource and can be reused by multiple workloads.

---

## Scenario 9 - Recreated App Service Gets Key Vault 403

Situation:
An App Service previously used a user-assigned managed identity successfully. The application is deleted and recreated with the same name, but Key Vault now returns 403.

Investigate:
- Is the original user-assigned identity attached?
- Is the application using the intended identity?
- Is the principal ID correct?
- Does the identity still have the required Key Vault role?
- Is the role assigned at the correct scope?

Important:
Recreating an Azure resource with the same name does not automatically restore its previous identity configuration.

---

## Scenario 10 - Token Works but Key Vault Returns 403

Situation:
An application successfully obtains a Microsoft Entra token but receives HTTP 403 from Key Vault.

Interpretation:
Authentication likely succeeded.

Investigate:
Authorization, identity selection, RBAC data-plane permissions, role scope, Key Vault access model, and network restrictions.

---

## Scenario 11 - Storage Reader but Blob Access Fails

Situation:
An application has Reader on a Storage Account but receives 403 when reading blob contents.

Reason:
Reader provides management-plane visibility, not blob data-plane access.

Decision:
Assign Storage Blob Data Reader when read-only blob access is required.

---

## Scenario 12 - Least Privilege at Container Scope

Requirement:
An application must read blobs from container-a but must not access container-b or container-c.

Decision:
Assign Storage Blob Data Reader at container-a scope.

Reason:
Use the smallest scope that satisfies the requirement.

---

## Scenario 13 - Resource-Group Role Inheritance

Situation:
A user has Contributor at resource-group scope but no direct assignment on a VM inside the resource group.

Result:
The user can manage the VM through inherited RBAC permissions.

Mental Model:

Resource Group assignment
    ?
Inherited by contained resources

---

## Scenario 14 - Contributor Cannot Assign Roles

Situation:
A developer has Contributor and can manage resources but receives:

Microsoft.Authorization/roleAssignments/write

when attempting to assign Reader to another user.

Reason:
Contributor does not include RBAC access-management permissions.

Decision:
If access management is genuinely part of the job responsibility, use an appropriate access-management role such as User Access Administrator at the smallest required scope.

---

## Scenario 15 - Developers Manage Resources but Not Access

Requirement:
Developers manage resources in Development but cannot assign RBAC roles.

Decision:
Contributor at Development scope.

Security team:
Appropriate access-management role at the required subscription scope.

Key lesson:
Resource management and access management are separate responsibilities.

---

## Scenario 16 - Blob Download Returns 403

Situation:
Developer has Contributor but blob download fails.

Reason:
Blob download is a data-plane operation.

Decision:
Storage Blob Data Reader for read-only access.

Key lesson:
Do not confuse Storage Account management with blob data access.

---

## Scenario 17 - Entra ID VM Login

Requirement:
Developers need normal guest OS login. Administrators need administrative guest OS access.

Decision:
Virtual Machine User Login for developers.

Virtual Machine Administrator Login for administrators.

Use Entra security groups for centralized assignment.

---

## Scenario 18 - UAMI After App Service Recreation

Situation:
App Service is deleted and recreated.

The original UAMI still exists.

Problem:
New App Service receives a Key Vault 403.

Investigation:
1. Is the UAMI attached?
2. Is the application using that identity?
3. Is the principal ID correct?
4. Does the identity have Key Vault Secrets User or another required role?
5. Is the scope correct?
6. Are access model or network restrictions involved?

Key lesson:
Same application name does not restore identity configuration.

---

## Scenario 19 - Contributor Cannot Assign Reader

Situation:
Developer has Contributor at resource-group scope.

The developer can manage resources but receives roleAssignments/write when assigning Reader.

Reason:
Contributor does not contain the required access-management permission.

Decision:
User Access Administrator if access management is genuinely required.

---

## Scenario 20 - VM Resource Management vs OS Login

Situation:
Developer has Contributor on a VM but cannot log into the Windows guest OS.

Reason:
Contributor controls Azure resource management, not guest OS login.

Decision:
Virtual Machine User Login for normal login.

Key lesson:
Azure resource permissions and guest OS permissions are different authorization layers.

---

## Scenario 21 - Centralized VM Access Architecture

Requirement:
90 developers need VM login and 10 administrators need administrative VM login.

Decision:
Create Entra security groups.

Developer group:
Virtual Machine User Login

Administrator group:
Virtual Machine Administrator Login

Do not grant Contributor to developers unless Azure resource management is also required.

Key lesson:
Assign access based on the exact responsibility.
