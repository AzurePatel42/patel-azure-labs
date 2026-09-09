# AZ-104 Progress Tracker

## Study Start

September 1, 2026

Daily target:

45 minutes

---

## Domain Progress

| Domain | Questions | Scenarios | Troubleshooting | Confidence | Status |
|---|---:|---:|---:|---|---|
| Identity & Governance | 30 | 4 | 4 | Strong Developing | COMPLETE |
| Storage | 30 | 30 | 30 | Strong Developing | COMPLETE |
| Compute | 10 | 0 | 0 | Not assessed | IN PROGRESS |
| Networking | 0 | 0 | 0 | Not assessed | PENDING |
| Monitoring | 0 | 0 | 0 | Not assessed | PENDING |
| Cross-Domain | 0 | 0 | 0 | Not assessed | PENDING |
| Interview Mode | 0 | 0 | 0 | Not assessed | PENDING |
| Mock Exams | 0 | 0 | 0 | Not assessed | PENDING |

---

## Daily Session Tracker

| Date | Minutes | Questions | Scenario | Score | Weak Area |
|---|---:|---:|---|---|---|
| 2026-09-01 | Not recorded | 10 | Completed | 80% | RBAC role vs scope reasoning |
| 2026-09-02 | Not recorded | 10 | Completed | 70% | Managed identity, Key Vault 403, data-plane access |

---

## Question Performance

| Date | Domain | Questions | Correct | Incorrect | Score |
|---|---|---:|---:|---:|---|
| 2026-09-01 | Identity & Governance | 10 | 8 | 2 | 80% |
| 2026-09-02 | Identity & Governance | 10 | 7 | 3 | 70% |

Note:
"Corrected / Learned" answers are intentionally tracked as learning opportunities rather than treated as failures.

---

## Scenario Performance

| Date | Domain | Scenario | Result | Notes |
|---|---|---|---|---|
| 2026-09-01 | Identity & Governance | RBAC scenarios | Completed | Scope and role reasoning |
| 2026-09-02 | Identity & Governance | Managed identity / storage / Key Vault | Completed | Authorization and data-plane reasoning |

---

## Troubleshooting Performance

| Date | Domain | Problem | Diagnosis | Result |
|---|---|---|---|---|
| 2026-09-01 | Identity & Governance | RBAC permission failures | Contributor vs role assignment permission | Completed |
| 2026-09-02 | Identity & Governance | 403 / data-plane / identity issues | Authentication vs authorization | Completed |

---

## Weak Areas

| Topic | First Identified | Reason | Repetition Needed | Retest Result |
|---|---|---|---|---|
| RBAC role vs scope | 2026-09-01 | Initially focused on role without fully explaining scope | Yes | Improving |
| System vs user-assigned managed identity | 2026-09-02 | Needed correction in lifecycle/shared-identity scenarios | Yes | Pending |
| Key Vault 403 troubleshooting | 2026-09-02 | Needed deeper authorization reasoning | Yes | Pending |
| Management vs data plane | 2026-09-02 | Reader vs Blob Data Reader distinction required correction | Yes | Pending |

---

## Mistake Log

### Question

Q17 - App Service has Reader on Storage Account but blob download returns 403.

### Incorrect answer

Initially reasoned around resource-management permissions and considered Contributor.

### Correct answer

Reader is management-plane access. Blob data requires an appropriate Storage data-plane role such as Storage Blob Data Reader.

### Why the original reasoning failed

The reasoning did not clearly separate Azure resource management from access to the actual data.

### What evidence should have been considered

The operation was downloading blob contents, which is a data-plane operation.

### How to recognize this scenario next time

Ask:

"What exactly is the application trying to access?"

If the answer is actual data, investigate the service-specific data-plane role.

---

## Retest Queue

Topics requiring repetition:

1. System-assigned vs user-assigned managed identity
2. Key Vault 403 troubleshooting
3. Management-plane vs data-plane access
4. RBAC inheritance
5. Access-management roles

Questions that should return during future sessions:

