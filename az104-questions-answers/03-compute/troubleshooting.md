# AZ-104 Compute Troubleshooting

## Troubleshooting Pattern 1 - RDP vs SSH

### Symptom

An administrator needs to connect remotely to a Windows Server VM.

### Common Mistake

Using SSH on TCP port 22.

### Correct Direction

Windows Server:

RDP
TCP 3389

Linux/Unix:

SSH
TCP 22

### Investigation

First identify the guest operating system.

Windows
    |
    +-- RDP / TCP 3389

Linux
    |
    +-- SSH / TCP 22

### Key Lesson

Choose the remote administration protocol based on the guest operating system.

---

## Troubleshooting Pattern 2 - Azure RBAC vs Guest OS Permissions

### Symptom

An administrator has Azure permissions but cannot perform an operation inside the Windows guest OS.

### Diagnosis

Azure resource permissions and guest OS permissions are separate layers.

Azure RBAC
    |
    +-- Azure resource management

Guest OS permissions
    |
    +-- Windows login
    +-- Administrator privileges

### Key Lesson

Do not assume an Azure RBAC role automatically makes the user a Windows administrator inside the VM.

---

## Troubleshooting Pattern 3 - Storage Redundancy vs VM Availability

### Symptom

An engineer recommends ZRS to protect a VM from infrastructure failure.

### Diagnosis

ZRS is a Storage redundancy capability.

It does not distribute the VM itself across availability zones.

### Correct Direction

Storage:

ZRS
    |
    +-- Storage redundancy

Compute:

Availability Zones
    |
    +-- VM distribution across zones

### Key Lesson

Separate Storage availability from Compute availability.

---

## Troubleshooting Pattern 4 - Availability vs Scaling

### Symptom

An engineer says Availability Sets or Availability Zones are used to handle traffic surges.

### Diagnosis

Traffic surge is a capacity/scaling problem.

Infrastructure failure is an availability problem.

### Correct Direction

Traffic increases
    |
    v
Autoscaling
    |
    v
Scale Out

Infrastructure failure
    |
    v
Availability architecture
    |
    v
Healthy instance continues serving traffic

### Key Lesson

Scaling and availability solve different problems.

---

## Troubleshooting Pattern 5 - VMSS vs Load Balancer Responsibilities

### Symptom

An engineer expects VMSS to distribute incoming application traffic.

### Diagnosis

VMSS manages VM instances and scaling.

Load Balancer distributes network traffic.

### Correct Direction

VMSS
    |
    +-- Instance management
    +-- Scale out
    +-- Scale in

Load Balancer
    |
    +-- Traffic distribution
    +-- Health probes

### Key Lesson

Do not combine instance management with traffic distribution.

---

## Troubleshooting Pattern 6 - VM Running but Application Unhealthy

### Symptom

A VM is powered on, but users cannot reach the application.

### Diagnosis

VM power state does not prove application health.

Example:

VM = RUNNING
Application = DOWN

### Correct Direction

Use a Load Balancer health probe or appropriate application health monitoring.

Health probe
    |
    v
Application endpoint
    |
    +-- Healthy
    |
    +-- Unhealthy

If unhealthy:

Load Balancer
    |
    v
Stop sending new traffic

### Key Lesson

Infrastructure health and application health are different signals.

---

## Troubleshooting Pattern 7 - Temporary Disk Used for Database

### Symptom

A developer stores database files on the VM temporary disk because it has good performance.

### Diagnosis

Temporary disk is not intended for durable database data.

### Correct Direction

Use persistent Azure managed data disks.

Temporary Disk
    |
    +-- Cache
    +-- Temporary files
    +-- Non-persistent data

Managed Data Disk
    |
    +-- Database files
    +-- Persistent application data

### Key Lesson

Database storage must consider:

Performance
+
Persistence
+
Durability

---

## Troubleshooting Pattern 8 - Key Vault vs Application Configuration

### Symptom

An application stores database credentials and API secrets directly in configuration files.

### Risk

Secrets can be exposed through:

- Source code
- Configuration
- Source control
- VM configuration

### Correct Direction

Use:

Application
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

Use Key Vault for secret storage and Managed Identity for application identity when supported.

---

## Troubleshooting Pattern 9 - CPU Is Low but Application Is Slow

### Symptom

Application is slow.

CPU utilization is only 20%.

