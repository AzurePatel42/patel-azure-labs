# AZ-104 Compute Scenarios

## Scenario 1 - Full OS Control

### Requirement

An application requires:

- Windows operating system
- Full administrative control
- Custom software installation
- OS configuration
- Persistent storage
- No current automatic scaling requirement

### Decision

Use Azure Virtual Machine.

### Reasoning

Azure VM provides IaaS-level control over the guest operating system.

The administrator manages:

- OS configuration
- Software installation
- Patch management
- Monitoring
- Troubleshooting

### Key Lesson

VM provides high control but also creates higher operational responsibility.

---

## Scenario 2 - Variable Workload

### Requirement

An application experiences:

- Low traffic overnight
- High traffic during business hours
- Need for automatic scale-out
- Need for automatic scale-in
- Multiple VM instances

### Decision

Use Virtual Machine Scale Sets.

### Example

CPU > 70%
    |
    v
Scale Out

CPU < 30%
    |
    v
Scale In

Thresholds and evaluation periods should be tuned based on application behavior.

### Key Lesson

VMSS provides managed VM instance scaling and lifecycle management.

---

## Scenario 3 - Windows Remote Administration

### Requirement

A Windows Server VM requires remote administration.

### Decision

Use RDP.

Protocol:

RDP

Port:

TCP 3389

### Security

Avoid exposing RDP broadly to the public internet.

Consider:

- Restricted source access
- Private connectivity
- Azure Bastion
- Network security controls

### Key Lesson

Windows remote administration normally uses RDP.

Linux remote administration normally uses SSH.

---

## Scenario 4 - Persistent Application Storage

### Requirement

A VM runs an application with frequent read/write operations.

Application data must survive VM lifecycle events.

### Decision

Use an Azure managed data disk with an appropriate performance tier.

Premium SSD may be appropriate for workloads requiring higher I/O performance.

### Architecture

VM
    |
    +-- OS Managed Disk
    |
    +-- Data Managed Disk
            |
            +-- Application Data

### Key Lesson

Separate the operating system from persistent application data.

---

## Scenario 5 - Infrastructure Failure

### Requirement

The application must remain available if infrastructure hosting one VM fails.

### Decision

Use multiple VM instances with an appropriate availability architecture.

Consider:

Availability Sets
or
Availability Zones

### Availability Sets

Provide:

- Fault-domain separation
- Update-domain separation

### Availability Zones

Provide:

- Physically separate zones
- Stronger infrastructure isolation

### Key Lesson

Compute availability is different from Storage redundancy.

---

## Scenario 6 - Unhealthy Application Instance

### Requirement

A VM is running but the application process has crashed.

The application is behind a Load Balancer.

### Decision

Use a Load Balancer health probe.

### Flow

Health Probe
    |
    v
Application endpoint
    |
    v
Healthy / Unhealthy

If unhealthy:

Load Balancer
    |
    v
Stops sending new traffic
    |
    v
Other healthy instances continue serving requests

### Key Lesson

VM running does not mean application healthy.

---

## Scenario 7 - Database on Temporary Disk

### Requirement

A database requires:

- Persistent data
- High I/O performance

A developer proposes the VM temporary disk.

### Decision

Reject the design.

Use persistent managed data disks.

### Reasoning

Temporary storage is intended for temporary/non-persistent data.

Database data requires:

Performance
+
Persistence
+
Durability

### Key Lesson

Do not choose storage based only on speed.

---

## Scenario 8 - Application Secrets

### Requirement

An application requires:

- Database credentials
- API secrets
- Connection strings

The developer wants to store them in application configuration.

### Decision

Use Azure Key Vault.

Use Managed Identity for the application.

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

### Key Lesson

Key Vault stores secrets.

Managed Identity provides application identity.

Authentication and authorization remain separate concerns.

---

## Scenario 9 - Slow VM Investigation

### Requirement

A production VM becomes slow.

### Investigation

Check:

- CPU utilization
- Memory
- Disk I/O
- Disk latency
- Network throughput
- Network latency

### Example

CPU = 20%

Do not immediately conclude that the VM is healthy.

Investigate other bottlenecks.

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

### Key Lesson

Use evidence to identify the actual bottleneck.

---

## Scenario 10 - Production Compute Architecture

### Requirement

A production application needs:

- High availability
- Automatic scaling
- Load balancing
- Multiple VM instances
- Protection against a single VM failure

### Decision

Use:

- VM Scale Sets
- Load Balancer
- Health probes
- Autoscaling
- Availability Zones when stronger zone-level isolation is required

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
    +-- Traffic distribution
    +-- Health probes

Availability Zones
    |
    +-- Infrastructure isolation

Autoscaling
    |
    +-- Capacity adjustment

### Key Lesson

