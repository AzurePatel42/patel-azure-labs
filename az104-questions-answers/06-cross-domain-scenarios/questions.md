# AZ-104 Cross-Domain Troubleshooting Questions

---

# Cross-Domain Round 2

## Q1 - Storage Data-Plane Authorization

Scenario:

- VM application reads blobs.
- VM is normal.
- DNS and network work.
- Storage firewall allows the VM.
- Managed Identity authentication succeeds.
- Storage Blob Data Reader is assigned.
- Application receives 403.
- Storage diagnostics show AuthorizationPermissionMismatch.
- Application is attempting to write a blob.

Answer:

The failing layer is Storage data-plane authorization.

Storage Blob Data Reader provides read access but does not provide the required write permission.

The investigation should verify the data-plane RBAC role required for the write operation.

Expected role:

Storage Blob Data Contributor.

Result:

10 / 10

---

## Q2 - Storage Firewall

Scenario:

- Managed Identity authentication succeeds.
- Storage Blob Data Reader is correct.
- DNS resolves correctly.
- NSG allows outbound HTTPS.
- Storage is healthy.
- Storage firewall was recently changed from allowing selected networks to denying access.
- Application can no longer access Storage.

Answer:

The failing layer is Storage Account network access control.

The Storage firewall is the relevant control.

The NSG has already been proven to allow outbound traffic.

Investigation:

- Storage Account Networking
- Firewall configuration
- Allowed networks
- Recent firewall changes

Result:

10 / 10

---

## Q3 - Application Gateway Backend Health

Scenario:

- VM web application is behind Application Gateway.
- Application Gateway returns intermittent 502.
- VM CPU and memory are normal.
- NSG allows Application Gateway traffic.
- Listener is correct.
- Backend pool is correct.
- Backend health is Unhealthy.
- Health probe uses HTTPS 443.
- Application listens on HTTP 80.

Answer:

The failing layer is the Application Gateway backend health / health probe path.

The evidence is the unhealthy backend combined with a probe using HTTPS 443 while the application listens on HTTP 80.

Investigation:

- Probe protocol
- Probe port
- Probe path
- Backend listener
- Application listening port
- NSG
- Firewall
- Connectivity

Result:

10 / 10

---

## Q4 - Guest OS Login vs Azure RBAC

Scenario:

- User can access the VM through the Azure Portal.
- User cannot sign into the Windows guest OS.
- User has Contributor on the VM.
- VM is running.
- Network is healthy.
- Portal access works.
- Windows login reports unauthorized.

Answer:

The failing layer is Guest OS authorization.

Azure RBAC Contributor permissions do not automatically provide Windows Administrator or guest OS login permissions.

Investigation:

- Virtual Machine User Login
- Virtual Machine Administrator Login
- Guest OS authorization

Result:

10 / 10

---

## Q5 - Key Vault Data-Plane Authorization

Scenario:

- VM application needs Key Vault.
- System-assigned Managed Identity is enabled.
- Managed Identity authentication succeeds.
- Network works.
- Key Vault firewall allows the VM.
- Application receives 403 retrieving a secret.
- Identity has Reader on Key Vault.

Answer:

The failing layer is Key Vault data-plane authorization.

Reader is a management-plane permission and does not automatically provide permission to read secret contents.

For Azure RBAC-based Key Vault access, investigate the appropriate data-plane role.

Expected role:

Key Vault Secrets User.

Result:

8 / 10

Refinement:

Key Vault Access Administrator is not the application role that grants secret-content read access.

---

## Q6 - Key Vault Firewall

Scenario:

- Managed Identity authentication succeeds.
- Key Vault Secrets User is assigned.
- Role scope is correct.
- Key Vault firewall allows the VM network.
- DNS works.
- Network connectivity works.
- Application receives 403.
- Key Vault diagnostics show ForbiddenByFirewall.

Answer:

The failing layer is Key Vault network / firewall access control.

The strongest evidence is the diagnostic message:

ForbiddenByFirewall

The investigation should focus on:

- Key Vault Networking
- Firewall configuration
- Allowed networks
- Allowed IP addresses
- VNet/subnet configuration
- Private Endpoint path where applicable

Result:

10 / 10

---

## Q7 - Storage Delete Authorization

Scenario:

- Managed Identity authentication succeeds.
- Storage Blob Data Contributor is assigned.
- Correct scope.
- Storage firewall allows the VM.
- DNS and network connectivity work.
- Application receives 403.
- Storage diagnostics show AuthorizationPermissionMismatch.
- Application performs DeleteBlob.

