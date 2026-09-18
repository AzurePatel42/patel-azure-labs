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
| Compute | 30 | 30 | 30 | Developing | COMPLETE |
| Networking | 20 | 20 | 20 | Not assessed | IN PROGRESS |
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
| Compute | Not assessed | Developing | Interview-ready |
| Networking | Not assessed | Not assessed | Interview-ready |
| Monitoring | Not assessed | Not assessed | Interview-ready |

---

## Study Milestones

- [x] Start daily 45-minute sessions
- [x] Complete first 20 Identity & Governance questions
- [x] Complete Identity & Governance 30-question foundation
- [x] Complete Storage question foundation
- [x] Complete Compute question foundation
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

AZ-104 Networking

Questions completed:

20

Current next target:

Networking Q21-Q30

Networking Q1-Q20 foundation is complete. The next objective is Networking Q21-Q30.

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

---

# September 12, 2026 - Compute Q11-Q20

## Compute Q11-Q20

Questions completed:

10 / 30 additional questions

Session score:

72%

Cumulative Compute progress:

20 / 30 questions complete

Cumulative Compute average:

74.75%

### Primary Learning Themes

- VM sizing and CPU/RAM capacity
- Managed disk capacity and disk management
- OS disk vs data disk vs Temporary Disk
- VMSS autoscaling
- Availability Sets vs Availability Zones
- Azure Run Command
- Managed Disks vs snapshots
- Regional disaster recovery with Azure Site Recovery
- Scaling vs availability vs disaster recovery

### Compute Weak Areas

1. VM sizing and SKU selection
2. CPU/RAM capacity vs storage capacity
3. Disk expansion and guest OS filesystem considerations
4. Azure Run Command and guest OS command execution
5. Managed Disk vs Snapshot distinction
6. Availability architecture vs regional disaster recovery

### Strong Areas Reinforced

1. VMSS and autoscaling
2. Managed Disks
3. Availability Zones
4. Azure Site Recovery
5. Compute architecture decision-making

### Key Corrections

1. Increasing CPU or RAM requires changing the VM size/SKU, not adding a managed data disk.
2. Managed disks provide persistent storage capacity; they do not increase VM CPU or RAM.
3. Disk expansion may require extending the partition/filesystem inside the guest OS.
4. VMSS provides centralized management of multiple VM instances and supports autoscaling.
5. Availability Sets use fault domains and update domains, while Availability Zones provide stronger physical fault isolation.
6. Azure Run Command executes commands inside a VM without requiring inbound RDP or SSH access.
7. Managed Disks are persistent storage resources; snapshots are point-in-time copies used as a source for creating disks.
8. Azure Site Recovery addresses regional disaster recovery and failover rather than ordinary VM availability.
9. Scaling handles changing workload capacity; availability handles resilience to failures; disaster recovery handles larger failure events such as regional outages.

### Scenario Coverage

Q11-Q20 scenario reinforcement documented.

Primary scenario areas:

- VM sizing
- Disk capacity and management
- VMSS autoscaling
- Availability Sets
- Availability Zones
- Run Command
- Snapshots
- Regional disaster recovery

### Troubleshooting Coverage

Q11-Q20 troubleshooting patterns documented.

Primary troubleshooting areas:

- VM CPU/RAM vs storage bottlenecks
- Disk capacity and expansion
- Run Command vs RDP/SSH
- Managed Disk vs Snapshot
- Availability vs disaster recovery
- VMSS scaling behavior

### Session Assessment

Compute Q11-Q20 exposed a second layer of weaknesses: the architectural concepts are becoming stronger, but detailed Azure Compute mechanics still require reinforcement.

The main learning pattern is:

> Capacity -> Storage -> Availability -> Scaling -> Recovery

The next Compute cycle should continue testing these distinctions under scenario pressure.

### Next Target

Compute Q21-Q30

Before starting Q21-Q30, reinforce:

- VM sizing/SKU selection
- Disk management
- Azure Run Command
- Managed Disk vs Snapshot
- Availability Set vs Zone
- Availability vs Disaster Recovery

