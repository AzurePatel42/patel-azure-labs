# AZ-104 Identity & Governance - Notes

## Core Mental Model

Microsoft Entra ID
    =
Identity and authentication

Azure RBAC
    =
Authorization to Azure resources

---

## RBAC Assignment Model

Principal
    +
Role
    +
Scope
    =
Access

---

## Scope Hierarchy

Management Group
    ?
Subscription
    ?
Resource Group
    ?
Resource

Assignments at a parent scope can be inherited by child scopes.

---

## Classic Roles

Reader
    -> View resources

Contributor
    -> Manage resources
    -> Cannot assign RBAC roles

Owner
    -> Manage resources
    -> Can manage access

---

## Least Privilege Rule

1. Identify WHO
2. Identify WHAT they need to do
3. Select the appropriate ROLE
4. Select the smallest required SCOPE

---

## Control Plane vs Data Plane

Management-plane access:
Reader, Contributor, Owner

Data-plane access:
Specific data roles such as Storage Blob Data Reader

Important:
Having Reader on a Storage Account does not automatically mean the user can read blob contents.

---

## Important Permission

Microsoft.Authorization/roleAssignments/write

Meaning:
Permission required to create an Azure RBAC role assignment.

---

## Interview Principle

Do not just name the role.

Explain:
- Why this role?
- Why this scope?
- What can it do?
- What can it not do?
- Why are the alternatives wrong?

---

# Day 2 - Managed Identities, Data Access, and RBAC Troubleshooting

## Managed Identity Mental Model

Managed Identity
    =
Azure-managed identity for a workload

Purpose:
Allow Azure resources to authenticate to supported services without storing usernames, passwords, client secrets, or certificates in application code.

Important distinction:

Managed Identity
    =
WHO the workload is

Key Vault
    =
WHERE secrets may be stored

Azure RBAC
    =
WHAT the identity is allowed to do

---

## System-Assigned Managed Identity

System-assigned managed identity is tied directly to one Azure resource.

Lifecycle:

Resource created
    ->
Identity created

Resource deleted
    ->
Identity deleted

Best fit:
- One resource needs its own identity
- Permissions should be unique to that resource
- Identity should disappear when the resource disappears

---

## User-Assigned Managed Identity

User-assigned managed identity is an independent Azure resource.

It can be assigned to multiple Azure resources.

Lifecycle:

Managed Identity
    !=
Application or VM lifecycle

Deleting or replacing the workload does not automatically delete the user-assigned identity.

Best fit:
- Multiple resources need the same identity
- Shared permissions are desired
- Identity must survive workload replacement
- Identity lifecycle should be managed independently

---

## Authentication vs Authorization

Authentication asks:

Who are you?

Authorization asks:

What are you allowed to do?

Example:

App Service obtains a valid token
    =
Authentication succeeded

Key Vault returns HTTP 403
    =
Investigate authorization, scope, access model, or network restrictions

---

## Key Vault Access Mental Model

For Microsoft Entra-based access:

Managed Identity
    ->
Gets token
    ->
Key Vault checks permissions
    ->
Access allowed or denied

If the application successfully obtains a token but receives 403:

Check:
1. Which identity actually obtained the token?
2. Is the correct principal assigned?
3. Does it have the required Key Vault data-plane role?
4. Is the role assigned at the correct scope?
5. Is the vault using the expected access-control model?
6. Are network restrictions blocking access?

Example read role:

Key Vault Secrets User
    ->
Can read secret contents

---

## Storage Management Plane vs Data Plane

Reader
    =
View Azure resource configuration

Storage Blob Data Reader
    =
Read blob data

Contributor
    =
Manage Azure resources

Important:

Contributor does not automatically provide blob data access.

Reader does not automatically provide blob data access.

Blob access requires an appropriate Storage data-plane role.

---

## Storage Blob Data Roles

Storage Blob Data Reader
    ->
Read containers and blob data

Storage Blob Data Contributor
    ->
Read, write, and delete blob data

Use the least-privileged role that satisfies the requirement.

---

## Container-Level Scope

Azure RBAC data roles can be scoped narrowly.

Example:

App Service needs read access only to container-a.

Preferred design:

Principal
    +
Storage Blob Data Reader
    +
container-a scope

Do not assign at subscription or storage-account scope when container scope satisfies the requirement.

---

## RBAC Inheritance Reminder

Role assigned at:

Resource Group
    ?
Inherited by resources inside the resource group

