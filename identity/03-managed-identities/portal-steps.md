# Module 03 — Azure Portal Steps
## Managed Identities

This document describes the Azure Portal workflow corresponding to the Managed Identities lab.

The lab demonstrated:

- System-assigned managed identities
- User-assigned managed identities
- Microsoft Entra service principals
- Azure RBAC
- Storage Blob Data Reader
- Resource-level RBAC scope
- Identity lifecycle differences
- Resource cleanup

---

# 1. Open Azure Portal

Open the Azure Portal and sign in with the Azure account used for the lab.

Navigate to:

```text
Azure Portal
    ↓
Resource groups


The lab resource group was:

rg-az104-identity-03
2. Create the Resource Group

From Azure Portal:

Resource groups
    ↓
Create

Configure:

Setting	Value
Subscription	patel-platform-service-template
Resource Group	rg-az104-identity-03
Region	East US

Select:

Review + create
    ↓
Create
3. Create the First Storage Account

Navigate to:

Storage accounts
    ↓
Create

Use:

Setting	Value
Resource Group	rg-az104-identity-03
Storage Account Name	staz104idmi03
Region	East US
Performance	Standard
Redundancy	LRS

Select:

Review
    ↓
Create

Wait for deployment to complete.

4. Open the Storage Account

Navigate to:

Storage accounts
    ↓
staz104idmi03

The storage account was the primary resource used to demonstrate the system-assigned managed identity.

5. Enable System-Assigned Managed Identity

Inside the storage account:

Settings
    ↓
Identity

Under:

System assigned

set:

Status: On

Select:

Save

Azure creates the managed identity and registers the identity with Microsoft Entra ID.

6. Verify System-Assigned Identity

Return to:

Storage Account
    ↓
Identity
    ↓
System assigned

The portal displays information associated with the identity.

The CLI verification from the lab identified:

Principal ID:
fdc8d71b-241c-4ada-8203-c02837da0ca5


Tenant ID:
21da5ae3-adeb-4df2-8b96-488c5ed06672

Identity type:

SystemAssigned
7. Locate the Managed Identity in Microsoft Entra ID

Navigate to:

Microsoft Entra ID
    ↓
Enterprise applications

Search for:

staz104idmi03

The managed identity appears as an enterprise application/service principal.

The CLI verification identified:

Service Principal Type:
ManagedIdentity

This demonstrates:

Azure Resource
    ↓
Managed Identity
    ↓
Microsoft Entra Service Principal
8. Assign Azure RBAC

Return to:

Storage Account
    ↓
Access control (IAM)

Select:

Add
    ↓
Add role assignment

Search for:

Storage Blob Data Reader

Select the role.

9. Select the Managed Identity

For:

Assign access to

select the appropriate managed identity/service principal option.

Select:

Select members

Search for:

staz104idmi03

Select the managed identity.

10. Select the Scope

The lab used the storage-account scope.

The intended hierarchy was:

Subscription
    ↓
Resource Group
    ↓
Storage Account

The role assignment was made at:

staz104idmi03

rather than the entire subscription.

This demonstrates least-privilege scope.

11. Verify the RBAC Assignment

Inside:

Storage Account
    ↓
Access control (IAM)
    ↓
Role assignments

Search for the managed identity.

Expected role:

Storage Blob Data Reader

Expected scope:

staz104idmi03

The CLI was used in the lab for definitive verification.

12. Inspect the Storage Blob Data Reader Role

Navigate to:

Subscription
    ↓
Access control (IAM)
    ↓
Roles

Search:

Storage Blob Data Reader

The lab inspected the role definition through Azure CLI.

Important permissions included:

Microsoft.Storage/storageAccounts/blobServices/containers/read

and:

Microsoft.Storage/storageAccounts/blobServices/generateUserDelegationKey/action

The data-plane permission included:

Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read
13. Create a User-Assigned Managed Identity

Navigate to:

Managed Identities
    ↓
Create

Configure:

Setting	Value
Subscription	patel-platform-service-template
Resource Group	rg-az104-identity-03
Region	East US
Name	id-az104-identity-03

Select:

Review + create
    ↓
Create
14. Verify User-Assigned Identity

Open:

Managed Identities
    ↓
id-az104-identity-03

The identity created in the lab had:

Principal ID:
aa5c5a7f-1d0f-4aea-a8f3-a1a85c304748


Client ID:
59c36ae6-e38f-4de5-acd5-74db55e59587


Tenant ID:
21da5ae3-adeb-4df2-8b96-488c5ed06672

Unlike the system-assigned identity, this identity is an independent Azure resource.

15. Assign RBAC to User-Assigned Identity

Navigate to the target storage account:

Storage Account
    ↓
Access control (IAM)
    ↓
Add
    ↓
Add role assignment

Select:

Storage Blob Data Reader

For members, select:

Managed identity

Search for:

id-az104-identity-03

Select the identity.

Use the target storage account as the scope.

16. Create the Second Storage Account

A second storage account was used in the lab to demonstrate the user-assigned identity independently from the system-assigned example.

Navigate to:

Storage accounts
    ↓
Create

Configure:

Setting	Value
Resource Group	rg-az104-identity-03
Storage Account	staz104idmi032
Region	East US
Performance	Standard
Redundancy	LRS

Select:

Review + create
    ↓
Create
17. Attach the User-Assigned Identity

Open:

Storage Account
    ↓
staz104idmi032
    ↓
Identity

Under:

User assigned

select:

Add

Select:

id-az104-identity-03

Save the configuration.

The final configuration should show:

Identity Type:
UserAssigned

and:

id-az104-identity-03

as the attached identity.

18. Verify User-Assigned Identity

Inside:

staz104idmi032
    ↓
Identity
    ↓
User assigned

Verify that:

id-az104-identity-03

is listed.

The CLI verification confirmed:

Client ID:
59c36ae6-e38f-4de5-acd5-74db55e59587


Principal ID:
aa5c5a7f-1d0f-4aea-a8f3-a1a85c304748


Tenant ID:
21da5ae3-adeb-4df2-8b96-488c5ed06672
19. Verify User-Assigned RBAC

Navigate to:

staz104idmi032
    ↓
Access control (IAM)
    ↓
Role assignments

Verify:

Role:
Storage Blob Data Reader

and:

Scope:
staz104idmi032

The identity should be:

id-az104-identity-03
20. System-Assigned vs User-Assigned Portal View

The final lab configuration demonstrated:

System-Assigned
staz104idmi03
    ↓
Identity
    ↓
System assigned
    ↓
Enabled

The identity lifecycle belongs to the storage account.

User-Assigned
id-az104-identity-03
        ↓
Independent Managed Identity
        ↓
Attached to staz104idmi032

The identity lifecycle is independent from the storage account.

21. RBAC Scope Review

From the Azure Portal:

Resource
    ↓
Access control (IAM)
    ↓
Role assignments

Always verify:

Who?
What role?
Where?

The complete authorization model is:

Principal
    +
Role
    +
Scope
    =
Authorization

For this lab:

Principal:
Managed Identity


Role:
Storage Blob Data Reader


Scope:
Storage Account
22. Portal Troubleshooting

If the managed identity does not appear immediately in a member-selection dialog:

Verify the identity exists.
Verify the correct subscription.
Verify the correct tenant.
Search for the managed identity by name.
Refresh the portal page.
Verify the Principal ID.

The CLI was used throughout the lab as the authoritative verification mechanism.

23. Cleanup

After the lab was completed, the entire resource group was deleted.

From Azure Portal:

Resource groups
    ↓
rg-az104-identity-03
    ↓
Delete resource group

Enter the resource group name when prompted.

Confirm deletion.

The deletion was also verified through Azure CLI.

Expected result:

Resource group not found
24. Portal vs CLI

This lab intentionally used Azure CLI for the hands-on implementation and Azure Portal concepts for administrative understanding.

Azure CLI

Advantages:

Repeatable
Scriptable
Easy to document
Good for automation
Useful for troubleshooting
Suitable for infrastructure workflows
Azure Portal

Advantages:

Visual resource navigation
Easier discovery of settings
Useful for learning Azure resource relationships
Useful for reviewing IAM assignments
Helpful when exploring unfamiliar Azure services

A strong Azure administrator should be comfortable with both.

25. Operational Pattern

The lab followed:

Create
   ↓
Configure
   ↓
Verify
   ↓
Inspect
   ↓
Assign RBAC
   ↓
Verify Scope
   ↓
Capture Evidence
   ↓
Cleanup

This pattern should be reused for future Azure labs.

Module 03 Portal Summary

The Azure Portal workflow demonstrated how to:

Create Azure resources
Enable system-assigned managed identities
Create user-assigned managed identities
Attach user-assigned identities to resources
Locate managed identities in Microsoft Entra ID
Configure Azure RBAC
Review role assignments
Review RBAC scope
Compare identity lifecycle models
Delete lab resources

Module 03 — Managed Identities: Portal Guide Complete