# AZ-104 Cross-Domain Troubleshooting Scenarios

---

## Evidence-First Troubleshooting

Use:

Evidence
   |
   v
Identify Failing Layer
   |
   v
Identify Azure Control
   |
   v
Investigate
   |
   v
Validate Fix

Do not continue troubleshooting a layer after evidence has already proven that layer is working.

---

## Scenario 1 - Storage 403 During Write

Evidence:

- Managed Identity authentication succeeds.
- Storage Blob Data Reader is assigned.
- Network is working.
- Storage firewall allows access.
- Application receives 403.
- Application is writing a blob.

Diagnosis:

Storage data-plane authorization.

Investigation:

Storage Blob Data Reader provides read access but not the required write permission.

Expected role:

Storage Blob Data Contributor.

---

## Scenario 2 - Storage Firewall Denial

Evidence:

- Authentication succeeds.
- RBAC is correct.
- DNS works.
- NSG allows traffic.
- Storage firewall was recently changed.
- Storage access fails.

Diagnosis:

Storage Account network access control.

Investigation:

- Storage Account Networking
- Firewall configuration
- Allowed networks
- Recent configuration changes

Do not blame the VM NSG when the Storage Account firewall is the control denying access.

---

## Scenario 3 - Application Gateway 502

Evidence:

- VM is running.
- CPU and memory are normal.
- NSG allows traffic.
- Listener is correct.
- Backend pool is correct.
- Backend health is unhealthy.
- Probe uses HTTPS 443.
- Application listens on HTTP 80.

Diagnosis:

Application Gateway backend health / health probe configuration.

Investigation:

- Probe protocol
- Probe port
- Probe path
- Backend listener
- Application listening port
- NSG
- Firewall

---

## Scenario 4 - Windows VM Login Failure

Evidence:

- Azure Portal access works.
- Contributor role exists on the VM.
- VM is running.
- Network is healthy.
- Windows guest login fails.

Diagnosis:

Guest OS authorization.

Investigation:

- Virtual Machine User Login
- Virtual Machine Administrator Login
- Guest OS permissions

Azure Contributor does not automatically provide Windows Administrator access.

---

## Scenario 5 - Key Vault Secret Access

Evidence:

- Managed Identity authentication succeeds.
- Identity has Reader on Key Vault.
- Network works.
- Application receives 403 while retrieving a secret.

Diagnosis:

Key Vault data-plane authorization.

Investigation:

Reader is a management-plane permission.

For Azure RBAC-based secret access, investigate the appropriate data-plane role such as:

Key Vault Secrets User.

---

## Scenario 6 - Key Vault Firewall

Evidence:

- Managed Identity authentication succeeds.
- Key Vault Secrets User is assigned.
- Correct scope.
- DNS works.
- Network works.
- Application receives 403.
- Diagnostics show ForbiddenByFirewall.

Diagnosis:

Key Vault firewall / network access control.

Investigation:

- Key Vault Networking
- Firewall configuration
- Allowed networks
- Allowed IP addresses
- VNet/subnet configuration
- Private Endpoint path where applicable

The diagnostic evidence identifies the network control as the primary investigation area.

---

## Scenario 7 - Storage DeleteBlob Authorization

Evidence:

- Managed Identity authentication succeeds.
- Storage Blob Data Contributor is assigned.
- Correct scope.
- Firewall allows access.
- DNS and network work.
- DeleteBlob returns 403.
- Diagnostics show AuthorizationPermissionMismatch.

Diagnosis:

Storage data-plane authorization failure.

However, Storage Blob Data Contributor already provides normal delete capability.

Investigation:

- Identity actually being used
- Effective role assignment
- Scope
- Operation
- Application request
- Storage diagnostics
- Other authorization mechanisms or resource policies

Do not automatically conclude that the Contributor role is missing.

---

## Scenario 8 - Managed Identity Changed

Evidence:

- Application previously used Managed Identity A.
- Application now uses Managed Identity B.
- Authentication succeeds.
- Storage returns 403.
- Managed Identity B does not have the required Storage data-plane role.

Diagnosis:

Data-plane authorization for the new identity.

Investigation:

- Identity actually used
- Managed Identity B role assignments
- Correct scope
- Required operation

Permissions assigned to Identity A do not automatically transfer to Identity B.

---

## Scenario 9 - Storage Endpoint Changed

Evidence:

- Application previously used Storage Account A.
- Application now uses Storage Account B.
- Authentication succeeds.
- Network works.
- Storage returns 403.
- Required role exists on Storage Account A but not Storage Account B.

Diagnosis:

Data-plane authorization on the new Storage Account.

Investigation:

- Target Storage Account
- Managed Identity
- Data-plane role
- Scope
- Required operation

Changing the endpoint changes the authorization target.

---

## Scenario 10 - Immutable Blob Policy

Evidence:

- Authentication succeeds.
- Storage Blob Data Contributor is assigned.
- Firewall and network work.
- DeleteBlob returns 403.
- Diagnostics show AuthorizationPermissionMismatch.
- No RBAC changes occurred.
- Immutable blob storage policy was recently enabled.

Diagnosis:

Storage resource policy / immutable blob configuration must be investigated.

Investigation:

- Immutable blob policy
- Retention configuration
- Legal hold where applicable
- Target blob protection state
- Storage diagnostics

Contributor permissions do not automatically override resource protection policies.

---

## Cross-Domain Troubleshooting Checklist

When an Azure request fails:

1. Verify authentication.
2. Verify authorization.
3. Verify scope.
4. Verify network.
5. Verify resource configuration.
6. Verify application behavior.
7. Verify health.
8. Use diagnostics and logs to isolate the failing control.

---

# Status

Cross-Domain Troubleshooting Scenarios:

DOCUMENTED

Round 2:

10 / 10 COMPLETE

Evidence-first troubleshooting:

REINFORCED

Next:

Hands-on AZ-104 + IaC labs

---