Answer:

The failing layer is Storage data-plane authorization.

The diagnostic evidence identifies an authorization-related failure.

Investigation:

- Identity actually being used
- Effective data-plane RBAC
- Scope
- DeleteBlob operation
- Application request
- Storage diagnostics

Important refinement:

Storage Blob Data Contributor already includes the normal delete capability, so the role should not automatically be assumed to be the problem.

Result:

9.5 / 10

---

## Q8 - Managed Identity Change

Scenario:

- Managed Identity authentication succeeds.
- Storage Blob Data Contributor is assigned.
- Correct scope.
- Storage firewall allows the VM.
- DNS and network work.
- Application receives 403.
- Storage diagnostics show AuthorizationPermissionMismatch.
- Application recently changed from Managed Identity A to Managed Identity B.
- Managed Identity B does not have Storage Blob Data Contributor.

Answer:

The failing layer is Storage data-plane authorization.

The evidence is:

- AuthorizationPermissionMismatch
- 403
- Identity change
- Managed Identity B lacks the required data-plane role

Investigation:

- Which identity the application is actually using
- Managed Identity B role assignments
- Data-plane permissions
- Role scope

Result:

10 / 10

---

## Q9 - Storage Endpoint Change

Scenario:

- Managed Identity authentication succeeds.
- Storage Blob Data Contributor is assigned.
- Correct scope.
- Storage firewall allows the VM.
- DNS and network connectivity work.
- Application receives 403.
- Storage diagnostics show AuthorizationPermissionMismatch.
- Application performs GetBlob.
- Application recently changed from one Storage Account to another.
- Managed Identity has the correct role on the old Storage Account but no role on the new Storage Account.

Answer:

The failing layer is data-plane authorization on the new Storage Account.

The evidence is the Storage endpoint change combined with the absence of the required role on the new Storage Account.

Investigation:

- Managed Identity actually being used
- Data-plane RBAC on the new Storage Account
- Correct scope
- Required GetBlob permission

Result:

10 / 10

---

## Q10 - Immutable Blob Storage Policy

Scenario:

- Managed Identity authentication succeeds.
- Storage Blob Data Contributor is assigned.
- Correct scope.
- Storage firewall allows the VM.
- DNS and network work.
- Application receives 403.
- Storage diagnostics show AuthorizationPermissionMismatch.
- Application performs DeleteBlob.
- No application code changed.
- No RBAC changes were made.
- Storage Account immutable blob storage policy was recently enabled.

Answer:

The primary investigation should move to the Storage Account resource policy / immutable blob storage configuration.

The strongest evidence is:

- DeleteBlob operation
- Immutable blob storage policy recently enabled
- No application code change
- No RBAC change
- 403 response

Storage Blob Data Contributor already provides the normal delete capability, so RBAC should not automatically be treated as the root cause.

Investigation:

- Immutable blob storage policy
- Retention configuration
- Legal hold where applicable
- Whether the target blob is protected from deletion
- Storage diagnostic details

Result:

9 / 10

---

# Round 2 Results

Questions completed:

10 / 10

Scores:

- Q1: 10 / 10
- Q2: 10 / 10
- Q3: 10 / 10
- Q4: 10 / 10
- Q5: 8 / 10
- Q6: 10 / 10
- Q7: 9.5 / 10
- Q8: 10 / 10
- Q9: 10 / 10
- Q10: 9 / 10

Overall:

96.5 / 100

---

# Cross-Domain Strengths

Strong areas demonstrated:

- Authentication vs Authorization
- Management plane vs Data plane
- RBAC scope
- Managed Identity reasoning
- Storage Blob roles
- Storage firewall vs NSG
- Key Vault data-plane permissions
- Key Vault firewall diagnostics
- Application Gateway health probes
- Guest OS vs Azure RBAC
- Resource policy reasoning
- Evidence-driven troubleshooting

---

# Cross-Domain Core Rule

Do not diagnose from HTTP status alone.

Use:

Evidence
   |
   v
Failing Layer
   |
   v
Azure Control
   |
   v
Targeted Investigation

---

# Cross-Domain Round 2 Status

Foundation:

COMPLETE

Round 2:

10 / 10 COMPLETE

Evidence-driven troubleshooting:

REINFORCED

Weak areas identified:

- Key Vault data-plane role distinction
- Storage authorization vs resource policy distinction

Current status:

CROSS-DOMAIN THEORY COMPLETE

Next:

Hands-on AZ-104 + IaC labs

---