### Incorrect Reasoning

Assuming low CPU means the VM is healthy.

### Correct Direction

Investigate:

- Memory
- Disk I/O
- Disk latency
- Network throughput
- Network latency
- Dependent services

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
Slow response

### Key Lesson

Low CPU does not eliminate other bottlenecks.

---

## Troubleshooting Pattern 10 - VMSS Availability Architecture

### Symptom

A production application requires:

- High availability
- Automatic scaling
- Load balancing
- Multiple VM instances
- Protection from a VM or infrastructure failure

### Correct Direction

Consider:

VM Scale Sets
+
Load Balancer
+
Health Probes
+
Autoscaling
+
Availability Zones

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

### Key Lesson

A production architecture should assign each requirement to the Azure capability that solves it.

---

# Compute Troubleshooting Decision Framework

When a Compute problem occurs:

Symptom
    |
    v
What failed?
    |
    +-- Remote access
    |      |
    |      +-- Check OS
    |      +-- RDP or SSH
    |      +-- Network path
    |
    +-- Application traffic
    |      |
    |      +-- Load Balancer
    |      +-- Health Probe
    |
    +-- VM capacity
    |      |
    |      +-- CPU
    |      +-- Memory
    |      +-- Disk
    |      +-- Network
    |
    +-- VM availability
    |      |
    |      +-- Availability Set
    |      +-- Availability Zones
    |
    +-- Scaling
    |      |
    |      +-- VMSS
    |      +-- Autoscaling
    |
    +-- Storage
    |      |
    |      +-- OS Disk
    |      +-- Data Disk
    |      +-- Temporary Disk
    |
    +-- Secrets
           |
           +-- Key Vault
           +-- Managed Identity

---

# Compute Foundation Troubleshooting Rules

1. Identify the guest operating system before selecting RDP or SSH.
2. Separate Azure resource permissions from guest OS permissions.
3. Separate Storage redundancy from Compute availability.
4. Separate scaling from availability.
5. Separate VMSS responsibilities from Load Balancer responsibilities.
6. Do not assume a running VM means the application is healthy.
7. Never use temporary storage for durable database data.
8. Use Key Vault for sensitive secrets instead of embedding them in application configuration.
9. Do not assume CPU is the only performance bottleneck.
10. Use evidence and metrics before changing infrastructure.

The objective is to identify the failing layer instead of randomly changing Azure settings.

---

# Q11-Q20 Troubleshooting Patterns

## Troubleshooting Pattern 11 - Wrong Solution for CPU/RAM Shortage

### Symptom

A VM needs more CPU and memory.

### Common Mistake

Adding a managed data disk.

### Diagnosis

Disks provide storage, not VM CPU or RAM.

### Correct Direction

Resize the VM to an appropriate SKU.

### Rule

CPU/RAM problem
    |
    v
VM Size

Storage problem
    |
    v
Managed Disk

---

## Troubleshooting Pattern 12 - Disk Expanded but OS Still Shows Old Capacity

### Symptom

Azure reports a larger managed disk, but the guest OS does not show the expected usable capacity.

### Diagnosis

The Azure disk capacity was increased, but the guest partition/filesystem may still need to be extended.

### Rule

Azure disk expansion
    |
    v
Check guest OS
    |
    v
Extend partition/filesystem if required

---

## Troubleshooting Pattern 13 - Using Temporary Disk for Persistent Data

### Symptom

Database or business data is stored on the temporary disk.

### Diagnosis

Temporary storage is not intended for durable data.

### Correct Direction

Use persistent managed data disks.

---

## Troubleshooting Pattern 14 - Using RDP When Run Command Is Appropriate

### Symptom

An administrator only needs to execute a command inside a VM but proposes opening inbound RDP.

### Diagnosis

Interactive remote administration is unnecessary for a simple command execution task.

### Correct Direction

Consider Azure Run Command.

### Rule

Command execution requirement
    |
    v
Run Command

Interactive Windows administration
    |
    v
RDP

Interactive Linux administration
    |
    v
SSH

---

## Troubleshooting Pattern 15 - Confusing Managed Disk and Snapshot

### Symptom

An engineer refers to a snapshot as the VM's active storage.

### Diagnosis

A snapshot is a point-in-time copy of disk state.

### Correct Direction

Managed Disk
    |
    +-- Active persistent storage