1. Managed identity lifecycle
2. Recreated resource + UAMI
3. Key Vault 403
4. Storage Blob Data Reader
5. Contributor vs User Access Administrator

---

## Mock Exam Tracker

| Mock Exam | Date | Questions | Correct | Score | Weakest Domain | Retest Complete |
|---|---|---:|---:|---:|---|---|
| Mock 01 | - | 0 | 0 | - | - | - |
| Mock 02 | - | 0 | 0 | - | - | - |
| Mock 03 | - | 0 | 0 | - | - | - |

---

## Confidence Tracker

| Domain | Initial Confidence | Current Confidence | Target |
|---|---|---|---|
| Identity & Governance | Not assessed | Strong Developing | Interview-ready |
| Storage | Not assessed | Strong Developing | Interview-ready |
| Compute | Not assessed | Not assessed | Interview-ready |
| Networking | Not assessed | Not assessed | Interview-ready |
| Monitoring | Not assessed | Not assessed | Interview-ready |

---

## Study Milestones

- [x] Start daily 45-minute sessions
- [x] Complete first 20 Identity & Governance questions
- [x] Complete Identity & Governance 30-question foundation
- [x] Complete Storage question foundation
- [ ] Complete Compute question foundation
- [ ] Complete Networking question foundation
- [ ] Complete Monitoring question foundation
- [ ] Begin cross-domain scenarios
- [ ] Begin interview mode
- [ ] Complete first mock exam
- [ ] Identify weak areas
- [ ] Complete second mock exam
- [ ] Complete third mock exam
- [ ] Consistent scenario performance
- [ ] Consistent troubleshooting performance
- [ ] Interview-ready explanations

---

## Current Position

AZ-104 Identity & Governance

Questions completed:

30

Current next target:

Storage Q11-Q20

Identity & Governance foundation is complete. The next objective is Storage.

---

## Final Goal

The goal is not simply:

Pass an exam

The goal is:

Understand Azure
      +
Reason through scenarios
      +
Troubleshoot systems
      +
Explain architecture
      +
Communicate clearly
      +
Connect theory to hands-on experience

That creates durable Azure engineering knowledge.

# September 5, 2026 - Storage Foundation

## Storage Q1-Q10

Questions completed:

10 / 10

Domain status:

FOUNDATION COMPLETE

Session scores:

- Q1 - 6/10
- Q2 - 9/10
- Q3 - 9/10
- Q4 - 9.5/10
- Q5 - 6.5/10
- Q6 - 10/10
- Q7 - 10/10
- Q8 - 9/10
- Q9 - 10/10
- Q10 - 10/10

Primary learning themes:

- Storage Account hierarchy
- Blob Storage
- Blob containers
- Storage Blob Data Reader
- Management plane vs data plane
- Least-privilege RBAC
- LRS / ZRS / GRS / GZRS
- Blob access tiers
- Hot / Cool / Cold / Archive
- Blob Lifecycle Management
- Storage troubleshooting

Key corrections reinforced:

1. Container organizes blobs, not arbitrary Azure resources.
2. ZRS protects against availability-zone failure but not a complete regional outage.
3. GZRS provides zone + geo redundancy.
4. Reader is management-plane access and does not grant blob-data access.
5. Storage Blob Data Reader provides read access to blob contents.
6. Lifecycle Management can automate tier transitions and deletion.

Current Next Target:

Storage Q21-Q30

Storage progression:

Q1-Q10  -> Foundation COMPLETE
Q11-Q20 -> Intermediate
Q21-Q30 -> Advanced / SME
---

# September 6, 2026 - Storage Q11-Q20

## Storage Q11-Q20

Questions completed:

20 / 30

Session scores:

- Q11 - 4/10
- Q12 - 10/10
- Q13 - 10/10
- Q14 - 10/10
- Q15 - 10/10
- Q16 - 6/10
- Q17 - 10/10
- Q18 - 8/10
- Q19 - 10/10
- Q20 - 10/10

Average:

88%

Combined Storage Q1-Q20:

88.5%

### Primary Learning Themes

