# AZ-104 Module 05 — Portal Steps

## 1. Open Azure Portal

Sign in to the Azure Portal and confirm the active subscription:

```text
patel-platform-service-template



Navigate to:

Resource groups
2. Create the Resource Group

Create:

Resource group:
rg-az104-identity-05


Region:
East US

Verify that the resource group provisioning state is:

Succeeded
3. Create Azure Key Vault

Navigate to:

Key Vaults
→ Create

Configure:

Subscription:
patel-platform-service-template


Resource group:
rg-az104-identity-05


Key Vault name:
kvaz104id05


Region:
East US

For the permission model, select:

Azure role-based access control

Create the Key Vault.

Verify:

RBAC Authorization:
Enabled
4. Review Key Vault Configuration

Open:

Key Vault
→ kvaz104id05

Review:

Overview
Properties
Access configuration
Resource ID

Confirm that the Key Vault uses:

Azure role-based access control
5. Assign Key Vault Secrets Officer

Navigate to:

Key Vault
→ Access control (IAM)
→ Add
→ Add role assignment

Select:

Role:
Key Vault Secrets Officer

Assign access to:

User

Select the current Azure user.

Review:

Scope:
This resource

Complete the role assignment.

Verify under:

Access control (IAM)
→ Role assignments
6. Create a Secret

Navigate to:

Key Vault
→ Objects
→ Secrets
→ Generate/Import

Create:

Name:
az104-lab-secret


Value:
<lab secret value>

Leave the value as a lab-only secret.

Create the secret.

7. Verify the Secret

Open:

Secrets
→ az104-lab-secret

Verify that the secret exists.

Review:

Current version
Enabled status
Created date
Expiration date

Do not expose the secret value in screenshots.

8. Demonstrate Secret Versioning

Create another version of the same secret.

Use:

Secrets
→ az104-lab-secret
→ New Version

Enter the new lab value.

Save the new version.

Review the version history.

The important concept is:

Same secret name
        │
        ├── Version 1
        │
        └── Version 2
9. Configure Secret Expiration

Open the secret version.

Set an expiration date approximately 30 days after creation.

The lab used:

2026-09-23

Save the configuration.

Verify the expiration metadata.

10. Review Key Vault RBAC Roles

Navigate to:

Subscriptions
→ Access control (IAM)
→ Roles

Review the Key Vault roles.

Important roles from this lab:

Key Vault Reader
Key Vault Secrets User
Key Vault Secrets Officer

Understand the difference between:

Metadata/read access
Secret-value read access
Secret management
11. Create User-Assigned Managed Identity

Navigate to:

Managed Identities
→ Create

Configure:

Subscription:
patel-platform-service-template


Resource group:
rg-az104-identity-05


Region:
East US


Name:
id-az104-identity-05

Create the identity.

12. Review Managed Identity

Open:

Managed Identity
→ id-az104-identity-05

Record:

Client ID:
0a176b4e-c5b6-449e-868e-97390f09bed5


Principal ID:
841131e8-b384-44f9-b005-a59b4c7be75a

These identifiers are useful when configuring Azure workloads.

13. Assign Key Vault Secrets User

Return to:

Key Vault
→ Access control (IAM)
→ Add role assignment

Select:

Key Vault Secrets User

Assign access to:

Managed identity

Select:

id-az104-identity-05

Scope:

This resource

Complete the assignment.

Verify:

Key Vault
→ Access control (IAM)
→ Role assignments

Expected relationship:

id-az104-identity-05
        │
        ▼
Key Vault Secrets User
        │
        ▼
kvaz104id05
14. Create Container Apps Environment

Navigate to:

Container Apps
→ Create

Create a temporary Container Apps environment associated with:

Resource group:
rg-az104-identity-05


Region:
East US


Environment:
cae-az104-id05

The environment may automatically create a Log Analytics workspace.

15. Create Temporary Container App

Create a temporary test Container App:

Name:
ca-az104-kv-test

Use the lab's lightweight public quickstart image.

Configure:

Environment:
cae-az104-id05

Configure external ingress for the temporary test workload.

16. Attach User-Assigned Managed Identity

During Container App configuration, navigate to:

Security
→ Identity
→ User assigned

Select:

id-az104-identity-05

Save the configuration.

Verify that the Container App shows:

Identity type:
User assigned

and that:

id-az104-identity-05

is attached.

17. Configure Key Vault Secret Reference

Configure a Container App secret backed by Azure Key Vault.

The reference should point to:

Key Vault:
kvaz104id05


Secret:
az104-lab-secret

Use:

id-az104-identity-05

as the identity used to access Key Vault.

The architecture becomes:

Container App
      │
      ▼
User-Assigned Managed Identity
      │
      ▼
Key Vault Secrets User
      │
      ▼
Azure Key Vault
      │
      ▼
az104-lab-secret

The secret value itself should not be displayed.

18. Verify Key Vault Integration

Review the Container App configuration.

Confirm:

Secret name:
lab-secret

and the Key Vault reference points to:

kvaz104id05

Confirm the referenced identity is:

id-az104-identity-05

This verifies the identity-based Key Vault configuration.

19. Important Managed Identity Limitation

A local Windows computer does not provide the Azure Instance Metadata Service endpoint used for Managed Identity authentication.

Therefore, attempting:

az login --identity

from a normal local machine can fail.

The lab encountered the Azure metadata endpoint:

169.254.169.254

and the local machine could not reach it.

This is expected because the local workstation is not the Azure-hosted workload.

Managed Identity should be consumed by supported Azure workloads such as:

Azure Container Apps
Azure Virtual Machines
Azure App Service
Azure Functions
20. Final Verification

Verify the Key Vault secret metadata:

Name:
az104-lab-secret


Enabled:
True


Expiration:
2026-09-23

Verify the Container App configuration contains the Key Vault reference.

Do not expose the secret value.

21. Cleanup

After evidence is captured, delete the temporary Container App:

ca-az104-kv-test

Delete the Container Apps environment:

cae-az104-id05

Finally delete the entire lab resource group:

rg-az104-identity-05

The final portal verification should show that the resource group no longer exists.

22. Final Security Review

Before finishing the lab, verify:

✓ Key Vault used Azure RBAC
✓ Secret was versioned
✓ Secret expiration was configured
✓ Secrets Officer was used for administration
✓ Secrets User was used for workload access
✓ User-Assigned Managed Identity was created
✓ Managed Identity was attached to Container App
✓ Container App used a Key Vault reference
✓ Secret value was not exposed in evidence
✓ Temporary resources were deleted
Module Completion

AZ-104 Module 05 — Key Vault, Secrets & RBAC

Status:

COMPLETED

Key concepts demonstrated:

Azure Key Vault
Azure RBAC
Secret management
Secret versioning
Secret expiration
Least privilege
User-Assigned Managed Identity
Azure Container Apps
Key Vault references
Identity-based access
Resource cleanup