Snapshot
    |
    +-- Point-in-time copy

---

## Troubleshooting Pattern 16 - Wrong Recovery Mechanism

### Symptom

An engineer chooses an Availability Set for a regional disaster.

### Diagnosis

Availability Sets address VM distribution across fault and update domains within a region.

### Correct Direction

For regional disaster recovery, use an appropriate disaster-recovery architecture such as Azure Site Recovery.

### Rule

Infrastructure failure domain
    |
    +-- Availability Set / Zone

Regional disaster
    |
    +-- Disaster Recovery

---

# Q11-Q20 Troubleshooting Checklist

When troubleshooting an Azure VM:

### 1. Compute

Check:

- VM size
- vCPU
- RAM
- CPU utilization
- Memory pressure

### 2. Storage

Check:

- OS disk
- Data disks
- Disk capacity
- Disk I/O
- Disk latency
- Temporary disk usage

### 3. Guest OS

Check:

- Partition size
- Filesystem capacity
- Services
- Application processes

### 4. Remote Administration

Ask:

- Windows or Linux?
- Interactive session required?
- Simple command execution?

Then select:

- RDP
- SSH
- Run Command

### 5. Availability

Identify the failure domain:

- VM/hardware
- Maintenance
- Zone
- Region

### 6. Recovery

Select the mechanism appropriate to the failure scope.

---

# Q11-Q20 Debugging Lessons

The major debugging lesson from this question block is:

Do not solve an Azure problem by looking only at the resource named in the question.

Instead:

Requirement
    |
    v
Failure / constraint
    |
    v
Identify layer
    |
    +-- Compute
    +-- Storage
    +-- Guest OS
    +-- Network
    +-- Availability
    +-- Disaster Recovery
    |
    v
Choose the Azure capability that solves that specific problem.

This is the preferred Compute troubleshooting mindset going forward.

---

# Compute Q21-Q30 Production Troubleshooting

## Troubleshooting Model

Production incidents should be investigated from the outside inward and from evidence to hypothesis.

Configuration
    ->
Load Balancer
    ->
Health Probe
    ->
Network
    ->
VM/NIC
    ->
Application
    ->
Dependencies
    ->
Recovery

---

## Q21 - Multi-Zone Production Failure

### Symptom

A production VMSS deployment loses capacity in one Availability Zone.

### Investigation

Check:

1. Which instances remain healthy?
2. Which zones are affected?
3. Load Balancer health-probe status.
4. VMSS instance state.
5. Application availability in surviving zones.

### Key Principle

Availability Zones provide infrastructure failure isolation.

Do not confuse zone distribution with autoscaling.

---

## Q22 - Contributor but Cannot Administer Windows

### Symptom

A user can manage the Azure VM resource but cannot log into Windows with administrative privileges.

### Investigation

Separate:

Azure Resource Management
    ->
Azure RBAC

from:

Guest OS Access
    ->
Windows login authorization

### Correct Direction

Check whether the user has the appropriate:

Virtual Machine Administrator Login

authorization.

For Windows remote access, verify:

RDP
    ->
TCP 3389
    ->
Network access
    ->
Guest OS access

### Key Principle

Contributor does not automatically mean Windows administrator.

---

## Q23 - VM Running but Application Unavailable

### Symptom

Azure reports the VM as Running, but users cannot use the application.

### Investigation

Do not stop at VM state.

Check:

1. Load Balancer backend state.
2. Health probe.
3. Network connectivity.
4. VM/NIC.
5. Application process.
6. Application logs.
7. Application dependencies.

### Key Principle

VM Running
    !=
Application Healthy

---

## Q24 - Most VMSS Instances Have High CPU

### Symptom

Most instances show sustained high CPU.

### Investigation

Check:

1. Current workload.
2. VM size and capacity.
3. Autoscale configuration.
4. Scale-out thresholds.
5. Minimum and maximum instance counts.
6. Whether scaling occurred.
7. Whether new instances became healthy.

### Key Principle

High CPU across most instances strongly suggests a capacity problem.

Investigate VMSS autoscaling before assuming uneven traffic distribution.

---

## Q25 - Only a Few Instances Have High CPU

### Symptom

Two instances are heavily loaded while the remaining instances have low utilization.

### Investigation

Check:

