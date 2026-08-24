# AZ-104 Module 05 — Key Vault, Secrets & RBAC

## Overview

This lab demonstrates Azure Key Vault security using Azure RBAC, secret lifecycle management, least-privilege access, and User-Assigned Managed Identity integration with Azure Container Apps.

The lab focuses on replacing application credentials with Azure-managed identity and controlling access to secrets through Azure RBAC.

---

## Objectives

- Create an Azure Key Vault with RBAC authorization enabled.
- Assign Key Vault permissions using Azure RBAC.
- Create and retrieve Key Vault secrets.
- Demonstrate secret versioning.
- Configure secret expiration.
- Understand Key Vault RBAC roles and least privilege.
- Create a User-Assigned Managed Identity.
- Assign `Key Vault Secrets User` to the managed identity.
- Attach the managed identity to an Azure Container App.
- Configure a Container App Key Vault secret reference.
- Verify the identity-to-Key Vault relationship.
- Clean up all temporary Azure resources.

---

## Architecture

```text
                    Azure Entra ID
                         │
                         │
              User-Assigned Identity
                 id-az104-identity-05
                         │
                         │ Key Vault Secrets User
                         ▼
                  Azure Key Vault
                    kvaz104id05
                         │
                         │
                  az104-lab-secret
                         ▲
                         │
              Key Vault Secret Reference
                         │
                         │
              Azure Container App
                 ca-az104-kv-test



Environment
Resource	Value
Subscription	patel-platform-service-template
Resource Group	rg-az104-identity-05
Location	eastus
Key Vault	kvaz104id05
Secret	az104-lab-secret
Managed Identity	id-az104-identity-05
Container Apps Environment	cae-az104-id05
Test Container App	ca-az104-kv-test

All Module 05 Azure resources were deleted during final cleanup.

Key Vault Configuration

The Key Vault was created with Azure RBAC authorization enabled:

Key Vault: kvaz104id05
RBAC Authorization: True

The user performing the lab was assigned:

Key Vault Secrets Officer

at the Key Vault scope.

This allowed secret creation and management during the lab.

Secret Lifecycle

The lab created:

az104-lab-secret

The secret was verified with:

Enabled state
Secret version
Expiration date

The secret expiration was configured for 30 days from creation.

The actual secret value was intentionally excluded from screenshots and final verification output.

Least-Privilege RBAC

The lab compared Key Vault RBAC roles and demonstrated the distinction between administrative secret management and application-level secret access.

Key Vault Secrets Officer

Used by the lab operator for secret management.

User
  │
  ▼
Key Vault Secrets Officer
  │
  ▼
Key Vault
Key Vault Secrets User

Used for the application workload.

Managed Identity
  │
  ▼
Key Vault Secrets User
  │
  ▼
Key Vault

The application identity was not granted Key Vault Secrets Officer.

This follows the principle of least privilege.

User-Assigned Managed Identity

A User-Assigned Managed Identity was created:

Name:
id-az104-identity-05


Principal ID:
841131e8-b384-44f9-b005-a59b4c7be75a


Client ID:
0a176b4e-c5b6-449e-868e-97390f09bed5

The identity was assigned:

Key Vault Secrets User

at the Key Vault scope.

Verified relationship:

id-az104-identity-05
        │
        │ Key Vault Secrets User
        ▼
kvaz104id05
Azure Container Apps Integration

A temporary Azure Container Apps environment was created:

cae-az104-id05

A temporary Container App was deployed:

ca-az104-kv-test

The User-Assigned Managed Identity was attached to the Container App.

The Container App identity configuration was verified as:

Identity Type:
UserAssigned

with:

id-az104-identity-05

attached.

Key Vault Secret Reference

The Container App was configured with a Key Vault-backed secret reference:

Container App
     │
     ▼
Key Vault Secret Reference
     │
     ▼
https://kvaz104id05.vault.azure.net/
     │
     ▼
az104-lab-secret

The reference used the User-Assigned Managed Identity.

The secret value itself was not exposed in the configuration or screenshots.

Important Managed Identity Lesson

A local Windows machine cannot use:

az login --identity

to authenticate as an Azure Managed Identity because the local machine does not have access to the Azure Instance Metadata Service (IMDS).

The lab demonstrated this behavior when the local CLI attempted to reach:

169.254.169.254

The correct architecture is for an Azure-hosted workload, such as:

Azure Virtual Machine
Azure Container App
Azure App Service
Azure Functions

to use the managed identity.

For this lab, Azure Container Apps provided the workload environment.

Security Principles Demonstrated
No application password

The workload did not require a stored Azure client secret.

Managed Identity

Azure manages the workload identity.

RBAC

Access is controlled through Azure role assignments.

Least Privilege

The workload received:

Key Vault Secrets User

rather than:

Key Vault Secrets Officer
Secret Protection

The secret value was not exposed in portfolio screenshots.

Secret Lifecycle

The lab demonstrated:

Secret creation
Secret versioning
Expiration
RBAC-controlled access
Evidence

The screenshots/ directory contains evidence captured during the lab:

Screenshot	Evidence
01-key-vault-rbac-enabled.png	Key Vault creation
02-key-vault-secrets-officer-rbac.png	Key Vault RBAC configuration
03-key-vault-secret-created.png	Secret creation
04-key-vault-secret-read.png	Secret verification
05-key-vault-secret-versioning.png	Secret versioning
06-secret-expiration.png	Secret expiration
07-key-vault-least-privilege-rbac.png	Least-privilege RBAC
08-managed-identity-key-vault-rbac.png	Managed Identity RBAC
09-container-app-key-vault-reference.png	Container App Key Vault reference
10-managed-identity-key-vault-final-verification.png	Final integration verification
11-module05-cleanup-verification.png	Cleanup verification
Cleanup

The temporary Container App was deleted:

ca-az104-kv-test

The Container Apps environment was deleted:

cae-az104-id05

Finally, the entire Module 05 resource group was deleted:

rg-az104-identity-05

Final verification returned:

(ResourceGroupNotFound)
Resource group 'rg-az104-identity-05' could not be found.

This confirmed that the lab resources were successfully cleaned up.

Key Takeaways
Azure Key Vault provides centralized secret management.
Azure RBAC can control Key Vault data-plane access.
Key Vault Secrets Officer is appropriate for secret management, not normal application access.
Key Vault Secrets User provides a more appropriate permission boundary for workloads that only need to read secrets.
User-Assigned Managed Identities eliminate the need to embed application credentials.
Azure-hosted workloads can use Managed Identity to authenticate to Azure resources.
Container Apps can use a User-Assigned Managed Identity for Key Vault integration.
Secret values should never be unnecessarily exposed in logs, screenshots, or source control.
Temporary lab resources should be deleted after validation to avoid unnecessary Azure charges.
Identity, RBAC, and secret management should be designed together rather than treated as separate concerns.
AZ-104 Skills Demonstrated
Azure Key Vault
Azure RBAC
Key Vault Secrets
Secret versioning
Secret expiration
Least-privilege access
Managed Identities
User-Assigned Managed Identity
Azure Container Apps
Microsoft Entra ID
Identity-based Azure authentication
Resource cleanup
Azure CLI
Infrastructure verification
Security-focused troubleshooting
Status

Completed — August 2026

Module 05 successfully demonstrated Key Vault secret management, Azure RBAC, least-privilege access, User-Assigned Managed Identity, and Azure Container Apps integration with complete resource cleanup.

