# AZ-104 Cross-Domain Troubleshooting Notes

---

## Cross-Domain Troubleshooting Model

Core model:

Authentication
      |
      v
Authorization
      |
      v
Scope
      |
      v
Network
      |
      v
Resource
      |
      v
Application
      |
      v
Health
      |
      v
Troubleshooting

---

## Evidence-First Troubleshooting

Core rule:

Evidence -> Identify Layer -> Isolate Control -> Investigate

Do not troubleshoot a lower layer after evidence has already proven that layer is working.

Example:

If DNS, network connectivity, firewall access, authentication, and RBAC are already proven, move to the application, request, resource, or policy layer.

---

## Authentication

Question:

Who or what is requesting access?

Examples:

- Managed Identity
- Microsoft Entra ID
- User identity
- Service principal

Authentication succeeding does not prove authorization is correct.

---

## Authorization

Question:

What is this identity allowed to do?

Examples:

- Azure RBAC
- Data-plane RBAC
- Guest OS permissions
- Key Vault data-plane permissions
- Storage data-plane permissions

---

## Scope

Question:

Where is the permission assigned?

Possible scopes:

- Management group
- Subscription
- Resource group
- Resource
- Data-plane resource scope

A correct role at the wrong scope can still produce an authorization failure.

---

## Network

Question:

Can the requester reach the destination?

Relevant controls:

- DNS
- NSG
- Routing
- Firewall
- Storage firewall
- Key Vault firewall
- Private Endpoint
- Application Gateway

---

## Resource

Question:

Is the Azure resource configured correctly?

Examples:

- Storage Account configuration
- Key Vault configuration
- VM configuration
- Application Gateway configuration
- Resource policies

---

## Application

Question:

Is the application making the correct request?

Investigate:

- Identity actually being used
- Endpoint
- API operation
- Resource
- Request
- Application configuration
- Application logs

---

## Health

Question:

Is the application or backend healthy?

Examples:

- Application Gateway backend health
- Health probes
- Application availability
- Dependency performance
- VM health

---

## Storage Cross-Domain Reasoning

Storage operations such as:

- GetBlob
- UploadBlob
- DeleteBlob

are data-plane operations.

Relevant roles include:

- Storage Blob Data Reader
- Storage Blob Data Contributor

Storage Blob Data Reader provides read access.

Storage Blob Data Contributor provides read/write/delete capabilities appropriate to the role.

---

## Storage Authentication vs Authorization

Managed Identity authentication answers:

Who is the application?

Storage data-plane authorization answers:

What can that identity do?

Authentication succeeding does not prove authorization is correct.

---

## Storage Firewall vs NSG

NSG controls traffic to and from the VM NIC or subnet.

Storage Firewall controls which networks can access the Storage Account.

Therefore:

If Storage diagnostics show that the Storage Account firewall denied access, investigate the Storage Account networking configuration rather than the VM NSG.

---

## AuthorizationPermissionMismatch

Storage diagnostic evidence such as:

AuthorizationPermissionMismatch

indicates an authorization-related failure.

Investigate:

1. Identity being used.
2. Data-plane role.
3. Role scope.
4. Requested operation.
5. Application request.
6. Resource configuration.
7. Resource policies.

A 403 by itself does not automatically prove that RBAC is wrong.

---

## Managed Identity Changes

If an application changes from:

Managed Identity A
        |
        v
Managed Identity B

permissions assigned to Identity A do not automatically transfer to Identity B.

Verify:

- Which identity the application is actually using.
- Required data-plane RBAC role.
- Correct scope.
- Required operation permission.

---

## Storage Endpoint Changes

If an application changes from:

Old Storage Account
        |
        v
New Storage Account

permissions on the old Storage Account do not automatically apply to the new Storage Account.

Verify that the Managed Identity has the required data-plane role on the new Storage Account.

---

## Key Vault Cross-Domain Reasoning

Management-plane permissions and data-plane permissions are different.

A Reader role on Key Vault does not automatically grant permission to read secret contents.

For Azure RBAC-based secret access, investigate an appropriate data-plane role such as:

Key Vault Secrets User

---

## Key Vault Firewall Evidence

Diagnostic evidence:

ForbiddenByFirewall

indicates that the Key Vault firewall or network access control denied the request.

If:

- Managed Identity authentication succeeds.
- Key Vault Secrets User is assigned.
- Scope is correct.
- DNS works.
- Network connectivity works.

and diagnostics show:

ForbiddenByFirewall

investigate:

- Key Vault Networking
- Firewall configuration
- Allowed networks
- Allowed IP addresses
- VNet/subnet configuration
- Private Endpoint path where applicable

---

## Application Gateway Cross-Domain Reasoning

Application Gateway sits between the client and backend application.

Client
   |
   v
Application Gateway
   |
   v
Backend Pool
   |
   v
VM / Application

If backend health is unhealthy, investigate:

- Health probe protocol
- Probe port
- Probe path
- Backend listener
- NSG
- Firewall
- Application listening port
- Application health

Example:

Probe HTTPS 443
        |
        X
Application listens HTTP 80

The VM can be running normally while Application Gateway reports the backend as unhealthy.

---

## Guest OS vs Azure RBAC

Azure RBAC controls Azure resource management.

Guest OS permissions control access inside the operating system.

Therefore:

Contributor on VM
        !=
Windows Administrator

For Windows VM sign-in problems, investigate the appropriate VM login role and guest OS authorization.

---

## Resource Policy Layer

Correct authentication and RBAC do not guarantee that every operation is permitted.

Example:

Storage Blob Data Contributor
        |
        v
DeleteBlob
        |
        v
Immutable Blob Policy
        |
        X
Deletion blocked

When a resource protection policy is involved, investigate the policy in addition to identity and RBAC.

---

## Monitoring as Evidence

Monitoring helps identify the failing layer.

Metrics
   |
   v
What is happening?

Logs
   |
   v
What happened?

Diagnostics
   |
   v
Why did it happen?

Application Logs
   |
   v
What did the application request?

Resource Health
   |
   v
Is the resource healthy?

---

## Cross-Domain Decision Sequence

Use this sequence:

1. Authentication
2. Authorization
3. Scope
4. Network
5. Resource
6. Application
7. Health
8. Troubleshooting

At every stage, use evidence to determine whether the layer is working before moving deeper.

---

## Core Principle

The strongest troubleshooting answer identifies the failing layer from evidence, identifies the Azure control responsible, and investigates only the controls that can explain the observed failure.

---
