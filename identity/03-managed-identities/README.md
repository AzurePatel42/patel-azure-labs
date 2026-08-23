# AZ-104 Identity Module 03 — Managed Identities

## Overview

This hands-on lab demonstrates how Azure Managed Identities provide Azure resources with identities in Microsoft Entra ID without requiring applications to store credentials.

The lab covers:

- System-assigned managed identities
- User-assigned managed identities
- Microsoft Entra service principals
- Azure RBAC assignments
- Storage Blob Data Reader
- Management-plane vs data-plane permissions
- Identity lifecycle differences
- RBAC scope
- Identity-to-resource relationships
- Azure CLI administration
- Resource cleanup

---

## Learning Objectives

By completing this lab, I demonstrated the ability to:

1. Create and manage Azure resources with Azure CLI.
2. Enable a system-assigned managed identity.
3. Inspect the managed identity's Principal ID and Tenant ID.
4. Locate the managed identity's corresponding service principal in Microsoft Entra ID.
5. Assign Azure RBAC permissions to a managed identity.
6. Inspect the `Storage Blob Data Reader` role definition.
7. Create a user-assigned managed identity.
8. Assign RBAC permissions to a user-assigned managed identity.
9. Attach a user-assigned identity to an Azure resource.
10. Compare system-assigned and user-assigned managed identities.
11. Apply least-privilege RBAC at resource scope.
12. Verify and remove Azure resources after completing the lab.

---

## Architecture

### System-Assigned Managed Identity

