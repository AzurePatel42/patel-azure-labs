# AZ-104 Compute Questions

## Q1 - Azure VM for Full OS Control

### Scenario

An application requires:

- Windows operating system
- Full administrative control over the OS
- Ability to install custom software
- Ability to configure the OS
- Persistent disk storage
- No current requirement for automatic scaling

### Question

Which Azure compute service would you choose, and why?

### Answer

Azure Virtual Machine (VM).

### Key Reasoning

Azure VM provides IaaS-level control over the operating system.

The administrator can:

- Configure the OS
- Install custom software
- Manage the guest operating system
- Configure storage
- Monitor and troubleshoot
- Perform patch management

Because automatic scaling is not currently required, a VM is appropriate rather than introducing VM Scale Sets solely for scaling.

### Key Lesson

Azure VM = high OS control + higher operational responsibility.

---

## Q2 - VM Scale Sets and Autoscaling

### Scenario

An application runs on multiple Azure VMs.

Traffic varies significantly throughout the day.

Requirements:

- Automatic scale-out
- Automatic scale-in
- Higher availability
- Multiple VM instances

### Answer

Use Azure Virtual Machine Scale Sets (VMSS).

### Scaling Example

CPU > 70%
    |
    | sustained for 10 minutes
    v
Scale Out

CPU < 30%
    |
    | sustained for 5 minutes
    v
Scale In

Thresholds and evaluation periods are design choices and should be tuned based on application behavior.

### Availability

Multiple VM instances can continue serving traffic when one instance fails, especially when combined with a load-balancing mechanism.

### Key Lesson

VMSS provides managed VM instance scaling and lifecycle management.

---

## Q3 - Windows VM Remote Administration

### Scenario

A Windows Server Azure VM needs remote administrative access.

### Initial Answer

SSH using TCP port 22.

### Correction

For normal Windows remote desktop administration:

RDP
TCP 3389

SSH/TCP 22 is normally associated with Linux remote administration.

### Network Model

Windows Desktop
    |
    | RDP / TCP 3389
    v
Azure VM
    |
    v
Windows Guest OS

### Security Consideration

Do not blindly expose TCP 3389 to the entire public internet.

Consider:

- Restricted source access
- Private connectivity
- Azure Bastion
- Appropriate network security controls

### Key Lesson

RDP = Windows remote administration

SSH = Linux/Unix remote administration

---

## Q4 - Azure Managed Disks

### Scenario

A production VM requires persistent application data and frequent read/write operations.

### Answer

Use an Azure managed data disk with an appropriate performance tier, such as Premium SSD when the workload requires higher I/O performance.

### Disk Architecture

Azure VM
    |
    +-- OS Managed Disk
    |
    +-- Data Managed Disk
            |
            +-- Application Data

### Important Distinction

The OS disk is persistent.

The temporary disk is separate and is intended for temporary/non-persistent data.

### Key Lesson

OS disk = persistent operating system

Data disk = persistent application data

Temporary disk = temporary/non-persistent data

---

## Q5 - VM Availability

### Scenario

A VM becomes unavailable because the physical infrastructure hosting it experiences a failure.

### Initial Answer

ZRS.

### Correction

ZRS is a Storage redundancy feature, not a VM availability feature.

For VM availability, consider:

- Availability Sets
- Availability Zones

### Availability Set

Provides fault-domain and update-domain separation within a region.

### Availability Zones

Place VM instances in physically separate zones within an Azure region.

### Mental Model

Storage:

ZRS
    |
    +-- Storage redundancy across zones

Compute:

Availability Zones
    |
    +-- VM instances across zones

### Key Lesson

Do not confuse Storage redundancy with VM availability.

---

## Q6 - Load Balancer Health Probes

### Scenario

A VM Scale Set runs a web application behind a load balancer.

A VM is running, but the application process has crashed.

### Answer

Use a Load Balancer health probe.

The probe checks the configured protocol and port to determine whether the application endpoint is healthy.

