# Storage - Retest

## Retest Objective

Validate Storage weak-area understanding through scenario-based questions
without revealing the weak-area category in advance.

---

## Retest Results

### Q1 - Storage Public IP Network Rules

Requirement: Allow public access only from approved public IP addresses.

Answer: Storage Account IP network rules.

Result: PASSED

Score: 10/10

---

### Q2 - Private Endpoint DNS

Requirement: Private Endpoint exists, but Storage hostname resolves to a public IP.

Answer: Investigate DNS configuration / Private DNS.

Result: PASSED

Score: 10/10

---

### Q3 - GZRS Protection

Requirement: Protect against availability-zone failure and complete primary-region failure without requiring secondary read access.

Answer: GZRS.

Result: PASSED

Score: 10/10

---

### Q4 - Blob Immutability

Requirement: Regulatory records cannot be modified or permanently deleted
during the configured retention period.

Answer: Blob Immutability.

Result: PASSED

Score: 10/10

---

### Q5 - Private DNS

Requirement: Private Endpoint exists but Storage hostname resolves to public IP.

Answer: Investigate Private DNS / DNS configuration.

Result: PASSED

Score: 10/10

---

### Q6 - RBAC Scope

Requirement: Storage Blob Data Reader is assigned at the finance container
scope, while access to hr fails.

Answer: Investigate RBAC scope.

Result: PASSED

Score: 10/10

---

### Q7 - ZRS Architecture

Requirement: Application must remain available if one availability zone fails.

Answer: ZRS provides redundancy across availability zones within the same region.

Result: PASSED

Score: 10/10

---

### Q8 - Blob Versioning

Requirement: Recover previous blob contents after an accidental overwrite.

Answer: Blob Versioning.

Result: PASSED

Score: 10/10

---

### Q9 - Blob Soft Delete

Requirement: Restore an accidentally deleted blob during the retention period.

Answer: Blob Soft Delete.

Result: PASSED

Score: 10/10

---

### Q10 - Blob Immutability

Requirement: Regulatory records cannot be modified or deleted during the
retention period, including by privileged administrators.

Answer: Blob Immutability.

Result: PASSED

Score: 10/10

---

### Q11 - Storage Network Access

Requirement: Correct RBAC exists, but the application's subnet is not allowed
by Storage networking rules.

Answer: Investigate Storage Account network access rules.

Result: PASSED

Score: 9/10

Note: Correctly identified the network layer. Reinforced the distinction
between Storage Account network rules and NSGs.

---

### Q12 - Managed Identity and Blob RBAC

Requirement: Application needs keyless authentication and read-only blob access.

Answer: Managed Identity for authentication through Microsoft Entra ID and
Storage Blob Data Reader for data-plane authorization.

Result: PASSED

Score: 10/10

---

### Q13 - Private DNS Resolution

Requirement: Storage hostname resolves to public IP despite Private Endpoint.

Answer: Investigate Private DNS / DNS configuration.

Result: PASSED

Score: 10/10

---

### Q14 - RBAC Inheritance

Requirement: Storage Blob Data Reader is assigned at Storage Account scope
and applies to a newly created child container.

Answer: Parent-scope RBAC assignment is inherited by applicable child resources.

Result: PASSED

Score: 10/10

---

### Q15 - Blob Storage

Requirement: Store large amounts of unstructured images and videos using
scalable object storage.

Answer: Azure Blob Storage.

Result: PASSED

Score: 10/10

---

### Q16 - Table Storage

Requirement: Store simple key-value data without relational requirements.

Answer: Azure Table Storage.

Result: PASSED

Score: 10/10

---

### Q17 - Azure Files

Requirement: Multiple Windows servers need a shared file share using SMB.

Answer: Azure Files.

Result: PASSED

Score: 10/10

---

### Q18 - Lifecycle Management

Requirement: Automatically move blobs between Hot, Cool, and Archive tiers.

Answer: Azure Blob Storage Lifecycle Management.

Result: PASSED

Score: 10/10

---

### Q19 - ZRS

Requirement: Protect against an availability-zone failure without requiring
regional disaster recovery.

Answer: ZRS.

Result: PASSED

Score: 10/10

---

### Q20 - RA-GRS

Requirement: Existing GRS storage needs read access to the secondary region
while the primary remains available.

Answer: RA-GRS.

Result: PASSED

Score: 10/10

---

## Retest Summary

Total scenarios: 20

Passed: 20

Failed: 0

Retest status: PASSED

Overall Storage weak-area status: MASTERED

---

## Key Improvements Demonstrated

- Corrected ZRS zone vs region distinction.
- Corrected Storage IP network rules vs NSG.
- Corrected Private Endpoint network-path understanding.
- Corrected Private DNS troubleshooting.
- Corrected Blob Immutability vs Soft Delete vs Resource Lock.
- Confirmed RBAC scope and inheritance.
- Confirmed Managed Identity plus data-plane RBAC.
- Confirmed Blob, Files, and Table Storage workload selection.
- Confirmed access-tier and Lifecycle Management reasoning.
- Confirmed GRS vs RA-GRS and ZRS/GZRS decision-making.

---

## Final Mental Model

Requirement
    ->
Failure domain / workload / access pattern
    ->
Storage capability
    ->
Network / identity / security layer
    ->
RBAC scope
    ->
Required action
    ->
Least privilege

---

## Final Result

Storage Weak-Area Cycle COMPLETE

Discovery -> Reinforcement -> Blind Retest -> Documentation

Status: MASTERED
