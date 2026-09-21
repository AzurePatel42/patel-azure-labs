# AZ-104 Cross-Domain Architecture Scenarios

---

## Core Troubleshooting Architecture

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

## Storage Access Architecture

Application
      |
      v
Managed Identity
      |
      v
Microsoft Entra ID
      |
      v
Data-Plane Authorization
      |
      v
Storage Account
      |
      v
Blob Data

Key controls:

- Managed Identity -> Authentication
- Storage Blob Data roles -> Data-plane authorization
- RBAC scope -> Where permissions apply
- Storage Firewall -> Network access to Storage
- NSG -> VM/subnet traffic
- DNS -> Name resolution

---

## Storage Firewall vs NSG

VM Application
      |
      v
VM NIC / Subnet
      |
      v
NSG
      |
      v
Network Path
      |
      v
Storage Account Firewall
      |
      v
Storage Data Plane

Key distinction:

NSG controls VM/subnet traffic.

Storage Firewall controls network access to the Storage Account.

---

## Application Gateway Architecture

Client
      |
      v
Application Gateway
      |
      v
Listener
      |
      v
Routing Rule
      |
      v
Backend Pool
      |
      v
Health Probe
      |
      v
VM / Application

Health probe must match the backend application:

- Protocol
- Port
- Path
- Connectivity

Example:

Health Probe -> HTTPS 443
Application  -> HTTP 80

This can produce an unhealthy backend even when the VM itself is running normally.

---

## Key Vault Architecture

Application
      |
      v
Managed Identity
      |
      v
Microsoft Entra ID
      |
      v
Key Vault Data-Plane Authorization
      |
      v
Secret

Network path:

Application
      |
      v
DNS
      |
      v
Network
      |
      v
Key Vault Firewall / Private Endpoint
      |
      v
Key Vault

Authentication, authorization, and network access are separate controls.

---

## Guest OS vs Azure Resource Architecture

Azure resource management:

User
 |
 v
Azure RBAC
 |
 v
VM Resource

Guest OS access:

User
 |
 v
VM Login Role
 |
 v
Guest OS
 |
 v
Windows Authorization

Azure Contributor does not automatically provide Windows Administrator access.

---

## Resource Policy Architecture

Application
      |
      v
Authentication
      |
      v
Authorization
      |
      v
Data Plane
      |
      v
Resource Policy
      |
      X
Operation Blocked

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
Deletion Blocked

---

## Evidence-First Architecture

Incident
   |
   v
Collect Evidence
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

Core rule:

Evidence -> Identify Layer -> Isolate Control -> Investigate

---

## Cross-Domain Architecture Principle

Do not troubleshoot by service name alone.

Follow the dependency path and use evidence to identify the failing layer.

---

# Status

Cross-Domain Architecture Scenarios:

DOCUMENTED

Cross-Domain Round 2:

COMPLETE

Next:

Hands-on AZ-104 + IaC labs

---