Example:

Contributor on rg-app-prod
    ->
Can manage a VM inside rg-app-prod

A direct role assignment on the VM is not required when inherited access already provides the necessary permission.

---

## Resource Management vs Access Management

Contributor
    =
Manage resources
    !=
Manage RBAC assignments

User Access Administrator
    =
Manage access

Owner
    =
Manage resources + manage access

---

## Important Troubleshooting Permission

Microsoft.Authorization/roleAssignments/write

If this permission is missing:

The caller cannot create Azure RBAC role assignments.

Contributor does not include this permission.

Possible roles with access-management capability include:

User Access Administrator
Owner

Always assign access-management capability only when the responsibility genuinely requires it.

---

## Day 2 Interview Rules

When troubleshooting a 403:

Do not immediately increase permissions.

Determine:

1. Did authentication succeed?
2. Which identity is being used?
3. Is the failure management plane or data plane?
4. Which exact permission is required?
5. Which role contains that permission?
6. What is the smallest appropriate scope?

---

## Day 2 Mental Models

System-assigned
    =
Identity follows resource lifecycle

User-assigned
    =
Reusable identity with independent lifecycle

Token succeeds + 403
    =
Authentication likely succeeded
    ->
Investigate authorization

Reader
    !=
Blob Reader

Contributor
    !=
Blob Data Contributor

Contributor
    !=
Access Administrator

Principal
    +
Role
    +
Scope
    =
Effective access

---

# Day 3 - Advanced RBAC, VM Login, and Identity Reasoning

## Resource Management vs Access Management

A critical distinction:

Contributor
    =
Manage Azure resources

User Access Administrator
    =
Manage Azure access

Owner
    =
Manage resources + manage access

A user can have extensive resource-management permissions without having permission to create RBAC assignments.

---

## Management Plane vs Data Plane

Always identify the actual operation.

Management plane examples:
- Create a Storage Account
- Configure a Storage Account
- Create a container
- Change Azure resource configuration

Data plane examples:
- Download a blob
- Read blob contents
- Write blob data

Therefore:

Contributor
    !=
Storage Blob Data Reader

Reader
    !=
Storage Blob Data Reader

For blob data access, use the appropriate Storage Blob Data role.

---

## Virtual Machine Resource Access vs Guest OS Login

These are different authorization layers.

Azure resource management:
    Contributor

Guest OS login:
    Virtual Machine User Login
    Virtual Machine Administrator Login

Important interview point:

Contributor on an Azure VM does not automatically grant Windows or Linux guest OS login.

If the requirement is only guest OS login, do not grant Contributor.

---

## Virtual Machine Login Roles

Virtual Machine User Login
    ->
Normal guest OS sign-in

Virtual Machine Administrator Login
    ->
Administrative guest OS sign-in

Use Microsoft Entra security groups when many users need the same access.

---

## User-Assigned Managed Identity Lifecycle

UAMI
    =
Independent Azure resource

App Service
    =
Workload resource

Deleting the App Service:
    does not automatically delete the UAMI

Creating a new App Service:
    does not automatically attach the old UAMI

Key interview sentence:

"UAMI survives the workload, but the workload does not automatically come back with the UAMI attached."

---

## Authentication vs Authorization

Authentication:
    Who are you?

Authorization:
    What are you allowed to do?

Example:

Token acquisition succeeds
    ->
Authentication succeeded

Key Vault returns 403
    ->
Investigate authorization

Check:

Principal
+
Role
+
Scope
+
Access model
+
Network restrictions

---

## Advanced Least-Privilege Pattern

Do not start with:

"What powerful role can fix this?"

Start with:

1. Who is the principal?
2. What exact operation is required?
3. Is it management plane or data plane?
4. What permission is required?
5. Which role contains that permission?
6. What is the smallest valid scope?

---

## Identity & Governance Architecture Mental Model

                    Azure Access
                         |
          +--------------+--------------+
          |                             |
    Resource Management             Guest/Data Access
          |                             |
     Azure RBAC                 Service-specific roles
          |                             |
    Contributor                  Blob Data Reader
    Reader                       VM User Login
    Owner                        VM Admin Login
    UAA                          Key Vault roles

---

## Day 3 Interview Rules

When given an Azure access problem:

Do not immediately increase permissions.

First identify:
- Principal
- Operation
- Authorization layer
- Required role
- Scope
- Inheritance
- Service-specific access model

Then apply least privilege.
