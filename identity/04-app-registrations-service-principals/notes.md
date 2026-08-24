@'
# Module 04 Notes — App Registrations & Service Principals

## Core Mental Model

Application Registration
→ defines the application

Application Object
→ represents the application definition

Service Principal
→ represents the application's identity in the tenant

Azure RBAC
→ grants Azure resource access to the Service Principal

## Important IDs

Application ID:
37d2f223-2725-4c4d-8227-133ccd6a3d2a

Application Object ID:
ea3247f6-15ee-495e-a5c4-8fd6cf8af055

Service Principal Object ID:
da1d7b12-bb81-4056-b750-42c7906f23bc

## Application Object vs Service Principal

The Application ID is the same for the application and its Service Principal.

The Object IDs are different.

Application Object:
ea3247f6-15ee-495e-a5c4-8fd6cf8af055

Service Principal:
da1d7b12-bb81-4056-b750-42c7906f23bc

## API Permissions

The application initially had no configured API permissions.

Microsoft Graph `User.Read` was then added.

Permission ID:
e1fe6dd8-ba31-4d61-89e7-88639da4683d

Microsoft Graph App ID:
00000003-0000-0000-c000-000000000000

The permission was verified as:

User.Read
Sign in and read user profile

## Admin Consent

Admin consent was granted for `User.Read`.

The resulting grant showed:

ConsentType:
AllPrincipals

Scope:
User.Read

This demonstrates that configured permissions and granted consent are separate concepts.

## Client Secret

A temporary client secret named:

az104-module04-lab-secret

was created for the credential exercise.

The secret value was not stored in documentation or source control.

The credential was deleted during cleanup.

## Azure RBAC

A temporary storage account was created under:

rg-az104-identity-04

The Service Principal received:

Reader

at the storage-account scope.

Reader provides:

`*/read`

and does not provide data actions.

The assignment was removed during cleanup.

## Security Lessons

- Avoid creating unnecessary App Registrations.
- Reuse existing lab identities when appropriate.
- Do not commit secrets.
- Use least-privilege RBAC.
- Scope RBAC assignments as narrowly as practical.
- Distinguish API permission configuration from consent.
- Remove temporary credentials and resources after labs.
'@ | Set-Content .\notes.md