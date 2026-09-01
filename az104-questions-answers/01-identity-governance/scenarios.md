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
