# AZ-104 Identity Module 02 — Entra ID Roles & Azure RBAC

## Core Concepts

Microsoft Entra roles and Azure RBAC are separate authorization systems.

- Microsoft Entra roles control administrative capabilities within Microsoft Entra ID.
- Azure RBAC controls access to Azure resources.

## Azure RBAC Scope Hierarchy

Azure RBAC can be assigned at different scopes:

1. Management group
2. Subscription
3. Resource group
4. Resource

Permissions assigned at a broader scope can be inherited by child resources.

## Role Assignments

An Azure RBAC assignment consists of:

- Principal
- Role
- Scope

Example:

AZ104 RBAC Test User
→ Reader
→ rg-az104-identity-02

## Reader

Reader provides read-only access to Azure resources.

Reader can:

- View resources
- Read resource configuration

Reader cannot:

- Modify resources
- Create or delete resources
- Assign Azure RBAC roles

## Contributor

Contributor provides broad management access to Azure resources.

Contributor can:

- Create resources
- Modify resources
- Delete resources
- Manage resource configuration

Contributor cannot:

- Assign Azure RBAC roles

## Owner

Owner provides full management access to Azure resources, including Azure RBAC role assignment.

Owner can:

- Manage resources
- Assign Azure RBAC roles

## Effective Permissions

Azure RBAC permissions are cumulative.

A role assignment at a child scope does not cancel or override a broader role assignment.

In this lab, the primary administrator had:

Owner
→ Subscription

and:

Reader
→ Resource Group

The Owner assignment inherited into the resource group, so the administrator retained write permissions.

## Lab Test User

The dedicated test user was assigned:

Reader
→ rg-az104-identity-02

and later:

Contributor
→ staz104idrbac02

This demonstrates that different roles can be assigned to the same principal at different scopes.

## Least Privilege

RBAC assignments should use the smallest practical scope and minimum permissions required.

Example:

Contributor
→ Storage Account

is more restrictive than:

Contributor
→ Resource Group

which is more restrictive than:

Contributor
→ Subscription


Owner   /subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec
Owner   /subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec
PS C:\Users\mahes> az storage account delete `
>>   --name staz104idrbac02 `
>>   --resource-group rg-az104-identity-02 `
>>   --yes
PS C:\Users\mahes> az storage account show `
>>   --name staz104idrbac02 `
>>   --resource-group rg-az104-identity-02
(ResourceNotFound) The Resource 'Microsoft.Storage/storageAccounts/staz104idrbac02' under resource group 'rg-az104-identity-02' was not found. For more details please go to https://aka.ms/ARMResourceNotFoundFix
Code: ResourceNotFound
Message: The Resource 'Microsoft.Storage/storageAccounts/staz104idrbac02' under resource group 'rg-az104-identity-02' was not found. For more details please go to https://aka.ms/ARMResourceNotFoundFix
PS C:\Users\mahes> az group delete `
>>   --name rg-az104-identity-02 `
>>   --yes
PS C:\Users\mahes> az group show `
>>   --name rg-az104-identity-02
(ResourceGroupNotFound) Resource group 'rg-az104-identity-02' could not be found.
Code: ResourceGroupNotFound
Message: Resource group 'rg-az104-identity-02' could not be found.
PS C:\Users\mahes> az role assignment list `
>>   --assignee-object-id "0563a187-761f-4cbe-83d7-cbf337d0be33" `
>>   --all `
>>   --query "[].{Role:roleDefinitionName,Scope:scope}" `
>>   --output table
Role    Scope
------  ---------------------------------------------------
Owner   /subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec
Owner   /subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec


An Owner assignment at subscription scope can therefore provide permissions over resources inside the subscription.

3. Azure RBAC Assignment Model

An RBAC assignment consists of:

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
Resource Group
4. Reader

Reader provides read-only access to Azure resources.

Observed role definition:

Actions:
    */read


NotActions:
    []

Reader can:

View resources
Read resource configuration

Reader cannot:

Modify resources
Create resources
Delete resources
Assign Azure RBAC roles

Azure description:

View all resources, but does not allow you to make any changes.

5. Contributor

Contributor provides broad management access to Azure resources.

Observed role definition:

Actions:
    *


NotActions include:
    Microsoft.Authorization/*/Delete
    Microsoft.Authorization/*/Write
    Microsoft.Authorization/elevateAccess/Action

Contributor can:

Create resources
Modify resources
Delete resources
Manage resource configuration

Contributor cannot:

Assign Azure RBAC roles
6. Owner

Owner provides full management access to Azure resources, including Azure RBAC role assignment.

Observed role definition:

Actions:
    *


NotActions:
    []

Owner can:

Manage Azure resources
Assign Azure RBAC roles
7. Contributor vs Owner

The important distinction is RBAC administration.

                    Reader    Contributor    Owner
-----------------------------------------------------
View resources        YES         YES          YES
Manage resources      NO          YES          YES
Assign RBAC roles     NO          NO           YES

Contributor has broad resource-management permissions but excludes authorization-management operations.

Owner includes the ability to assign Azure RBAC roles.

8. Effective Permissions

Azure RBAC permissions are cumulative across applicable assignments.

A narrower role does not override a broader role.

During the lab, the administrator had:

Owner
    |
Subscription

and also:

Reader
    |
Resource Group

The Owner assignment at subscription scope inherited into the resource group.

Therefore the administrator still had write permissions.

This explained why a storage-account update succeeded even though Reader had been assigned at the resource-group scope.

9. Lab Test User

A dedicated test user was created:

AZ104 RBAC Test User

The test user received:

Reader
    |
rg-az104-identity-02

and later:

Contributor
    |
staz104idrbac02

This demonstrated that the same principal can receive different roles at different scopes.

The test user was later removed during cleanup.

10. Authentication vs Authorization

The test user required MFA during interactive Azure CLI authentication.

This demonstrated an important distinction:

Authentication
    |
    └── Who are you?
         |
         └── MFA


Authorization
    |
    └── What can you do?
         |
         └── Azure RBAC

The MFA requirement was not bypassed or weakened.

The RBAC assignments were verified independently through Azure CLI.

11. Least Privilege

RBAC should use the minimum permissions and smallest practical scope required.

Example:

Contributor
    |
Storage Account

is more restrictive than:

Contributor
    |
Resource Group

which is more restrictive than:

Contributor
    |
Subscription

The goal is to reduce unnecessary access.

12. Key Lessons
Entra directory roles and Azure RBAC are separate authorization systems.
Azure RBAC assignments consist of a principal, role, and scope.
RBAC supports multiple scopes.
Permissions can be inherited from broader scopes.
Effective permissions are cumulative.
Reader provides read-only access.
Contributor manages resources but cannot assign RBAC roles.
Owner can manage resources and assign RBAC roles.
Global Administrator does not automatically mean Azure Owner.
Least privilege should guide role and scope selection.
Authentication and authorization are separate concepts.