1. Load Balancer distribution.
2. Health-probe behavior.
3. Long-lived connections.
4. Session behavior.
5. Application workload.
6. Request distribution.
7. Instance-specific application behavior.

### Key Principle

A few overloaded instances with many lightly loaded instances can indicate distribution or application behavior rather than insufficient total capacity.

---

## Q26 - Users Report Intermittent Failures

### Symptom

Some requests fail while others succeed.

### Investigation

Correlate:

- Timestamp
- User/session
- Request
- Backend instance
- Health-probe state
- Network behavior
- Application logs
- Dependency failures

### Key Principle

Do not immediately assume the Load Balancer or VM is the root cause.

Trace the request through every layer.

---

## Q27 - Database Data Lost After VM Restart

### Symptom

Database files stored on temporary disk are missing after a restart or host event.

### Root Cause

Temporary disk is not appropriate for durable production database data.

### Correct Design

Persistent database storage
    ->
Managed Data Disk
    ->
Appropriate performance tier

### Key Principle

Temporary Disk
    ->
Temporary/cache/scratch data

Managed Data Disk
    ->
Persistent application/database data

---

## Q28 - VM Slow With Normal CPU

### Symptom

CPU and memory look normal, but application response time is high.

### Investigation

Check:

Disk
    ->
IOPS
    ->
Throughput
    ->
Latency

Network
    ->
Latency
    ->
Throughput

Application
    ->
Processing time
    ->
Errors

Dependencies
    ->
Database
    ->
DNS
    ->
External APIs

### Key Principle

CPU is only one possible bottleneck.

Disk capacity and disk performance are different concepts.

---

## Q29 - Traffic Spike and Autoscaling

### Symptom

Application traffic increases significantly.

### Investigation

Verify:

1. Load Balancer receives traffic.
2. Healthy instances receive requests.
3. CPU/workload increases.
4. Autoscale rule evaluates the configured metric.
5. VMSS adds instances.
6. New instances become ready.
7. Health probes pass.
8. Load Balancer includes healthy instances.

### Key Principle

Load Balancer
    ->
Distribution

VMSS
    ->
Capacity

Health Probe
    ->
Backend health according to configured check

---

## Q30 - Incident Immediately After Configuration Change

### Symptom

Production failures begin immediately after a configuration change.

### Investigation Order

1. Identify the exact change.
2. Record the change timestamp.
3. Compare it with the first failure timestamp.
4. Check Load Balancer behavior.
5. Check health probes.
6. Check network configuration.
7. Check VM/NIC state.
8. Check application logs and metrics.
9. Check dependencies.
10. Correlate affected instances, users, requests, and timestamps.

### Recovery

If evidence confirms the configuration caused the incident:

1. Roll back to the last known-good configuration when appropriate.
2. Verify service recovery.
3. Determine the underlying cause.
4. Correct the configuration.
5. Retest.
6. Document the incident and change.

### Key Principle

The closest change before an incident is a high-priority investigation candidate, but correlation must be verified with evidence.

---

# Compute Troubleshooting Decision Rules

### Rule 1 - Capacity

Most instances overloaded
    ->
Investigate VMSS capacity/autoscaling

### Rule 2 - Distribution

Few instances overloaded
    ->
Investigate Load Balancer distribution and application behavior

### Rule 3 - Health

VM Running
    ->
Not proof of application health

### Rule 4 - Probe

Health probe healthy
    ->
Configured health check passes

Not proof that:

- Every application function works
- Every dependency works
- Every user request succeeds

### Rule 5 - Access

Contributor
    ->
Azure resource management

Virtual Machine Administrator Login
    ->
Guest OS administrative login

### Rule 6 - Storage

Persistent production data
    ->
Managed persistent storage

Temporary/cache/scratch data
    ->
Temporary Disk

### Rule 7 - Performance

CPU/memory normal
    ->
Do not stop troubleshooting

Investigate:

- Disk
- Network
- Application
- Dependencies

### Rule 8 - Incident Response

Configuration change
    ->
Timestamp correlation
    ->
Layer-by-layer investigation
    ->
Evidence
    ->
Recovery
    ->
Root cause
    ->
Documentation

---

# Compute Troubleshooting Mindset

Do not ask:

"Which Azure service is broken?"

Ask:

"At which layer does the evidence show the failure?"

This prevents premature conclusions and creates a repeatable production-debugging process.

