
---

# 3. `portal-steps.md`

```markdown
# AZ-104 Identity Module 02 — Portal Steps

## Objective

Use the Azure Portal to understand:

- Azure RBAC
- Role assignments
- Scope
- Role inheritance
- Reader
- Contributor
- Owner
- Microsoft Entra directory roles

---

## 1. Open the Resource Group

Navigate to:

```text
Azure Portal
→ Resource Groups
→ rg-az104-identity-02


Verify:

Resource group name
Region
Resources

Screenshot:

01-resource-group.png
2. Review the Storage Account

Navigate to:

Resource Group
→ staz104idrbac02

Verify the storage account exists.

Screenshot:

02-storage-account.png
3. Open Access Control (IAM)

From the resource group:

Resource Group
→ Access control (IAM)
→ Role assignments

Review the Reader assignment.

Screenshot:

03-reader-rbac-scope.png
4. Review Subscription-Level Owner

Navigate to:

Subscription
→ Access control (IAM)
→ Role assignments

Locate the Owner assignment for the administrator.

This demonstrates the broader subscription-level scope.

Screenshot:

04-owner-subscription-scope.png
5. Compare Resource Group Scope

Return to:

Resource Group
→ Access control (IAM)
→ Role assignments

Review the Reader assignment.

This demonstrates that the assignment is scoped to the resource group rather than the subscription.

Screenshot:

05-reader-resource-group-scope.png
6. Review the RBAC Test User

The dedicated test user created for the lab was:

AZ104 RBAC Test User

Screenshot:

06-rbac-test-user.png
7. Review Test User Reader Assignment

Open:

Resource Group
→ Access control (IAM)
→ Role assignments

Review:

AZ104 RBAC Test User
→ Reader

Screenshot:

07-test-user-reader-assignment.png
8. Verify Test User Reader Scope

The Reader assignment was verified at:

Resource Group

Screenshot:

08-test-user-reader-confirmed.png
9. Review Contributor at Resource Scope

The test user was assigned Contributor directly to:

staz104idrbac02

This demonstrates resource-level scope.

Screenshot:

09-test-user-contributor-resource-scope.png
10. Compare Reader and Contributor Scopes

Review the role assignments and confirm:

Reader
→ Resource Group


Contributor
→ Storage Account

Screenshot:

10-reader-contributor-scopes.png
11. Compare Contributor and Owner

Azure role definitions were inspected through Azure CLI.

Contributor:

Manage resources
Cannot assign Azure RBAC roles

Owner:

Manage resources
Can assign Azure RBAC roles

Screenshot:

11-contributor-vs-owner-role-definitions.png
12. Review Reader Role Definition

Reader was inspected and confirmed as a read-only role.

Screenshot:

12-reader-role-definition.png
13. Review Administrator RBAC

The administrator's Azure RBAC assignments were reviewed.

The administrator had Owner at subscription scope.

Screenshot:

13-reader-definition-and-admin-rbac.png
14. Review Microsoft Entra Directory Roles

Microsoft Graph was used to inspect Entra directory role assignments.

Observed roles:

Global Administrator
Application Administrator
AI Administrator

Screenshot:

14-entra-directory-roles.png
15. Entra Roles vs Azure RBAC

The final comparison demonstrates:

Microsoft Entra
→ Directory roles
→ Identity/directory administration


Azure RBAC
→ Resource roles
→ Azure resource authorization

Screenshot:

15-entra-vs-azure-rbac.png
Authentication Note

The dedicated test user required MFA during interactive Azure CLI authentication.

The tenant's authentication requirements were not weakened or bypassed.

The test user's Azure RBAC assignments were verified through administrative Azure CLI commands.

Cleanup

After completing the lab:

Remove test user Contributor assignment.
Remove test user Reader assignment.
Delete test user.
Remove temporary Reader assignment from administrator.
Delete storage account.
Delete resource group.
Verify pre-existing administrator Owner assignments remain untouched.

Final state:

rg-az104-identity-02
→ Deleted


staz104idrbac02
→ Deleted


AZ104 RBAC Test User
→ Deleted


Temporary RBAC assignments
→ Removed
