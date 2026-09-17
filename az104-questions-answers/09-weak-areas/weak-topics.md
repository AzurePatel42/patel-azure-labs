# AZ-104 Weak Topics

## Identity & Governance

### 1. VM Guest OS Login / RBAC Distinction
- Azure RBAC controls Azure resource management.
- Guest OS permissions control access inside the operating system.
- Contributor does not automatically provide Windows Administrator access.
- Review Virtual Machine User Login vs Virtual Machine Administrator Login.

### 2. User-Assigned Managed Identity Lifecycle
- User-assigned managed identities exist independently of workloads.
- Deleting the workload does not delete the UAMI.
- A recreated workload does not automatically have the UAMI attached.
- Key principle:
  UAMI survives the workload, but the workload does not automatically come back with the UAMI attached.

### 3. Authentication vs Authorization
- Authentication = who/what is requesting access.
- Authorization = what that identity is allowed to do.
- Review how Microsoft Entra ID and Azure RBAC work together.

### 4. Management Plane vs Data Plane
- Management plane = managing Azure resources.
- Data plane = accessing data/services inside those resources.
- Azure resource permissions do not automatically grant data access.

### 5. Least-Privilege Role Selection
- Select the narrowest role that satisfies the required operation.
- Review built-in Azure roles and their scopes.

---

## Storage

### 1. Managed Identity vs SAS
- Managed Identity + Microsoft Entra ID + Azure RBAC is preferred for supported Azure-hosted applications.
- SAS provides temporary/delegated access.
- Understand when each access model is appropriate.

### 2. Managed Identity vs Key Vault
- Managed Identity provides workload identity.
- Key Vault stores secrets/credentials.
- Key Vault does not eliminate the secret itself.

### 3. Management Plane vs Data Plane
- Management permissions do not automatically authorize blob data operations.
- Review Azure management roles vs Storage Blob Data roles.

### 4. Private Endpoint vs NSG
- Private Endpoint provides private connectivity to the storage service.
- It does not replace authentication or authorization.
- Understand the role of network controls separately.

### 5. GRS vs RA-GRS vs Failover
- GRS = geo-replication.
- RA-GRS = geo-replication with read access to the secondary.
- Failover promotes the secondary to the primary.

### 6. Private Endpoint DNS Troubleshooting
- Private Endpoint connectivity depends on correct private DNS resolution.
- When public access is disabled, DNS becomes especially important.
- A 403 after a Private Endpoint change should trigger investigation of network/DNS after verifying RBAC.

### 7. Storage Blob Data Role Selection
- Storage Blob Data Reader = blob data read.
- Storage Blob Data Contributor = blob data read/write/delete.
- Distinguish data-plane roles from management-plane roles.

### 8. Authentication -> Authorization -> Scope -> Network
Use this troubleshooting sequence:

Authentication
    ->
Authorization
    ->
Scope
    ->
Network
    ->
Resource / Application

---

## Compute

### 1. VM Health vs Application Health
- A VM can be running while the application is unhealthy.
- VM-level health does not prove application-level health.

### 2. Capacity vs Traffic Distribution
- VMSS manages VM instances and scaling.
- Load Balancer distributes traffic.
- Scaling increases available capacity.
- Load balancing distributes requests across healthy instances.

### 3. Layer-by-Layer Troubleshooting
Review problems in layers:

Client
  ->
Network
  ->
Load Balancer
  ->
VM
  ->
Operating System
  ->
Application
  ->
Dependencies

### 4. Availability Zone Failure Behavior
- Understand how workloads behave when one Availability Zone fails.
- Surviving zones must have enough capacity for the workload.

### 5. Production Incident Troubleshooting
Use evidence instead of assumptions.

Check:
- CPU
- Memory
- Disk I/O
- Network
- Application health
- Dependencies
- Load Balancer health probes
- VMSS instance health
- Recent changes

---

## Cross-Domain Reasoning Model

Authentication
      ->
Authorization
      ->
Scope
      ->
Network
      ->
Resource
      ->
Application
      ->
Health
      ->
Troubleshooting

This model should be used during weak-area scenarios and retesting.

