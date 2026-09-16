# Storage - Weak Topics

## Purpose

Document Storage concepts that required additional reasoning, correction,
or reinforcement during the AZ-104 weak-area discovery and retest cycle.

---

## 1. Storage Redundancy - Zone vs Region

### Weak Area

Distinguishing zone-level protection from region-level protection.

### Key Understanding

- ZRS = Zone-redundant storage.
- ZRS protects against availability-zone failure.
- ZRS replicates data across multiple availability zones within the same Azure region.
- GRS = Geo-redundant storage.
- GRS provides a replicated copy in a secondary Azure region.
- RA-GRS = GRS plus read access to the secondary region.
- GZRS = zone redundancy in the primary region plus geo-replication to a secondary region.

### Mental Model

Zone failure -> ZRS

Region failure -> GRS

Region failure + secondary read access -> RA-GRS

Zone + region protection -> GZRS

### Status

MASTERED

---

## 2. Storage Networking - IP Network Rules vs NSG

### Weak Area

Distinguishing Storage Account IP network rules from Network Security Groups.

### Key Understanding

- Storage Account networking can restrict access from specific public IP addresses.
- IP network rules are configured through the Storage Account networking/firewall configuration.
- An NSG controls network traffic associated with Azure network interfaces and subnets.
- An NSG is not the Storage Account feature used to create a public-IP allow list for Storage access.

### Mental Model

Public endpoint + specific public IPs -> Storage Account IP network rules

Azure subnet/network traffic filtering -> NSG

### Status

MASTERED AFTER RETEST

---

## 3. Private Endpoint - Network Path

### Weak Area

Understanding how a Private Endpoint changes the network path to an Azure Storage Account.

### Key Understanding

- A Private Endpoint provides private connectivity to the Storage Account through an Azure VNet.
- The Storage Account is accessed through a private IP associated with the Private Endpoint.
- The network path changes from public endpoint access to private VNet connectivity.

### Mental Model

Public access:

Application -> Public endpoint -> Internet/public path -> Storage

Private Endpoint:

Application -> VNet -> Private Endpoint -> Private IP -> Storage

### Status

MASTERED AFTER RETEST

---

## 4. Private DNS - Hostname Resolution

### Weak Area

Understanding the relationship between Private Endpoint connectivity and DNS resolution.

### Key Understanding

- A Private Endpoint can exist while the application hostname still resolves to the public endpoint.
- DNS determines which IP address the Storage Account hostname resolves to.
- For private connectivity, the hostname should resolve to the Private Endpoint's private IP.
- Private DNS is therefore an important troubleshooting area when a Private Endpoint is configured but the hostname resolves publicly.

### Mental Model

Storage hostname -> DNS -> Private IP -> Private Endpoint -> Storage

If hostname -> Public IP, investigate DNS configuration.

### Status

MASTERED AFTER RETEST

---

## 5. Blob Immutability vs Soft Delete vs Resource Lock

### Weak Area

Distinguishing data protection mechanisms.

### Key Understanding

- Blob Soft Delete protects against deletion by retaining deleted blobs for a configured retention period.
- Blob Versioning protects against changes or overwrites by maintaining previous blob versions.
- Blob Immutability provides WORM-style protection where data cannot be modified or deleted during the configured retention period.
- Resource Lock is a management-plane resource protection mechanism and is not the blob-data WORM mechanism for regulatory retention.

### Mental Model

Accidental deletion -> Soft Delete

Accidental overwrite/change -> Blob Versioning

Regulatory retention / cannot modify or delete -> Blob Immutability

Azure resource management protection -> Resource Lock

### Status

MASTERED AFTER RETEST

---

## 6. RBAC Scope and Inheritance

### Weak Area

Applying RBAC scope reasoning to Storage containers.

### Key Understanding

- Role = WHAT permission is granted.
- Scope = WHERE the permission applies.
- A Storage Account-level assignment applies to applicable child resources such as containers.
- A container-level assignment applies only within that container.
- A role assigned to `finance` does not automatically grant access to `hr`.

### Mental Model

Storage Account scope -> applicable containers inherit the permission

Container A scope -> Container A only

### Status

MASTERED

---

## 7. Storage Data Models and Services

### Key Understanding

- Azure Blob Storage -> large amounts of unstructured object data such as images, videos, PDFs, and logs.
- Azure Files -> managed file shares using SMB/NFS semantics.
- Azure Table Storage -> simple NoSQL key-value data.

### Mental Model

Unstructured objects -> Blob Storage

Shared file system / SMB -> Azure Files

Key-value NoSQL -> Table Storage

### Status

MASTERED

---

## 8. Blob Access Tiers and Lifecycle Management

### Key Understanding

- Hot -> frequently accessed data.
- Cool -> less frequently accessed data that remains online.
- Archive -> rarely accessed data where lower storage cost is prioritized and retrieval takes additional time.
- Blob Lifecycle Management can automatically transition blobs between access tiers based on configured rules and conditions.

### Mental Model

Frequent access -> Hot

Less frequent + online -> Cool

Rare access + lowest storage cost + retrieval delay acceptable -> Archive

Automatic tier transitions -> Lifecycle Management

### Status

MASTERED

---

## Cross-Domain Storage Mental Model

Requirement
    ->
Failure domain / workload / access pattern
    ->
Storage capability
    ->
Security / networking layer
    ->
Scope
    ->
Least privilege
    ->
Required access

---

## Storage Retest Result

20-question blind retest completed.

Result: 20/20 successful.

The identified weak areas were successfully corrected during retesting.

Overall Storage weak-area status: MASTERED