Availability and scaling are separate design concerns.

---

# Compute Scenario Decision Framework

When analyzing a Compute scenario:

Requirement
    |
    v
Operating System Control?
    |
    +-- Yes --> VM
    |
    v
Multiple Instances?
    |
    +-- Yes --> VMSS
    |
    v
Variable Workload?
    |
    +-- Yes --> Autoscaling
    |
    v
Traffic Distribution?
    |
    +-- Yes --> Load Balancer
    |
    v
Instance Health?
    |
    +-- Yes --> Health Probe
    |
    v
Infrastructure Failure?
    |
    +-- Yes --> Availability Set / Availability Zones
    |
    v
Persistent Data?
    |
    +-- Yes --> Managed Data Disk
    |
    v
Sensitive Secrets?
    |
    +-- Yes --> Key Vault + Managed Identity
    |
    v
Performance Problem?
    |
    +-- Investigate CPU
    +-- Investigate Memory
    +-- Investigate Disk
    +-- Investigate Network

The objective is to select the Azure capability that solves the specific requirement.

---

# Q11-Q20 Scenario Reinforcement

## Scenario 11 - VM Has Insufficient CPU and RAM

### Requirement

A VM is consistently CPU constrained and does not have enough memory.

### Decision

Resize the VM to a larger appropriate SKU.

### Do Not Do

Do not add a data disk to solve CPU/RAM capacity.

### Lesson

VM SKU determines compute capacity.

---

## Scenario 12 - VM Runs Out of Storage

### Requirement

Application storage is full.

### Decision

Either:

- Expand an existing managed disk
- Attach an additional managed data disk

Then verify guest OS partition/filesystem capacity.

### Lesson

Azure disk capacity and guest OS filesystem capacity are related but separate considerations.

---

## Scenario 13 - Variable Web Workload

### Requirement

Traffic is very high during the day and very low overnight.

### Decision

VMSS + autoscaling.

### Lesson

Scale out/in based on workload rather than permanently provisioning maximum capacity.

---

## Scenario 14 - Physical Host Problem

### Requirement

The application should reduce the impact of physical infrastructure failure and planned maintenance.

### Decision

Use an appropriate availability architecture such as Availability Sets or Availability Zones based on the required failure-domain protection.

### Lesson

First identify the failure domain before selecting the availability mechanism.

---

## Scenario 15 - Avoid Inbound RDP

### Requirement

An administrator needs to execute a PowerShell command inside a Windows VM but does not want to open inbound RDP.

### Decision

Azure Run Command.

### Lesson

Run Command can provide guest OS command execution without requiring normal inbound RDP access.

---

## Scenario 16 - Persistent VM Data

### Requirement

Application data must survive VM lifecycle events.

### Decision

Use managed data disks.

### Lesson

Do not use the VM temporary disk for durable business data.

---

## Scenario 17 - Point-in-Time Disk Copy

### Requirement

An administrator wants a point-in-time copy of a managed disk before making changes.

### Decision

Create a managed disk snapshot.

### Lesson

Snapshot is a point-in-time copy, not the same thing as active managed disk storage.

---

## Scenario 18 - Regional Failure

### Requirement

An application must recover if an Azure region becomes unavailable.

### Decision

Use a disaster-recovery solution such as Azure Site Recovery where appropriate.

### Lesson

Regional disaster recovery is a different problem from VM distribution inside a region.

---

# Compute Failure-Domain Decision Model

Ask:

What failed?

    |
    +-- VM hardware / maintenance
    |       |
    |       +-- Availability Set
    |
    +-- Zone
    |       |
    |       +-- Availability Zones
    |
    +-- Region
            |
            +-- Disaster Recovery / Site Recovery

The first question in an availability scenario should always be:

"What failure domain am I trying to survive?"

---

# Compute Q21-Q30 Advanced Scenarios

## Scenario 19 - Production Multi-Zone Web Architecture

### Requirements

- Unpredictable traffic
- Single frontend
- High availability
- Survive one zone failure
- Automatic scaling
- Healthy-backend routing

### Decision

VMSS + Load Balancer + Availability Zones + autoscaling + health probes.

### Lesson

VMSS provides/manages capacity.
Load Balancer distributes traffic.
Health probes determine backend health according to the configured check.
Availability Zones provide failure isolation.

---

## Scenario 20 - Contributor Cannot RDP

### Situation

A developer has Contributor access to an Azure VM but cannot administer Windows through RDP.

### Decision

Contributor controls Azure resource management. It does not automatically provide Windows guest OS administrator access.

For Windows administrative guest login, use the appropriate guest login authorization such as:

- Virtual Machine Administrator Login

RDP normally uses TCP 3389.

### Lesson

Azure resource permissions and guest OS permissions are separate layers.

---