---

# September 14, 2026 - Compute Q21-Q30

## Compute Q21-Q30

Questions completed:

10 / 10

Domain status:

FOUNDATION COMPLETE

Session score:

80%

Cumulative Compute progress:

30 / 30 questions complete

Cumulative Compute average:

76.5%

### Session Scores

- Q21 - 9/10
- Q22 - 8/10
- Q23 - 6.5/10
- Q24 - 7.5/10
- Q25 - 7/10
- Q26 - 7/10
- Q27 - 8/10
- Q28 - 8/10
- Q29 - 9/10
- Q30 - 9/10

### Primary Learning Themes

- Production VMSS architecture
- Load Balancer responsibilities
- Availability Zones
- Azure RBAC vs Windows guest OS permissions
- RDP and guest access
- VM health vs application health
- Capacity vs traffic distribution
- Layer-by-layer troubleshooting
- Temporary Disk vs persistent database storage
- VM performance troubleshooting
- VMSS scaling vs Load Balancer responsibilities
- Production incident response

### Compute Q21-Q30 Weakness Areas

1. VM health vs application health
2. Capacity problem vs traffic distribution problem
3. Layer-by-layer troubleshooting
4. Availability Zone failure behavior
5. Detailed production incident troubleshooting

### Strong Areas Reinforced

1. VMSS architecture
2. Load Balancer responsibilities
3. Availability Zones
4. Scaling vs traffic distribution
5. Persistent vs temporary storage
6. Evidence-driven troubleshooting

### Key Corrections

1. Load Balancer distributes traffic; VMSS manages instance capacity and scaling.
2. Availability Zones provide physical infrastructure isolation within a region.
3. Azure Contributor access does not automatically provide Windows administrator access inside the guest OS.
4. Windows remote administration normally uses RDP over TCP 3389.
5. A VM being Running does not prove that the application is healthy.
6. High CPU across most instances points toward a capacity/scaling investigation.
7. High CPU on only a few instances should prompt investigation of traffic distribution and application behavior.
8. Temporary Disk should not be used for durable production database storage.
9. Normal CPU and memory do not eliminate disk, network, application, database, DNS, or dependency problems.
10. A configuration change immediately preceding an incident should be investigated using temporal correlation and evidence.

### Scenario Coverage

10 additional Compute scenarios completed.

Primary scenario areas:

- Production VMSS + Load Balancer + Availability Zones
- Azure RBAC vs Windows guest OS permissions
- VM health vs application health
- Capacity vs traffic distribution
- Availability Zone failure
- Layer-by-layer troubleshooting
- Temporary Disk vs production database
- VM performance troubleshooting
- VMSS scaling vs Load Balancer
- Production incident troubleshooting

### Troubleshooting Coverage

10 additional Compute troubleshooting patterns completed.

Primary troubleshooting areas:

- RDP and guest access
- Application health detection
- Capacity vs distribution
- Zone failure
- Network and dependency investigation
- Persistent vs temporary storage
- Disk and network performance
- VMSS scaling
- Load Balancer behavior
- Configuration-change incident response

### Final Compute Learning Pattern

Architecture
    ->
Capacity
    ->
Availability
    ->
Traffic Distribution
    ->
Health
    ->
Network
    ->
Application
    ->
Dependencies
    ->
Recovery

### Compute Q1-Q30 Overall

Q1-Q10: 77.5%

Q11-Q20: 72%

Q21-Q30: 80%

Overall:

76.5%

### Current Position

Compute Q1-Q30:

30 / 30 - COMPLETE

Compute Weak-Area Brainstorming:

COMPLETE

Compute Weak-Area Retest:

COMPLETE

Next:

AZ-104 Networking

---


---

# September 17, 2026 - Compute Weak-Area Brainstorming and Retest

## Compute Weak-Area Completion

### Status

COMPUTE WEAK AREAS COMPLETE

### Weak Areas Reinforced