### Failure Flow

Health probe fails
        |
        v
Instance considered unhealthy
        |
        v
Load Balancer stops sending new traffic
        |
        v
VMSS can manage the instance depending on its configured health/repair behavior

### Key Lesson

VM running does not necessarily mean application healthy.

Load Balancer = traffic distribution

Health Probe = health detection

VMSS = instance management/scaling

---

## Q7 - Temporary Disk vs Persistent Database Storage

### Scenario

A database requires persistent storage and high I/O performance.

A developer proposes using the VM temporary disk because it is fast.

### Answer

Do not store durable database files on the temporary disk.

Use persistent Azure managed data disks with an appropriate performance tier.

### Reasoning

Temporary disk data is not intended for durable application data and can be lost during VM lifecycle or host changes.

### Mental Model

Temporary Disk
    |
    +-- Temporary data
    +-- Cache
    +-- Non-persistent workloads

Managed Data Disk
    |
    +-- Persistent database data
    +-- Application data

### Key Lesson

Database storage decisions require:

Performance
+
Persistence
+
Durability

---

## Q8 - Key Vault and Managed Identity

### Scenario

An application requires:

- Database credentials
- API secrets
- Connection strings

A developer proposes storing them directly in application configuration.

### Answer

Use Azure Key Vault for secret storage.

Use the application's Managed Identity to authenticate through Microsoft Entra ID.

### Architecture

Application / VM
      |
      +-- Managed Identity
              |
              v
        Microsoft Entra ID
              |
              v
         Azure Key Vault
              |
              v
            Secrets

### Security Benefit

Key Vault reduces the risk of secrets being exposed through:

- Application source code
- Configuration files
- Source control
- VM configuration

### Key Lesson

Key Vault stores secrets.

Managed Identity provides application identity.

Microsoft Entra ID provides authentication.

Authorization controls access to the secrets.

---

## Q9 - VM Performance Troubleshooting

### Scenario

A production VM becomes slow.

### Investigation

Check:

- CPU utilization
- Memory
- Disk I/O
- Disk latency
- Network throughput
- Network latency

### Important Scenario

If CPU is only 20%, do not assume the VM is healthy.

Investigate other possible bottlenecks.

Example:

CPU = 20%
    |
    v
Disk latency high
    |
    v
Application waits for I/O
    |
    v
Application becomes slow

Or:

CPU = 20%
    |
    v
Network latency high
    |
    v
Dependency calls slow
    |
    v
Application becomes slow

### Key Lesson

Use evidence to identify the bottleneck instead of assuming CPU is the problem.

---

## Q10 - Production VM Architecture

### Scenario

An application requires:

- Higher availability
- Automatic scaling
- Load balancing
- Multiple VM instances
- Protection against a single VM failure

### Answer

Use:

- Virtual Machine Scale Sets
- Load Balancer
- Multiple VM instances
- Availability Zones where stronger infrastructure isolation is required
- Autoscaling policies

### Architecture

                         Internet
                            |
                            v
                     Azure Load Balancer
                            |
              +-------------+-------------+
              |             |             |
           VMSS          VMSS          VMSS
          Zone 1         Zone 2         Zone 3
              |             |             |
              +-------------+-------------+
                            |
                       Autoscaling

### Responsibilities

VMSS
    |
    +-- Instance management
    +-- Scale out
    +-- Scale in

Load Balancer
    |
    +-- Distribute traffic
    +-- Use health probes

Availability Zones
    |
    +-- Physical infrastructure isolation

Autoscaling
    |
    +-- Adjust capacity based on workload

### Key Lesson

Availability comes from multiple healthy instances distributed across failure domains/zones.

VMSS provides the mechanism to manage and scale those instances.

Scaling and availability solve different problems.

---

# Compute Q1-Q10 Foundation Summary

Questions completed:

10 / 10

Average:

77.5%

### Strong Areas