## Scenario 21 - VM Running but Application Failed

### Situation

The VM remains Running but the application process has crashed.

### Decision

Investigate application health separately from VM state.

### Lesson

VM Running does not equal Application Healthy.

---

## Scenario 22 - High CPU Everywhere

### Situation

Most VMSS instances are heavily utilized.

### Decision

Investigate capacity and VMSS autoscaling.

### Lesson

High CPU across most instances is more consistent with a capacity problem than a traffic-distribution problem.

---

## Scenario 23 - High CPU on Only Some Instances

### Situation

A small number of instances are heavily loaded while most remain lightly loaded.

### Decision

Investigate:

- Load Balancer distribution
- Connection behavior
- Session behavior
- Application characteristics
- Traffic patterns

### Lesson

Uneven utilization can indicate distribution or application behavior rather than insufficient total capacity.

---

## Scenario 24 - Complete Zone Failure

### Situation

One Availability Zone becomes unavailable.

### Decision

Healthy instances in the surviving zones continue serving traffic.

The Load Balancer uses health-probe results and stops sending traffic to unhealthy backends.

### Lesson

The primary availability mechanism is capacity already distributed across surviving zones.

Do not assume an Availability Zone failure automatically means immediate VM repair and redeployment into another zone.

---

## Scenario 25 - Intermittent Failure With Healthy Probes

### Situation

All VMs are Running and Load Balancer health probes are healthy, but users report intermittent failures.

### Decision

Investigate layer by layer:

Load Balancer
    ->
Network
    ->
VM/NIC
    ->
Application
    ->
Dependencies

Correlate failures with:

- Timestamp
- Backend instance
- User/session
- Request
- Dependency

### Lesson

Healthy probes do not prove every application dependency is healthy.

---

## Scenario 26 - Temporary Disk Database

### Situation

A developer wants to put durable database files on temporary disk for performance.

### Decision

Reject the design.

Use persistent managed data storage with a performance tier appropriate for the workload.

### Lesson

Temporary disk is for temporary/cache/scratch data, not durable production database storage.

---

## Scenario 27 - Slow VM With Normal CPU

### Situation

CPU and memory utilization are normal but the application is slow.

### Decision

Investigate:

- Disk I/O
- Disk latency
- Disk IOPS
- Disk throughput
- Network latency
- Network throughput
- Application processing
- Database
- External APIs
- DNS
- Other dependencies

### Lesson

Normal CPU and memory do not eliminate performance bottlenecks.

---

## Scenario 28 - Autoscale Event

### Situation

Traffic increases and CPU exceeds the configured scale-out threshold.

### Flow

Traffic increases
    ->
Load Balancer receives requests
    ->
Traffic is distributed among healthy instances
    ->
CPU exceeds scale-out threshold
    ->
VMSS autoscaling triggers
    ->
New VM instances are created
    ->
Instances become ready
    ->
Health probes pass
    ->
Load Balancer can distribute traffic to the new healthy instances

### Lesson

Load Balancer distributes traffic.
VMSS provides additional capacity.

---

## Scenario 29 - Configuration-Triggered Incident

### Situation

Intermittent production failures begin immediately after a configuration change.

### Decision

1. Identify exactly what changed.
2. Correlate the change timestamp with the first failures.
3. Check Load Balancer and health probes.
4. Check networking.
5. Check VM/NIC state.
6. Check application logs and metrics.
7. Check dependencies.
8. Determine whether failures correlate with a particular instance, request, user, or dependency.

### Recovery

If the configuration change is confirmed as the cause:

1. Roll back to the last known-good configuration when appropriate.
2. Verify service recovery.
3. Identify why the change caused the failure.
4. Correct the configuration.
5. Document the incident and change.

### Lesson

Production troubleshooting should be evidence-driven and layer-by-layer.

---

# Advanced Compute Decision Framework

What is the problem?

    |
    +-- Need more capacity?
    |       |
    |       +-- VMSS / autoscaling
    |
    +-- Need traffic distribution?
    |       |
    |       +-- Load Balancer
    |
    +-- Backend unhealthy?
    |       |
    |       +-- Health probe
    |
    +-- Need failure isolation?
    |       |
    |       +-- Availability Zones
    |
    +-- Need persistent VM data?
    |       |
    |       +-- Managed Data Disk
    |
    +-- Need temporary/scratch data?
    |       |
    |       +-- Temporary Disk
    |
    +-- Need Windows remote access?
    |       |
    |       +-- RDP / TCP 3389
    |
    +-- Need Azure resource management?
    |       |
    |       +-- Azure RBAC
    |
    +-- Need guest OS access?
    |       |
    |       +-- Guest login authorization
    |
    +-- Need regional recovery?
            |
            +-- Disaster Recovery solution
