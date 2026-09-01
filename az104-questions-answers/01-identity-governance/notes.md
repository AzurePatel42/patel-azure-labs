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
    ↓
Subscription
    ↓
Resource Group
    ↓
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