- Azure VM fundamentals
- VM Scale Sets
- Autoscaling concepts
- Managed Disks
- Temporary vs persistent storage
- Key Vault + Managed Identity
- Load Balancer health probes
- Basic VM troubleshooting

### Weak Areas

1. RDP vs SSH
2. Azure RBAC vs guest OS permissions
3. Availability Sets vs Availability Zones
4. Storage redundancy vs VM availability
5. Scaling vs availability
6. Load Balancer vs VMSS responsibilities
7. VM running vs application healthy
8. Azure Monitor troubleshooting beyond CPU

### Current Learning Strategy

Review the AZ-104 Compute module/labs before continuing to Q11-Q20.

Use the Compute module to strengthen the weak areas identified during Q1-Q10.

---

# Compute Q11-Q20 — Weakness Detection Cycle

## Q11 - VM Sizing

### Scenario

A VM is running an application that has insufficient CPU and memory capacity.

### Initial Reasoning

Adding a managed data disk or using the temporary disk does not increase the VM's CPU or RAM.

### Correct Direction

Resize the VM by selecting an appropriate VM size/SKU with the required:

- vCPU
- RAM
- Performance characteristics

### Key Considerations

Before resizing, consider:

- Target VM SKU availability
- Cost
- Supported VM family
- Whether the VM must be stopped/deallocated
- Application downtime

### Key Lesson

CPU and RAM capacity come from the VM size/SKU.

Storage capacity comes from disks.

---

## Q12 - VM Disk Management

### Scenario

A VM is running out of storage capacity.

### Correct Direction

Consider:

- Attaching an additional managed data disk
- Expanding the existing managed disk

After increasing disk capacity, the guest operating system may also require:

- Partition extension
- Filesystem extension

### Key Lesson

Increasing Azure disk capacity and making that capacity available inside the guest OS can be separate steps.

---

## Q13 - VMSS Autoscaling

### Scenario

An application experiences:

- 90-95% CPU during peak periods
- 15-20% CPU overnight
- Variable workload
- Need for automatic capacity adjustment

### Answer

Use VM Scale Sets with autoscaling.

### Reasoning

High sustained workload:

CPU
 |
 v
Scale Out
 |
 v
More VM instances

Low workload:

CPU
 |
 v
Scale In
 |
 v
Fewer VM instances

### Key Lesson

Scale out = more VM instances.

Scale up = larger VM size.

---

## Q14 - VM Infrastructure Failure

### Scenario

A VM experiences a problem with the physical infrastructure hosting it.

### Initial Reasoning

Availability Sets are relevant because they distribute VMs across fault and update domains.

### Refinement

Availability Sets help reduce the impact of:

- Hardware failure
- Planned maintenance

They are not a substitute for a complete disaster-recovery strategy.

### Key Lesson

Availability architecture and disaster recovery solve different failure scopes.

---

## Q15 - Availability Set vs Availability Zone

### Scenario

A workload needs protection from planned maintenance and hardware failures within a region.

### Answer

Availability Sets can distribute VM instances across fault and update domains.

Availability Zones provide stronger physical isolation by placing resources in separate zones within an Azure region.

### Key Lesson

Availability Set:

Fault domains + Update domains

Availability Zone:

Physical zone-level isolation

---

## Q16 - Azure Run Command

### Scenario

An administrator needs to execute a command inside a VM's guest operating system without opening an inbound RDP connection.

### Answer

Use Azure Run Command.

### Important Distinction

Run Command allows commands/scripts to be executed inside the guest OS through Azure management mechanisms.

It is different from:

- RDP
- SSH

### Key Lesson

Azure management access and guest OS command execution are different concerns.

---

## Q17 - Managed Disks

### Scenario

A VM requires persistent application data.

### Answer

Use an Azure managed data disk.

Managed disks provide persistent block storage managed by Azure.

### Important Distinction

Managed disk:

Persistent storage resource

Temporary disk:

Temporary/non-persistent storage

