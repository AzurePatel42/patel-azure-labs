@'
# AZ-104 Module 04 — App Registrations & Service Principals

## Overview

This lab demonstrates Microsoft Entra ID application registrations, application objects, service principals, API permissions, admin consent, client secrets, and Azure RBAC.

The lab intentionally reused the existing `app-az104-identity-01` application registration to avoid unnecessary application-registration quota consumption.

## Objectives

- Understand Application Objects vs Service Principals
- Inspect an existing App Registration
- Inspect API permissions
- Configure Microsoft Graph `User.Read`
- Grant tenant-wide admin consent
- Create and inspect a client secret
- Understand the Service Principal as an Azure identity
- Assign Azure RBAC to a Service Principal
- Verify RBAC scope
- Clean up temporary credentials and Azure resources

## Lab Resources

### App Registration

- Display name: `app-az104-identity-01`
- Application ID: `37d2f223-2725-4c4d-8227-133ccd6a3d2a`
- Application Object ID: `ea3247f6-15ee-495e-a5c4-8fd6cf8af055`
- Sign-in audience: `AzureADMyOrg`

### Service Principal

- Object ID: `da1d7b12-bb81-4056-b750-42c7906f23bc`
- Type: `Application`
- Enabled: `True`

### API Permission

- API: Microsoft Graph
- Permission: `User.Read`
- Type: Delegated / Scope
- Consent: `AllPrincipals`

## Key Concepts

### Application Object vs Service Principal

The Application Object represents the application definition in the tenant.

The Service Principal represents the application's identity within the tenant and can receive permissions and Azure RBAC assignments.

The Application ID is shared between the two objects, while their Object IDs are different.

### API Permission vs Consent

Adding an API permission configures what the application requests.

Admin consent grants the configured permission for the tenant.

### Client Secret

A client secret is an application credential used for authentication.

The secret value is only available when created and must never be committed to source control.

The lab secret was created temporarily and deleted during cleanup.

### Service Principal and Azure RBAC

The Service Principal was assigned the built-in `Reader` role at the scope of a temporary storage account.

The assignment demonstrated least-privilege access at a resource scope.

## Lab Flow

1. Establish App Registration baseline
2. Compare Application Object and Service Principal
3. Inspect App Registration configuration
4. Inspect API permissions
5. Add Microsoft Graph `User.Read`
6. Grant and verify admin consent
7. Create and inspect a client secret
8. Inspect Service Principal identity
9. Assign Reader RBAC
10. Verify RBAC scope
11. Remove temporary resources and credentials

## Cleanup

The following temporary resources were removed:

- Temporary storage account
- Temporary resource group `rg-az104-identity-04`
- Service Principal Reader assignment
- Client secret `az104-module04-lab-secret`

The App Registration and Microsoft Graph `User.Read` permission were intentionally retained for the module.

## Screenshots

The `screenshots/` directory contains evidence captured during the lab:

1. App registration baseline
2. Application vs Service Principal
3. App registration configuration
4. API permissions baseline
5. User.Read API permission
6. API permission consent
7. Client secret metadata
8. Service Principal identity
9. Service Principal RBAC
10. RBAC scope verification
11. Module cleanup verification

## Outcome

This lab demonstrates the relationship between Microsoft Entra application registrations, service principals, API permissions, consent, application credentials, and Azure RBAC.

The environment was cleaned up after the hands-on RBAC and credential exercises while preserving the dedicated lab App Registration.
'@ | Set-Content .\README.md