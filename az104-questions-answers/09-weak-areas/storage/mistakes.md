# Storage - Mistakes & Corrections

## 1. ZRS - Zone vs Region

### Mistake

Initially describing ZRS as providing a backup in another region.

### Correction

ZRS provides zone-level redundancy within the same Azure region.

### Lesson

- ZRS -> multiple availability zones within the same region.
- GRS/GZRS provide geo-redundancy involving a secondary region.

---

## 2. Storage IP Network Rules vs NSG

### Mistake

Initially identifying an NSG as the feature to restrict Storage Account access to specific public IP addresses.

### Correction

Storage Account networking provides IP network rules for allowing or restricting specific public IP addresses.

An NSG controls network traffic associated with Azure network interfaces and subnets.

### Lesson

Specific public IP access to a Storage Account -> Storage Account IP network rules.

Subnet/network traffic filtering -> NSG.

---

## 3. Private Endpoint - Network Path

### Mistake

Initially stating that the network path remains the same when using a Private Endpoint.

### Correction

A Private Endpoint changes the access path from the public endpoint to private connectivity through an Azure VNet and a private IP.

### Lesson

Private Endpoint -> VNet -> private IP -> Storage Account.

---

## 4. Blob Immutability vs Soft Delete vs Resource Lock

### Mistake

Initially selecting Soft Delete when the requirement was to prevent regulatory data from being modified or permanently deleted during a retention period.

### Correction

Soft Delete provides recovery after deletion during a configured retention period.

Blob Immutability provides WORM-style protection where protected data cannot be modified or deleted during the configured retention period.

Resource Lock protects Azure resources at the management plane and is not the blob-data WORM mechanism.

### Lesson

- Accidental deletion -> Soft Delete.
- Accidental overwrite/change -> Blob Versioning.
- Regulatory retention / cannot modify or delete -> Blob Immutability.
- Azure resource management protection -> Resource Lock.

---

## 5. Storage RBAC Scope

### Mistake

No persistent weakness identified during retesting.

### Correction

Storage Account-level RBAC assignments apply to applicable child resources.

A container-level assignment applies only to that container.

### Lesson

Role = WHAT

Scope = WHERE

Parent scope -> child resources through inheritance.

---

## 6. Private DNS

### Mistake

No persistent weakness identified during retesting.

### Correction

When a Private Endpoint exists but the Storage Account hostname resolves to a public IP, investigate DNS configuration.

### Lesson

Private Endpoint provides private connectivity, while DNS resolution determines whether the hostname resolves to the private endpoint IP.

---

## Retest Outcome

The identified Storage mistakes were successfully corrected during the blind retest.

Storage Retest: 20/20 successful.

Overall status: MASTERED