### Key Lesson

Use managed disks for durable VM application data.

---

## Q18 - VMSS for Identical VM Instances

### Scenario

An application requires approximately 50 identical VM instances with:

- Consistent configuration
- Centralized instance management
- Autoscaling
- Load balancing

### Answer

Use VM Scale Sets.

Combine VMSS with an appropriate load-balancing mechanism when application traffic must be distributed.

### Key Lesson

VMSS is designed to manage groups of similar VM instances at scale.

---

## Q19 - Disk Snapshot

### Scenario

An administrator needs a point-in-time copy of a managed disk before making a risky change.

### Answer

Create a snapshot of the managed disk.

### Purpose

A snapshot captures the disk state at a point in time and can be used as a source for creating another managed disk.

### Important Distinction

Managed Disk:

Active persistent block storage

Snapshot:

Point-in-time copy of disk state

Snapshot should not automatically be treated as a complete backup strategy.

### Key Lesson

Snapshot = point-in-time disk copy.

---

## Q20 - Regional Disaster Recovery

### Scenario

A workload must be recoverable if the primary Azure region experiences a major outage.

### Answer

Use Azure Site Recovery for disaster recovery and failover scenarios.

### Failure Scope

Availability Set
 |
 +-- VM infrastructure distribution

Availability Zone
 |
 +-- Zone-level infrastructure isolation

Azure Site Recovery
 |
 +-- Regional disaster recovery

### Key Lesson

Choose the recovery mechanism based on the failure domain.

---

# Q11-Q20 Results

| Question | Score | Primary Lesson |
|---|---:|---|
| Q11 | 2/10 | VM sizing and SKU selection |
| Q12 | 5/10 | Disk capacity and guest OS extension |
| Q13 | 10/10 | VMSS and autoscaling |
| Q14 | 7/10 | Availability and infrastructure failure |
| Q15 | 9/10 | Availability Sets vs Zones |
| Q16 | 4/10 | Azure Run Command |
| Q17 | 9/10 | Managed Disks |
| Q18 | 10/10 | VMSS architecture |
| Q19 | 6/10 | Disk snapshots |
| Q20 | 10/10 | Azure Site Recovery |

### Q11-Q20 Score

7.2 / 10

### Weakness Pattern

Strong:

- VMSS
- Autoscaling
- Availability concepts
- Availability Zones
- Site Recovery
- Managed Disks
- High-level architecture

Needs reinforcement:

- VM sizing
- CPU/RAM vs storage
- OS disk vs data disk
- Azure Run Command
- Disk snapshots
- Precise availability/recovery mechanics

### Learning Insight

The Q11-Q20 cycle shows stronger architectural reasoning than detailed Compute mechanics.

The next reinforcement cycle should deliberately target the weak areas rather than simply repeating broad Compute questions.

---

## Q21 - Production VMSS + Load Balancer + Availability Zones

### Scenario

A production Windows web application has:

- Unpredictable traffic
- High availability if a VM fails
- Requirement to survive a single Availability Zone failure
- Automatic scaling based on demand
- A single frontend endpoint
- Traffic sent only to healthy VM instances

### Answer

Use:

- Virtual Machine Scale Sets (VMSS)
- Azure Load Balancer
- Multiple Availability Zones
- Autoscaling
- Health probes

### Architecture

Users
    |
    v
Azure Load Balancer
    |
    +---- Zone 1 ---- VMSS instances
    |
    +---- Zone 2 ---- VMSS instances
    |
    +---- Zone 3 ---- VMSS instances

### Responsibilities

Load Balancer:
- Provides the frontend endpoint
- Distributes traffic
- Uses health-probe results to avoid unhealthy backends

VMSS:
- Manages the VM instance fleet
- Scales out/in according to configured policies

Availability Zones:
- Provide physical infrastructure isolation within the region

### Key Lesson

Load Balancer distributes traffic.
VMSS provides/manages capacity.
Availability Zones provide failure isolation.

