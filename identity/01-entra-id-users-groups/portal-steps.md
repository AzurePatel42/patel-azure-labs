@'
# Portal Steps — AZ-104 Entra ID Lab

## 1. Microsoft Entra ID

Open:

Microsoft Entra ID

Review:

- Overview
- Users
- Groups
- App registrations
- Enterprise applications

---

## 2. Users

Navigate to:

Microsoft Entra ID → Users

Review:

- Display name
- User principal name
- Object ID
- Account status

---

## 3. Groups

Navigate to:

Microsoft Entra ID → Groups

Review:

- patelfamily
- Marketing
- tampagroup

Open a group and review its members.

---

## 4. Resource Group

Open:

Resource groups → rg-az104-identity-01

This resource group contained the Azure resources used during the lab.

---

## 5. Azure RBAC

Open:

Resource group → Access control (IAM) → Role assignments

Review the Reader assignment for the Marketing group.

This demonstrates group-based Azure resource authorization.

---

## 6. Managed Identity

Open:

Managed Identities → id-az104-identity-01

Review:

- Client ID
- Principal ID
- Tenant ID

The Principal ID is used when assigning Azure RBAC permissions.

---

## 7. Storage Account Identity

Open:

Storage account → staz104idlab01

Review the identity configuration.

The storage account was configured with a system-assigned managed identity using Azure CLI.

Portal navigation can vary between Azure Portal versions.

---

## 8. App Registration

Navigate to:

Microsoft Entra ID → App registrations → app-az104-identity-01

Review:

- Application (client) ID
- Object ID
- Publisher domain
- Supported account type

---

## 9. Service Principal

Navigate to:

Microsoft Entra ID → Enterprise applications

Locate:

`app-az104-identity-01`

The Enterprise Application represents the application's Service Principal in the tenant.

---

## 10. Client Secret

Open:

App registration → Certificates & secrets

A lab client secret was created and then deleted.

Never place real secrets in:

- Screenshots
- Git
- Documentation
- Source code
- README files

---

## 11. Key Vault

Open:

Key Vaults → kv-az104-identity-01

Review:

- Overview
- Access control (IAM)
- Secrets

The Key Vault was configured for Azure RBAC authorization.

---

## 12. Key Vault IAM

Open:

Key Vault → Access control (IAM) → Role assignments

The user-assigned managed identity was assigned:

`Key Vault Secrets User`

at the Key Vault scope.

---

## 13. Key Vault Secret

Open:

Key Vault → Objects → Secrets

The lab created:

`az104-lab-secret`

using a harmless lab-only value.

---

## 14. RBAC Troubleshooting

The initial Key Vault secret creation failed with:

`ForbiddenByRbac`

The error identified the signed-in user as the caller.

The managed identity had the required Key Vault role, but the human user did not.

A temporary:

`Key Vault Secrets Officer`

role was assigned to the signed-in user.

The lab secret was then successfully created.

The temporary user role was removed before cleanup.

### Important Lesson

When troubleshooting Azure RBAC, identify:

1. Who is the caller?
2. What role does the caller have?
3. What is the scope?
4. Is the role assignment propagated?
5. Is there a deny assignment?

---

## 15. Cleanup

All Azure resources were contained in:

`rg-az104-identity-01`

The resource group was deleted after completing the lab.

Verification:

```powershell
az group exists --name rg-az104-identity-01


Expected:

false
Screenshot Checklist

Recommended screenshots captured during the lab:

Entra account context
Entra users
Entra groups
Group members
Marketing Reader RBAC
User-assigned managed identity
Storage account system-assigned identity
Managed identity Reader RBAC
App registration
Service Principal Reader RBAC
Client credential creation
Credential deletion / verification
Key Vault creation
Key Vault RBAC
Key Vault secret
Lab Status

Completed — 100%.