- Managed Identity
- Microsoft Entra ID authentication
- Azure RBAC authorization
- Authentication vs authorization
- SAS delegated access
- SAS permissions vs RBAC roles
- Key Vault vs Managed Identity
- Storage Blob Data Reader
- Storage Blob Data Contributor
- Container-level least privilege
- Azure Files vs Blob Storage
- AuthorizationPermissionMismatch troubleshooting

### Weak Areas Identified

1. Managed Identity vs SAS
2. Managed Identity vs storing secrets in Key Vault
3. SAS permissions vs Azure RBAC roles

### Key Corrections

1. Managed Identity is preferred for Azure workloads when supported because it avoids storing application credentials.
2. Key Vault securely stores secrets; it does not eliminate the secret itself.
3. SAS provides delegated, time-limited access and does not use RBAC role names.
4. Storage Blob Data Reader allows read access but not blob upload or deletion.
5. Storage Blob Data Contributor allows read, write, and delete blob data.
6. Authentication success does not guarantee authorization for the requested operation.

### Current Position

Identity & Governance:

30 / 30 - COMPLETE

Storage:

20 / 30 - IN PROGRESS

Next target:

Storage Q21-Q30

Progression:

Q1-Q10
  ->
Foundation

Q11-Q20
  ->
Intermediate COMPLETE

Q21-Q30
  ->
Advanced / SME

Then:

Scenario
  ->
Troubleshooting
  ->
Retest

---

# September 7, 2026 - Storage Q21-Q30

## Storage Q21-Q30

Questions completed:

30 / 30

Session scores:

- Q21 - 8.5/10
- Q22 - 8.5/10
- Q23 - 7/10
- Q24 - 5.5/10
- Q25 - 6/10
- Q26 - 9/10
- Q27 - 7.5/10
- Q28 - 6/10
- Q29 - 10/10
- Q30 - 7.5/10

Average:

75%

Combined Storage Q1-Q30:

84%

### Primary Learning Themes

- Managed Identity vs SAS
- Managed Identity vs Key Vault
- Management plane vs data plane
- Storage Blob Data Reader vs Storage Blob Data Contributor
- RBAC role selection
- Container-level RBAC scope
- Private Endpoint
- Private Endpoint vs Service Endpoint
- Private Endpoint vs NSG
- Private DNS
- GRS vs RA-GRS vs failover
- GZRS
- Storage networking troubleshooting
- Layered Storage security architecture
- Blob Lifecycle Management

### Storage Weak Areas

1. Managed Identity vs SAS
2. Managed Identity vs Key Vault
3. Management plane vs data plane
4. Private Endpoint vs NSG
5. GRS vs RA-GRS vs failover
6. Private Endpoint DNS troubleshooting
7. Selecting the correct Storage Blob Data role
8. Separating authentication, authorization, scope, and network layers

### Key Corrections

1. Managed Identity + Microsoft Entra ID + Azure RBAC is preferred for Azure-hosted applications when supported.
2. SAS is appropriate for temporary or delegated access.
3. Key Vault stores secrets; using Key Vault still means the application is using a secret.
4. Management-plane permissions do not automatically authorize blob data operations.
5. Storage Blob Data Reader provides blob-data read access.
6. Storage Blob Data Contributor provides blob-data read, write, and delete access.
7. Private Endpoint provides private connectivity; it does not replace authentication or authorization.
8. Private DNS is critical when using Private Endpoint with public access disabled.
9. GRS provides geo-replication; RA-GRS adds read access to the secondary.
10. Failover promotes the secondary to the primary.
11. GZRS combines zone redundancy with geo-replication.
12. A 403 after a Private Endpoint change should prompt investigation of the network and DNS path when RBAC has already been verified.

### Current Position

Identity & Governance:

30 / 30 - COMPLETE

Storage:

30 / 30 - COMPLETE

Next target:

Compute module review before Compute Q1-Q30

Progression:

Identity & Governance
  ->
30 Questions COMPLETE

Storage
  ->
30 Questions COMPLETE

Compute
  ->
Review AZ-104 Compute lab/module

Then:

Compute Q1-Q30
  ->
Scenario
  ->