---

## Q22 - Azure RBAC vs Windows Guest OS Permissions

### Scenario

A developer has Contributor access to an Azure VM and assumes this allows Windows administrative login.

### Answer

The reasoning is incorrect.

Contributor is an Azure resource-management permission. It does not automatically grant administrative access inside the Windows guest OS.

For Windows guest login, the relevant Azure RBAC role is:

- Virtual Machine Administrator Login

For non-administrator guest login:

- Virtual Machine User Login

### RDP

Normal Windows remote administration uses:

- RDP
- TCP 3389

### Troubleshooting Flow

Check:

1. Correct VM/IP address
2. Network connectivity
3. NSG rules
4. TCP 3389
5. Routing
6. RDP enabled/configured
7. Windows Firewall/RDP service
8. Guest OS login authorization

### Key Lesson

Azure RBAC controls Azure resource management.
Guest OS permissions control access inside the VM.
Network controls determine whether the VM can be reached.

---

## Q23 - VM Health vs Application Health

### Scenario

A VMSS web application experiences failures when the application process crashes while the VM itself remains Running.

### Answer

Do not treat VM Running status as proof that the application is healthy.

### Troubleshooting Model

VM Running
    |
    v
Application process
    |
    v
Application health endpoint
    |
    v
Load Balancer health probe
    |
    v
Traffic routing
    |
    v
VMSS health/repair behavior

### Key Lesson

Load Balancer health probes determine backend health according to the configured check. They do not prove every aspect of application health.

VMSS manages instances and scaling; repair behavior depends on configuration.

---

## Q24 - Capacity Problem vs Traffic Distribution Problem

### Scenario

A VMSS application has high CPU utilization while Load Balancer probes remain healthy.

### Capacity Pattern

Most instances have high CPU:

    VM1 85%
    VM2 87%
    VM3 84%
    VM4 89%

This points toward insufficient capacity and should lead to investigation of VMSS autoscaling.

### Distribution Pattern

Only a few instances are heavily loaded while most remain low:

    VM1 95%
    VM2 92%
    VM3 30%
    VM4 25%

This should lead to investigation of traffic distribution, connection behavior, session persistence, application behavior, and Load Balancer configuration.

### Key Lesson

Healthy health probes do not mean an instance has unlimited capacity.

---

## Q25 - Availability Zone Failure

### Scenario

A VMSS application is distributed across three Availability Zones and one entire zone fails.

### Expected Flow

Availability Zone failure
    |
    v
Instances in failed zone become unavailable
    |
    v
Health probes detect unhealthy backends
    |
    v
Load Balancer stops sending traffic to unhealthy instances
    |
    v
Healthy instances in surviving zones continue serving traffic
    |
    v
VMSS manages instance capacity according to its configuration

### Important Distinction

Do not assume a zone failure automatically means the affected VMs are immediately repaired and redeployed into another zone.

The primary availability mechanism is the capacity already distributed across surviving zones.

### Key Lesson

Availability Zones protect against zone-level infrastructure failure by distributing application capacity across physically isolated zones.

---

## Q26 - Layer-by-Layer Troubleshooting

### Scenario

All VMs are Running, CPU and memory are normal, health probes are healthy, but users report intermittent failures.

### Troubleshooting Sequence

1. Check Load Balancer behavior and whether failures correlate with specific backends.
2. Check network path: NSGs, routes, IP addresses, ports, and connectivity.
3. Check VM/NIC configuration.
4. Check application dependencies such as database, APIs, and DNS.
5. Correlate logs and metrics with the failure timestamp.
6. Check whether the failure affects particular requests, users, sessions, or instances.

### Key Lesson

Do not jump directly to one component.

Use evidence to eliminate layers:

Load Balancer
    ->
Network
    ->
VM/NIC
    ->
Application
    ->
Dependencies

---

## Q27 - Temporary Disk vs Production Database

### Scenario

