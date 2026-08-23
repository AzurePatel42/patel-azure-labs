# Module 03 Notes — Managed Identities

## 1. Core Concept

Azure Managed Identity provides an identity for an Azure resource so that the resource can authenticate to supported Azure services without requiring application code to store credentials.

The important separation is:

```text
Identity
   ↓
Authentication
   ↓
Authorization
   ↓
Resource Access



2. Managed Identity Mental Model

Think of a managed identity as an Azure-managed identity that can be represented in Microsoft Entra ID by a service principal.

Azure Resource
      |
      | Managed Identity
      v
Microsoft Entra ID
      |
      | Service Principal
      v
Azure RBAC
      |
      v
Target Resource

The identity itself does not automatically provide permissions.

A role assignment is still required.

3. System-Assigned Managed Identity

A system-assigned managed identity is created as part of an Azure resource.

Example from this lab:

Storage Account
staz104idmi03
        |
        └── SystemAssigned

The identity had:

Principal ID:
fdc8d71b-241c-4ada-8203-c02837da0ca5


Tenant ID:
21da5ae3-adeb-4df2-8b96-488c5ed06672

The key lifecycle rule is:

Azure Resource Lifecycle
        =
System-Assigned Identity Lifecycle

If the resource is deleted, the system-assigned identity is also removed.

4. User-Assigned Managed Identity

A user-assigned managed identity is an independent Azure resource.

Example:

id-az104-identity-03

It had:

Principal ID:
aa5c5a7f-1d0f-4aea-a8f3-a1a85c304748


Client ID:
59c36ae6-e38f-4de5-acd5-74db55e59587


Tenant ID:
21da5ae3-adeb-4df2-8b96-488c5ed06672

The identity exists independently of the Azure resource using it.

Therefore:

User-Assigned Identity
        |
        +── Resource A
        |
        +── Resource B
        |
        +── Resource C

The identity can survive the deletion of an individual resource that used it.

5. Principal ID vs Client ID

A managed identity exposes identifiers that serve different purposes.

Principal ID

The Principal ID identifies the identity's service principal in Microsoft Entra ID.

In this lab:

System Identity Principal ID:
fdc8d71b-241c-4ada-8203-c02837da0ca5


User Identity Principal ID:
aa5c5a7f-1d0f-4aea-a8f3-a1a85c304748

The Principal ID was used when creating Azure RBAC assignments.

Client ID

The user-assigned managed identity also has a Client ID:

59c36ae6-e38f-4de5-acd5-74db55e59587

The Client ID identifies the application/client representation of the managed identity.

6. Managed Identity → Service Principal

One of the most important discoveries in this lab was that the system-assigned managed identity could be queried through Microsoft Entra ID.

The service principal showed:

Display Name:
staz104idmi03


Application ID:
88ad10bd-bb84-4c85-9f2c-a21166a581da


Object ID:
fdc8d71b-241c-4ada-8203-c02837da0ca5


Service Principal Type:
ManagedIdentity

This establishes the relationship:

Azure Managed Identity
        |
        v
Microsoft Entra Service Principal

The service principal is the security principal that can receive permissions.

7. Identity vs Authorization

This was one of the most important lessons from the lab.

Creating:

Managed Identity

does NOT automatically mean:

Access to Azure resources

The identity must be authorized.

Example:

Managed Identity
        |
        v
Service Principal
        |
        v
Azure RBAC Assignment
        |
        v
Storage Blob Data Reader
        |
        v
Storage Resource

Therefore:

Authentication != Authorization

Managed identity helps establish identity.

RBAC determines authorization.

8. Azure RBAC

The lab assigned:

Storage Blob Data Reader

to managed identities.

The assignment was made at the storage-account scope.

This demonstrated the principle:

Role
 +
Principal
 +
Scope
 =
RBAC Assignment
9. RBAC Scope

Azure RBAC can be applied at different scopes.

Common scopes include:

Subscription
    |
Resource Group
    |
Resource

A role assignment at a higher scope can affect resources underneath that scope.

A resource-level assignment is narrower.

This lab intentionally used the storage-account scope:

.../storageAccounts/staz104idmi03

and:

.../storageAccounts/staz104idmi032

This is an example of least-privilege design.

10. Storage Blob Data Reader

The lab inspected the actual role definition.

The role contained management-plane actions:

Microsoft.Storage/storageAccounts/blobServices/containers/read


Microsoft.Storage/storageAccounts/blobServices/generateUserDelegationKey/action

and a data-plane action:

Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read

This is important because Azure Storage authorization has both management-plane and data-plane considerations.

11. Management Plane vs Data Plane
Management Plane

The management plane controls Azure resources.

Examples include:

Create resource
Update resource
Delete resource
Configure resource

These operations are generally handled through Azure Resource Manager.

Data Plane

The data plane controls the actual data stored inside a resource.

For Storage:

Storage Account
    |
    +── Containers
    |
    └── Blobs

The Storage Blob Data Reader role includes permission to read blob data.

Mental model:

Management Plane
        |
        v
Azure Resource Configuration




Data Plane
        |
        v
Actual Resource Data
12. Least Privilege

The lab deliberately used:

Storage Blob Data Reader

instead of:

Contributor
Owner

The objective was to demonstrate that identities should receive only the permissions required for their workload.

Security principle:

Minimum Required Permission
        +
Minimum Practical Scope
        =
Least Privilege
13. System-Assigned vs User-Assigned
System-Assigned
Resource
   |
   └── Identity

The resource owns the identity lifecycle.

Best mental model:

"I need an identity specifically for this resource."
User-Assigned
Identity Resource
   |
   +── Resource A
   +── Resource B

The identity has its own lifecycle.

Best mental model:

"I need an identity that exists independently of a particular resource."
14. Why User-Assigned Identities Matter

A user-assigned identity can be useful when multiple Azure resources need to operate using the same identity.

Example:

User-Assigned Identity
        |
        +── VM
        |
        +── Container App
        |
        +── App Service

The identity can be managed separately from those resources.

This makes the identity reusable and independently lifecycle-managed.

15. Troubleshooting Lesson — Azure CLI

During this lab, the first attempt to attach the user-assigned identity used an unsupported argument:

--user-assigned-identities

The command failed.

The storage account remained unchanged:

IdentityType: SystemAssigned
UserAssignedIds: null

This was important because we verified the state rather than assuming the failed command had changed the resource.

16. Troubleshooting Lesson — Resource Update

A second attempt used:

az resource update

with a nested identity property.

PowerShell/Azure CLI parsing caused the property path to be interpreted incorrectly.

Again, the resource state was verified afterward.

The important engineering habit is:

Command
   ↓
Check result
   ↓
Query actual Azure state
   ↓
Confirm expected configuration

Never assume an Azure command succeeded just because the terminal returned to the prompt.

17. Successful User-Assigned Identity Attachment

The working approach used the storage-account-specific command:

az storage account update

with:

--identity-type UserAssigned
--user-identity-id $identityId

The final verification showed:

IdentityType:
UserAssigned

and included:

ClientId:
59c36ae6-e38f-4de5-acd5-74db55e59587


PrincipalId:
aa5c5a7f-1d0f-4aea-a8f3-a1a85c304748


TenantId:
21da5ae3-adeb-4df2-8b96-488c5ed06672

This was the definitive proof that the user-assigned identity was attached.

18. RBAC Scope Troubleshooting

Another important lesson occurred when the user-assigned identity initially had:

Storage Blob Data Reader

on:

staz104idmi03

while the user-assigned identity was being demonstrated with:

staz104idmi032

The assignment was corrected so that the identity had the intended role at:

staz104idmi032

This reinforced an important principle:

Correct Identity
        +
Correct Role
        +
Correct Scope
        =
Correct Authorization
19. Verification Discipline

Throughout the lab, Azure CLI queries were used to verify the actual Azure state.

Examples:

az storage account show
az identity show
az ad sp show
az role assignment list
az role definition list
az group show

The pattern used was:

Create
   ↓
Configure
   ↓
Verify
   ↓
Capture Evidence
   ↓
Continue

This is a useful operational pattern for Azure administration.

20. Cleanup

The entire lab resource group was deleted:

rg-az104-identity-03

Cleanup was verified with:

az group show

which returned:

(ResourceGroupNotFound)

This confirms that the Module 03 Azure resources were removed.

21. Key Interview Concepts
Question: What is a managed identity?

A managed identity provides an Azure resource with an identity in Microsoft Entra ID so it can authenticate to supported Azure services without storing credentials.

Question: What is the difference between system-assigned and user-assigned managed identities?

System-assigned identities are tied to the lifecycle of the Azure resource.

User-assigned identities are independent Azure resources and can be reused across resources.

Question: Does a managed identity automatically have permissions?

No.

The identity must be granted appropriate permissions through Azure RBAC or another supported authorization mechanism.

Question: What is a Principal ID?

The Principal ID identifies the service principal associated with the managed identity.

Question: Why use user-assigned managed identities?

They provide an identity with an independent lifecycle that can be associated with multiple Azure resources.

Question: What is least privilege?

Granting only the permissions required by a workload and assigning them at the narrowest practical scope.

22. Final Mental Model

The complete architecture from this lab is:

                 Microsoft Entra ID
                         |
                         |
                Service Principal
                         |
                         |
                 Managed Identity
                    /          \
                   /            \
        System-Assigned      User-Assigned
              |                    |
              |                    |
       Azure Resource        Independent Identity
                                   |
                                   |
                            Azure Resource
                                   |
                                   v
                              Azure RBAC
                                   |
                                   v
                         Storage Blob Data Reader
                                   |
                                   v
                              Blob Data

The most important distinction is:

IDENTITY
   ↓
Who are you?


AUTHORIZATION
   ↓
What are you allowed to do?


SCOPE
   ↓
Where are you allowed to do it?
Module 03 Summary

This lab demonstrated the practical relationship between:

Azure Resources
Microsoft Entra ID
Managed Identities
Service Principals
Azure RBAC
RBAC Scope
Storage Data Permissions
Least Privilege

The hands-on work also reinforced an important Azure engineering habit:

Always verify the actual cloud state after configuration changes.