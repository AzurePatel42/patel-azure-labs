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