A developer proposes moving production database files to the VM temporary disk because it is faster.

### Answer

Do not approve the design.

Production database data requires persistent storage.

Use an appropriate persistent Azure managed data disk and select the performance tier based on workload requirements.

### Disk Model

OS Disk
    ->
Persistent operating system storage

Data Disk
    ->
Persistent application/database data

Temporary Disk
    ->
Temporary/cache/scratch data

### Key Lesson

Production database storage decisions require consideration of:

- Persistence
- Performance
- Durability
- IOPS
- Throughput
- Latency

Do not use temporary disk as durable production database storage.

---

## Q28 - VM Performance Troubleshooting

### Scenario

A production VM application is slow while CPU and memory utilization are normal.

### Investigation

Check:

- Disk I/O
- Disk latency
- Disk IOPS
- Disk throughput
- Network latency
- Network throughput
- Application processing
- Database performance
- External APIs
- DNS
- Other dependencies

### Important Distinction

Disk capacity percentage does not tell you whether disk performance is sufficient.

CPU utilization of 22% does not prove the application is healthy.

### Key Lesson

Use metrics and logs to identify the actual bottleneck instead of assuming CPU is responsible.

---

## Q29 - VMSS Scaling vs Load Balancer Distribution

### Scenario

Traffic increases dramatically and average CPU exceeds the configured scale-out threshold.

### Flow

User traffic increases
    |
    v
Load Balancer receives requests
    |
    v
Traffic is distributed among healthy instances
    |
    v
Average CPU exceeds scale-out threshold
    |
    v
VMSS autoscaling triggers
    |
    v
New VM instances are created
    |
    v
Instances become ready
    |
    v
Health probes pass
    |
    v
Load Balancer can distribute traffic to the new healthy instances

### Key Lesson

Load Balancer distributes traffic.

VMSS provides additional capacity.

The Load Balancer cannot create VM instances to solve a capacity shortage.

---

## Q30 - Production Incident Troubleshooting

### Scenario

A production Windows VMSS application experiences intermittent failures immediately after a configuration change.

### Troubleshooting Strategy

Start with the configuration change because the failure began immediately afterward.

Then investigate layer by layer:

1. Identify exactly what changed.
2. Correlate the change timestamp with the first failures.
3. Check Load Balancer behavior and health probes.
4. Check networking: NSG, ports, IPs, routes, and connectivity.
5. Check VM/NIC state.
6. Check application logs and metrics at the failure time.
7. Check dependencies such as database, APIs, and DNS.
8. Determine whether failures correlate with a particular instance, request, user, or dependency.

### Recovery

If the configuration change is confirmed as the cause:

1. Roll back to the last known-good configuration when appropriate.
2. Verify service recovery.
3. Identify why the change caused the failure.
4. Correct the configuration.
5. Document the incident and change.

### Key Lesson

Production troubleshooting should be evidence-driven and layer-by-layer.

Configuration changes should be investigated first when there is a strong temporal correlation with the incident.

---

# Compute Q21-Q30 Results

| Question | Score | Primary Lesson |
|---|---:|---|
| Q21 | 9/10 | VMSS + Load Balancer + Zones architecture |
| Q22 | 8/10 | Azure RBAC vs guest OS + RDP |
| Q23 | 6.5/10 | VM health vs application health |
| Q24 | 7.5/10 | Capacity vs traffic distribution |
| Q25 | 7/10 | Zone failure and surviving capacity |
| Q26 | 7/10 | Layer-by-layer troubleshooting |
| Q27 | 8/10 | Temporary vs persistent storage |
| Q28 | 8/10 | Performance troubleshooting |
| Q29 | 9/10 | VMSS scaling vs Load Balancer |
| Q30 | 9/10 | Production incident troubleshooting |

### Q21-Q30 Score

80%

### Compute Q1-Q30 Overall

Q1-Q10: 77.5%

Q11-Q20: 72%

Q21-Q30: 80%

Overall:

76.5%

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
