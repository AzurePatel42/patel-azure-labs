
---

# 4. `README.md`

This is the important one for your GitHub portfolio.

```markdown
# AZ-104 Identity Module 02 — Entra ID Roles & Azure RBAC

## Overview

This hands-on lab explores Microsoft Entra directory roles and Azure Role-Based Access Control (RBAC).

The lab demonstrates:

- Microsoft Entra directory roles
- Azure RBAC
- RBAC role assignments
- Scope hierarchy
- Role inheritance
- Reader
- Contributor
- Owner
- Effective permissions
- Least privilege
- Authentication vs authorization

---

## Learning Objectives

By completing this lab, I demonstrated the ability to:

- Explain the difference between Entra directory roles and Azure RBAC.
- Assign Azure RBAC roles to users.
- Identify RBAC scopes.
- Understand inheritance from broader scopes.
- Compare Reader, Contributor, and Owner.
- Analyze Azure built-in role definitions.
- Apply least-privilege principles.
- Inspect Entra directory-role assignments.
- Troubleshoot authentication and authorization behavior.
- Clean up Azure lab resources safely.

---

# Architecture

```text
                    Azure Subscription
                           |
                           |
              +------------+-------------+
              |                          |
              |                          |
        Azure RBAC                 Microsoft Entra ID
              |                          |
       Resource Access             Directory Roles
              |                          |
       +------+-------+            +-----+-----+
       |              |            |     |     |
     Reader      Contributor     Global App   AI
       |              |          Admin Admin Admin
       |              |
 Resource Group    Resource
       |              |
       +------> Storage Account




Azure RBAC Scope Hierarchy
Management Group
       |
       v
Subscription
       |
       v
Resource Group
       |
       v
Resource

A role assigned at a broader scope can be inherited by child scopes.

Core RBAC Model

An Azure RBAC assignment consists of:

Principal
    +
Role
    +
Scope

Example:

AZ104 RBAC Test User
        |
      Reader
        |
rg-az104-identity-02
Reader vs Contributor vs Owner
Capability	Reader	Contributor	Owner
View resources	Yes	Yes	Yes
Manage resources	No	Yes	Yes
Assign Azure RBAC roles	No	No	Yes

The lab inspected the actual Azure built-in role definitions rather than relying only on documentation.

Important RBAC Finding

The administrator initially received:

Reader
→ rg-az104-identity-02

However, the administrator already had:

Owner
→ Subscription

Because the Owner assignment existed at a broader scope, it was inherited by the resource group.

Therefore the administrator retained write permissions.

This demonstrated:

Azure RBAC permissions are cumulative across applicable role assignments and scopes.

A child-scope Reader assignment does not override a broader Owner assignment.

Dedicated RBAC Test User

A temporary Entra user was created:

AZ104 RBAC Test User

The test user received:

Reader
→ rg-az104-identity-02

and:

Contributor
→ staz104idrbac02

This demonstrated that different roles can be assigned to the same principal at different scopes.

The test user was deleted during cleanup.

Microsoft Entra Directory Roles

The administrator's Microsoft Entra directory roles were inspected using Microsoft Graph.

Observed roles:

Global Administrator
Application Administrator
AI Administrator

These are separate from Azure RBAC roles.

For example:

Global Administrator

does not inherently mean:

Azure Owner

Azure resource permissions are governed separately through Azure RBAC assignments.

Authentication vs Authorization

During the test-user authentication attempt, Azure CLI returned an MFA requirement:

AADSTS50076

The tenant's MFA requirements were not disabled or bypassed.

This demonstrated the distinction:

Authentication
→ Who are you?
→ MFA


Authorization
→ What can you do?
→ Azure RBAC
Least Privilege

RBAC assignments should use the smallest practical scope and minimum required permissions.

For example:

Contributor
→ Storage Account

is more restrictive than:

Contributor
→ Resource Group

which is more restrictive than:

Contributor
→ Subscription

Least privilege reduces unnecessary access.

Hands-On Tasks
Task 1 — Create Lab Resource Group

Created:

rg-az104-identity-02
Task 2 — Create Storage Account

Created:

staz104idrbac02
Task 3 — Assign Reader

Assigned Reader to the administrator at resource-group scope.

Task 4 — Investigate Effective Permissions

Discovered the administrator also had Owner at subscription scope.

Task 5 — Create Dedicated Test User

Created:

AZ104 RBAC Test User
Task 6 — Assign Reader

Assigned Reader at resource-group scope.

Task 7 — Assign Contributor

Assigned Contributor directly at storage-account scope.

Task 8 — Inspect Built-In Roles

Inspected:

Reader
Contributor
Owner
Task 9 — Inspect Entra Directory Roles

Inspected Microsoft Entra directory-role assignments through Microsoft Graph.

Task 10 — Cleanup

Removed all temporary RBAC assignments and deleted the test resources.

Evidence

Screenshots captured during the lab:

01-resource-group.png
02-storage-account.png
03-reader-rbac-scope.png
04-owner-subscription-scope.png
05-reader-resource-group-scope.png
06-rbac-test-user.png
07-test-user-reader-assignment.png
08-test-user-reader-confirmed.png
09-test-user-contributor-resource-scope.png
10-reader-contributor-scopes.png
11-contributor-vs-owner-role-definitions.png
12-reader-role-definition.png
13-reader-definition-and-admin-rbac.png
14-entra-directory-roles.png
15-entra-vs-azure-rbac.png
Cleanup Verification

The lab resources were successfully removed.

rg-az104-identity-02
→ ResourceGroupNotFound


staz104idrbac02
→ ResourceNotFound


AZ104 RBAC Test User
→ Deleted

The final Azure RBAC verification showed only the administrator's pre-existing subscription Owner assignments.

No pre-existing Owner or Entra directory roles were removed.

Key Takeaways
1. Entra roles and Azure RBAC are different
Entra Roles
→ Identity / directory administration


Azure RBAC
→ Azure resource authorization
2. Scope matters
Subscription
→ Resource Group
→ Resource
3. Permissions are cumulative

A broader assignment can provide permissions even when a narrower assignment appears more restrictive.

4. Contributor is not Owner

Contributor can manage resources but cannot assign Azure RBAC roles.

5. Reader is read-only

Reader provides:

*/read

and does not allow resource modifications.

6. Least privilege matters

Use the smallest practical role at the smallest practical scope.

7. Authentication and authorization are different

MFA determines whether an identity can authenticate.

RBAC determines what an authenticated identity can access or manage.

Technologies Used
Microsoft Azure
Microsoft Entra ID
Azure RBAC
Azure CLI
Microsoft Graph REST API
PowerShell
Lab Status

Completed

Module: 02-entra-id-roles-rbac
Status: Complete
Evidence: 15 screenshots
Azure resources: Cleaned up
Temporary test identity: Deleted