Troubleshooting
  ->
Retest


# September 9, 2026 - Compute Q1-Q10

## Compute Q1-Q10

Questions completed:

10 / 30

Domain status:

FOUNDATION IN PROGRESS

Average score:

77.5%

### Session Scores

- Q1 - 8/10
- Q2 - 9/10
- Q3 - 4/10
- Q4 - 8/10
- Q5 - 6/10
- Q6 - 8.5/10
- Q7 - 9/10
- Q8 - 9/10
- Q9 - 7.5/10
- Q10 - 8.5/10

### Primary Learning Themes

- Azure Virtual Machines
- IaaS and VM decision-making
- Virtual Machine Scale Sets
- Autoscaling
- Load Balancer
- Health probes
- Windows RDP vs Linux SSH
- Azure RBAC vs guest OS permissions
- Managed Disks
- Temporary Disk
- Availability Sets
- Availability Zones
- Storage redundancy vs VM availability
- Key Vault and Managed Identity
- Azure Monitor and VM troubleshooting
- Compute architecture decision-making

### Compute Weak Areas

1. RDP vs SSH
2. Azure RBAC vs guest OS permissions
3. Availability Sets vs Availability Zones
4. Storage redundancy vs VM availability
5. Scaling vs availability
6. Load Balancer vs VMSS responsibilities
7. VM running vs application healthy
8. Azure Monitor troubleshooting beyond CPU

### Key Corrections

1. Windows Server remote administration normally uses RDP over TCP 3389; SSH over TCP 22 is normally associated with Linux administration.
2. Azure RBAC controls Azure resource management; guest OS permissions control what the administrator can do inside the operating system.
3. Availability Sets and Availability Zones provide compute availability; ZRS is a storage redundancy mechanism.
4. Scaling addresses changing workload capacity; availability addresses resilience to failures.
5. Load Balancer distributes traffic and uses health probes; VMSS manages the VM instances and scaling.
6. A VM being running does not guarantee that the application inside it is healthy.
7. Temporary Disk is non-persistent and should not be used for durable database data.
8. Managed Disks provide persistent storage for VM workloads.
9. Key Vault provides secure secret storage; Managed Identity provides workload identity for accessing Azure resources.
10. VM troubleshooting should investigate CPU, memory, disk I/O, network, application health, and dependencies rather than assuming CPU is the bottleneck.
11. For stronger compute fault isolation, Availability Zones should be considered when the workload and region support them.
12. Multiple healthy instances, appropriate failure-domain placement, Load Balancing, and autoscaling solve different parts of a resilient compute architecture.

### Compute Scenario Coverage

10 scenarios completed.

Primary scenario areas:

- Selecting Azure VM for full OS control
- Selecting VMSS for variable workload
- Windows remote administration
- Persistent application storage
- Infrastructure failure
- Application health detection
- Database persistence
- Application secrets
- VM performance investigation
- Production VMSS architecture

### Compute Troubleshooting Coverage

10 troubleshooting patterns completed.

Primary troubleshooting areas:

- RDP vs SSH
- Azure RBAC vs guest OS permissions
- Storage redundancy vs compute availability
- Availability vs scaling
- VMSS vs Load Balancer responsibilities
- VM running vs application healthy
- Temporary Disk vs persistent storage
- Key Vault vs configuration files
- Low CPU but slow application
- VMSS availability architecture

### Current Compute Position

Compute Q1-Q10:

10 / 30 - COMPLETE

Compute Q11-Q20:

PENDING

Compute Q21-Q30:

PENDING

Current average:

77.5%

Current priority:

Review the AZ-104 Compute module and labs, then reinforce the identified weak areas before continuing with Q11-Q20.

### Progression

Identity & Governance
  ->
30 Questions COMPLETE

Storage
  ->
30 Questions COMPLETE

Compute
  ->
10 Questions COMPLETE

Then:

Compute module/lab review
  ->
Weak-area reinforcement
  ->
Compute Q11-Q20
  ->
Compute Q21-Q30
  ->
Scenario
  ->
Troubleshooting
  ->
Retest
