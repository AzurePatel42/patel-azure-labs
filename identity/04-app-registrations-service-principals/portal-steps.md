@'
# Module 04 Portal Steps — App Registrations & Service Principals

## Step 1 — Open Microsoft Entra ID

Azure Portal:
Microsoft Entra ID
→ App registrations
→ All applications

Locate:

`app-az104-identity-01`

## Step 2 — Inspect the App Registration

Open the application and review:

- Overview
- Application ID
- Object ID
- Supported account types
- Publisher information

Record the Application Object ID separately from the Application ID.

## Step 3 — Inspect the Service Principal

From Microsoft Entra ID:

Enterprise applications
→ locate `app-az104-identity-01`

Review:

- Application ID
- Object ID
- Application type
- Enabled state

The Enterprise Application represents the tenant's Service Principal.

## Step 4 — Inspect API Permissions

From the App Registration:

API permissions

The lab initially showed no configured API permissions.

## Step 5 — Add Microsoft Graph User.Read

API permissions
→ Add a permission
→ Microsoft Graph
→ Delegated permissions
→ User.Read

Add the permission.

## Step 6 — Grant Admin Consent

From API permissions:

Grant admin consent for the tenant.

Verify that User.Read shows the appropriate consent state.

## Step 7 — Inspect Certificates & Secrets

Certificates & secrets
→ Client secrets

The lab created a temporary client secret.

Important:

The secret value is displayed only when created.

Never place the secret value in screenshots, Markdown files, or source control.

## Step 8 — Azure RBAC

Navigate to the temporary storage account:

Storage account
→ Access control (IAM)

Review role assignments.

The Service Principal received the built-in Reader role at the storage-account scope.

## Step 9 — Cleanup

Remove the temporary RBAC assignment.

Delete the temporary resource group.

Return to:

App Registration
→ Certificates & secrets

Remove the temporary lab secret.

Verify that the App Registration remains.

## Final State

The dedicated lab App Registration remains available.

Microsoft Graph User.Read remains configured with tenant-wide admin consent.

Temporary Azure resources, RBAC assignments, and client secret were removed.
'@ | Set-Content .\portal-steps.md