```text
Azure Storage Account
        |
        | System-Assigned Identity
        v
Microsoft Entra ID
        |
        | Service Principal
        v
Azure RBAC
        |
        | Storage Blob Data Reader
        v
Azure Storage Resource


User-Assigned Managed Identity
User-Assigned Managed Identity
        |
        | Independent Azure resource
        v
Microsoft Entra ID
        |
        | Service Principal
        v
Azure RBAC
        |
        +----------------------+
        |                      |
        v                      v
Azure Resource A        Azure Resource B

A user-assigned identity has an independent lifecycle and can be associated with multiple Azure resources.

Lab Environment
Component	Value
Resource Group	rg-az104-identity-03
Region	eastus
System-Assigned Storage Account	staz104idmi03
User-Assigned Storage Account	staz104idmi032
User-Assigned Identity	id-az104-identity-03
RBAC Role	Storage Blob Data Reader
System-Assigned Managed Identity

The first storage account was created:

staz104idmi03

A system-assigned managed identity was enabled on the storage account.

The resulting identity information included:

Principal ID:
fdc8d71b-241c-4ada-8203-c02837da0ca5


Tenant ID:
21da5ae3-adeb-4df2-8b96-488c5ed06672

The identity was confirmed as:

SystemAssigned
Entra Service Principal

The managed identity was then queried through Microsoft Entra ID.

The corresponding service principal was identified as:

Display Name:
staz104idmi03


Application ID:
88ad10bd-bb84-4c85-9f2c-a21166a581da


Object ID:
fdc8d71b-241c-4ada-8203-c02837da0ca5


Service Principal Type:
ManagedIdentity

This demonstrates that a managed identity is represented in Microsoft Entra ID by a service principal.

Azure RBAC

The system-assigned managed identity was assigned:

Storage Blob Data Reader

at the storage-account scope.

The assignment was verified with Azure CLI.

The role provides read access to Azure Storage blob containers and blob data.

The role definition contained:

Actions:
- Microsoft.Storage/storageAccounts/blobServices/containers/read
- Microsoft.Storage/storageAccounts/blobServices/generateUserDelegationKey/action


DataActions:
- Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read

This demonstrates the distinction between management-plane actions and data-plane actions.

User-Assigned Managed Identity

A separate user-assigned managed identity was created:

id-az104-identity-03

Identity information:

Principal ID:
aa5c5a7f-1d0f-4aea-a8f3-a1a85c304748


Client ID:
59c36ae6-e38f-4de5-acd5-74db55e59587


Tenant ID:
21da5ae3-adeb-4df2-8b96-488c5ed06672

Unlike the system-assigned identity, this identity exists as an independent Azure resource.

User-Assigned Identity and RBAC

The user-assigned identity was granted:

Storage Blob Data Reader

at the storage-account scope.

A second storage account was created:

staz104idmi032

The user-assigned identity was attached to this resource.

The final configuration confirmed:

Identity Type:
UserAssigned

and the attached identity contained:

Client ID:
59c36ae6-e38f-4de5-acd5-74db55e59587


Principal ID:
aa5c5a7f-1d0f-4aea-a8f3-a1a85c304748


Tenant ID:
21da5ae3-adeb-4df2-8b96-488c5ed06672
System-Assigned vs User-Assigned
Feature	System-Assigned	User-Assigned
Identity lifecycle	Tied to Azure resource	Independent
Separate identity resource	No	Yes
Reusable across resources	No	Yes
Principal ID	Resource-specific	Independent identity
Can receive RBAC roles	Yes	Yes
Best suited for	Resource-specific identity	Shared/reusable identity
Architectural takeaway

System-assigned identities are useful when an identity should exist only for the lifecycle of a specific Azure resource.

User-assigned identities are useful when an identity needs to exist independently and potentially be reused across multiple Azure resources.

Least-Privilege RBAC

This lab intentionally used:

Storage Blob Data Reader

instead of broad roles such as:

Contributor
Owner

The assignment was scoped to the individual storage account.

This demonstrates two important Azure security principles:

Grant only the permissions required.
Assign permissions at the narrowest practical scope.
Screenshots

The screenshots/ directory contains evidence captured during the lab.

Screenshot	Evidence
01-resource-group.png	Module resource group
02-storage-account.png	Storage account creation
03-system-assigned-identity.png	System-assigned identity
04-managed-identity-service-principal.png	Entra service principal
05-managed-identity-rbac.png	RBAC assignment
06-storage-blob-data-reader-definition.png	Role definition
07-identity-rbac-verification.png	Identity and RBAC verification
08-user-assigned-managed-identity.png	User-assigned identity
09-user-assigned-identity-rbac.png	User-assigned RBAC
10-user-assigned-identity-attached.png	Identity attached to resource
11-user-assigned-identity-rbac-verification.png	Correct RBAC scope
12-user-assigned-final-rbac.png	Final RBAC state
13-system-vs-user-assigned.png	Identity comparison
14-cleanup-resource-group-deleted.png	Resource cleanup
Cleanup

After completing the lab, the entire resource group was deleted:

rg-az104-identity-03

The deletion was verified with:

(ResourceGroupNotFound)

This confirms that the Module 03 Azure resources were removed.

Key Takeaways
1. Managed Identity

Managed identities allow Azure resources to authenticate to supported Azure services without storing credentials in application configuration.

2. Microsoft Entra ID

Managed identities are represented in Microsoft Entra ID through service principals.

3. Identity Does Not Equal Permission

Creating a managed identity does not automatically grant it access to resources.

Access must be granted through Azure RBAC or another supported authorization mechanism.

4. RBAC Scope Matters

A role assignment can be scoped to:

Subscription
Resource group
Individual resource

This lab used the storage-account scope.

5. System vs User Assigned

The primary architectural difference is lifecycle ownership:

System-Assigned
Identity lifecycle = Resource lifecycle


User-Assigned
Identity lifecycle = Independent
6. Least Privilege

Storage Blob Data Reader provides a much narrower permission set than broad administrative roles.

Skills Demonstrated
Microsoft Entra ID
Managed Identities
System-Assigned Managed Identity
User-Assigned Managed Identity
Service Principals
Azure RBAC
RBAC scope
Storage Blob Data Reader
Azure Storage
Azure CLI
PowerShell
Identity lifecycle management
Least-privilege access
Azure resource cleanup
Lab Status

Completed

Azure resources created
System-assigned identity demonstrated
User-assigned identity demonstrated
Entra service principal relationship verified
RBAC assignments verified
Identity lifecycle differences demonstrated
Screenshots captured
Azure resources cleaned up