1. VM health vs application health
2. Capacity vs traffic distribution
3. Layer-by-layer troubleshooting
4. Availability Zone failure behavior
5. Production incident troubleshooting

### Retest Result

All identified Compute weak-area concepts were reviewed and reinforced
through scenario-based reasoning and structured troubleshooting.

### Final Compute Position

Compute Q1-Q30:

30 / 30 - COMPLETE

Overall Compute score:

76.5%

Scenario coverage:

30 / 30 - COMPLETE

Troubleshooting coverage:

30 / 30 - COMPLETE

Weak-area brainstorming:

COMPLETE

Weak-area retest:

COMPLETE

### Final Compute Reasoning Model

Architecture
    ->
Capacity
    ->
Availability
    ->
Traffic Distribution
    ->
Health
    ->
Network
    ->
Application
    ->
Dependencies
    ->
Recovery

### Compute Completion Decision

Compute foundation, scenario coverage, troubleshooting coverage, weak-area
brainstorming, and weak-area retest are complete.

The next AZ-104 domain is Networking.

### Next Target

AZ-104 Networking module review
    ->
Networking Q1-Q10
    ->
Networking Q11-Q20
    ->
Networking Q21-Q30
    ->
Scenario
    ->
Troubleshooting
    ->
Weak-Area Identification
    ->
Retest

---

# September 18, 2026 - Networking Q11-Q20

## Networking Q11-Q20

Questions completed:

10 / 10

Session score:

9.65 / 10

Networking progress:

20 / 30 questions complete

### Q11-Q20 Session Scores

- Q11 - 10/10
- Q12 - 10/10
- Q13 - 10/10
- Q14 - 10/10
- Q15 - 10/10
- Q16 - 10/10
- Q17 - 7.5/10
- Q18 - 10/10
- Q19 - 10/10
- Q20 - 9/10

### Primary Learning Themes

- Same VNet private communication
- VNet Peering
- NSG layer troubleshooting
- Routing and next-hop reasoning
- Network appliance failure
- Service Endpoint vs Private Endpoint
- Private DNS
- Load Balancer vs Application Gateway
- Application Gateway path-based routing
- Application Gateway health probes
- HTTP 403 and authorization reasoning
- Cross-domain troubleshooting

### Strong Areas

- VNet architecture
- VNet Peering
- NSG troubleshooting
- Routing reasoning
- Application Gateway
- Health probe troubleshooting
- Layer-by-layer troubleshooting

### Reinforcement Area

Private DNS and the discipline of moving upward through the troubleshooting model only after lower layers have been proven.

### Key Corrections

1. Subnets provide logical segmentation; they do not automatically provide security isolation.
2. VNet Peering provides private connectivity but does not guarantee correct routing.
3. A valid route does not guarantee that a next-hop network appliance is available.
4. Private Endpoint scenarios require correct private name resolution when using service hostnames.
5. Application Gateway provides Layer 7 routing and supports URL path-based routing.
6. Application Gateway health depends on successful health probe communication with the backend service.
7. HTTP 403 indicates that the request reached the service but access was denied.
8. Network reachability and authorization are separate troubleshooting layers.
9. Do not return to a lower troubleshooting layer after evidence has already proven it works.

### Networking Mental Model

VNet
  ->
Subnet
  ->
NIC
  ->
VM

Supporting controls:

Route -> traffic path
NSG -> traffic filtering
DNS -> name resolution

Connectivity:

VNet Peering -> private VNet-to-VNet connectivity
Private Endpoint -> private Azure service connectivity

Application delivery:

Load Balancer -> Layer 4
Application Gateway -> Layer 7 + health probing

### Cross-Domain Reasoning Model

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

### Networking Module Status

Q1-Q10: COMPLETE
Q11-Q20: COMPLETE

Current position:

20 / 30 questions complete

Next target:

Networking Q21-Q30

Then:

Scenario
  ->
Troubleshooting
  ->
Weak-Area Identification
  ->
Retest
