# AZ-104 Compute Notes

## 1. Azure Virtual Machines

Azure Virtual Machines provide IaaS-level control over the operating system.

Use an Azure VM when the workload requires:

- Full operating system control
- Custom software installation
- OS configuration
- Administrative access
- Persistent storage
- Custom application/runtime configuration

Trade-off:

More control
    +
More operational responsibility

The administrator is responsible for areas such as:

- OS configuration
- Patch management
- Monitoring
- Troubleshooting
- Application configuration

Mental model:

Azure VM
    |
    +-- IaaS
          |
          +-- High control
          +-- High responsibility

---

## 2. VM Scale Sets

Azure Virtual Machine Scale Sets manage multiple VM instances as a group.

Use VMSS when the application requires:

- Multiple VM instances
- Automatic scaling
- Scale out
- Scale in
- Instance management
- Variable workload capacity

Example:

CPU > 70%
    |
    v
Scale Out

CPU < 30%
    |
    v
Scale In

Thresholds and evaluation periods are design choices and should be tuned based on application behavior.

Important:

VMSS manages and scales VM instances.

It does not replace the need for a load-balancing mechanism when incoming application traffic must be distributed.

---

## 3. Scaling vs Availability

Scaling and availability solve different problems.

Scaling:

Traffic increases
    |
    v
Add capacity
    |
    v
Scale Out

Traffic decreases
    |
    v
Remove capacity
    |
    v
Scale In

Availability:

VM or infrastructure failure
    |
    v
Another healthy instance
    |
    v
Application continues serving traffic

Mental model:

Scaling
    =
Capacity

Availability
    =
Survival of failures

---

## 4. Load Balancer

Azure Load Balancer distributes incoming network traffic across healthy backend instances.

Architecture:

Internet
    |
    v
Load Balancer
    |
    +-- VM1
    +-- VM2
    +-- VM3

A Load Balancer can use health probes to determine whether backend instances are healthy.

If an instance fails its health probe:

Health Probe
    |
    v
Instance unhealthy
    |
    v
Load Balancer stops sending new traffic

Important distinction:

Load Balancer
    =
Traffic distribution

VMSS
    =
Instance management and scaling

---

## 5. Health Probes

A health probe checks a configured protocol and port to determine whether a backend service is responding.

Example:

HTTP
TCP
Port 80

Important:

A VM can be powered on while the application inside the VM is unhealthy.

Example:

VM = RUNNING
Application = DOWN

Therefore:

VM status alone
    !=
Application health

Health probes provide application/backend health information for traffic distribution.

---

## 6. Windows VM Remote Administration

Windows Server VMs normally use:

RDP
TCP 3389

Linux/Unix systems normally use:

SSH
TCP 22

Mental model:

Windows
    |
    +-- RDP
    +-- TCP 3389

Linux
    |
    +-- SSH
    +-- TCP 22

Security:

Do not blindly expose remote administration ports to the entire public internet.

Consider:

- Restricted source access
- Private connectivity
- Azure Bastion
- Appropriate network security controls

---

## 7. Azure VM Permissions vs Guest OS Permissions

Separate Azure resource permissions from guest operating system permissions.

Azure resource management:

Azure RBAC
    |
    +-- Manage Azure resources

Guest OS access:

Windows / Linux
    |
    +-- Login permissions
    +-- OS administrator permissions

Important:

An Azure RBAC role does not automatically mean the user is a Windows administrator inside the guest OS.

Mental model:

Azure VM
¦
+-- Azure Resource Management
¦      +-- Azure RBAC
¦
+-- Guest OS
       +-- OS Login / Administrator permissions

---

## 8. Azure Managed Disks

Managed Disks provide managed persistent storage for Azure VMs.

A VM can use:

- OS disk
- Data disks
- Temporary disk

Mental model:

VM
¦
+-- OS Managed Disk
¦     +-- Persistent operating system
¦
+-- Data Managed Disk
¦     +-- Persistent application data
¦
+-- Temporary Disk
      +-- Temporary / non-persistent data

For high I/O workloads, choose an appropriate disk performance tier.

Premium SSD can be appropriate when the workload requires higher I/O performance.

---

## 9. Temporary Disk

The VM temporary disk is intended for temporary or non-persistent data.

Examples:

- Temporary files
- Cache
- Scratch data
- Other data that can be recreated

Do not use the temporary disk for durable:

- Database files
- Critical application data
- Persistent business data

Mental model:

Performance alone
    !=
Durability

Database storage requires consideration of:

Performance
+
Persistence
+
Durability

---

## 10. Availability Sets

Availability Sets provide VM distribution across:

- Fault domains
- Update domains

They reduce the likelihood that a single hardware failure or planned maintenance event affects all instances.

Mental model:

Availability Set
    |
    +-- Fault Domain
    +-- Fault Domain
    |
    +-- Update Domain
    +-- Update Domain

Availability Sets provide infrastructure distribution within a region.

---

## 11. Availability Zones

Availability Zones are physically separate locations within an Azure region.

They provide stronger physical isolation between VM instances.

Example:

Azure Region
    |
    +-- Zone 1
    |     +-- VM1
    |
    +-- Zone 2
    |     +-- VM2
    |
    +-- Zone 3
          +-- VM3

Use Availability Zones when stronger protection against zone-level infrastructure failure is required.

---

## 12. Storage Redundancy vs VM Availability

Do not confuse Storage redundancy with VM availability.

Storage:

ZRS
    |
    +-- Storage data redundancy across availability zones

Compute:

Availability Zones
    |
    +-- VM instances distributed across zones

ZRS protects storage data.

Availability Zones can protect compute workloads from zone-level failure when the application is designed with multiple instances.

---

## 13. Key Vault + Managed Identity

Applications should not normally store sensitive credentials directly inside configuration files.

Examples of secrets:

- Database credentials
- API secrets
- Connection strings

Use Azure Key Vault for secret storage.

Use Managed Identity for application identity.

Architecture:

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

Key Vault
    =
Secret storage

Managed Identity
    =
Application identity

Microsoft Entra ID
    =
Authentication

Authorization
    =
Determines whether the identity can access the secret

Key Vault reduces the risk of secrets being exposed through application source code and configuration.

---

## 14. VM Monitoring

When a VM becomes slow, investigate multiple resource dimensions.

Check:

- CPU utilization
- Memory
- Disk I/O
- Disk latency
- Network throughput
- Network latency

Do not assume CPU is always the bottleneck.

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

Another possibility:

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

Mental model:

Symptom
    |
    v
Evidence
    |
    v
Metric
    |
    v
Hypothesis
    |
    v
Test

---

## 15. VMSS + Load Balancer + Availability Zones

A production web application may use:

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

Responsibilities:

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
    +-- Physical infrastructure isolation

Autoscaling
    |
    +-- Adjust capacity based on workload

---

## 16. Compute Architecture Decision Framework

When given a Compute scenario, ask:

1. Does the workload require full OS control?
2. Does it require a single VM or multiple instances?
3. Does capacity need to change automatically?
4. Does traffic need load balancing?
5. What happens if one VM fails?
6. What failure domain needs protection?
7. Does the workload require persistent storage?
8. What disk performance is required?
9. Does the application require secrets?
10. How will VM and application health be monitored?

This turns Compute questions into an engineering decision process instead of memorization.

---

# Compute Foundation Mental Model

Azure Compute decisions can be separated into layers:

Workload
    |
    v
Compute Model
    |
    +-- VM
    +-- VMSS
    |
    v
Availability
    |
    +-- Availability Set
    +-- Availability Zones
    |
    v
Traffic
    |
    +-- Load Balancer
    +-- Health Probe
    |
    v
Storage
    |
    +-- OS Disk
    +-- Data Disk
    +-- Temporary Disk
    |
    v
Identity
    |
    +-- Managed Identity
    +-- Microsoft Entra ID
    |
    v
Secrets
    |
    +-- Key Vault
    |
    v
Monitoring
    |
    +-- CPU
    +-- Memory
    +-- Disk
    +-- Network

The objective is to select each component based on the requirement it solves.

---

# 17. Compute Weakness Reinforcement — Q11-Q20

## VM Sizing

VM CPU and RAM capacity are determined by the selected VM size/SKU.

Think:

VM Size
    |
    +-- vCPU
    +-- RAM
    +-- Performance characteristics

Adding a data disk does not increase CPU or RAM.

### Engineering Decision

If CPU or RAM capacity is insufficient:

Resize the VM.

Consider:

- Cost
- SKU availability
- Supported VM family
- Downtime/deallocation requirements
- Application requirements

---

## Disk Capacity vs VM Capacity

Separate compute capacity from storage capacity.

Compute:

VM Size
    |
    +-- CPU
    +-- RAM

Storage:

Managed Disks
    |
    +-- OS Disk
    +-- Data Disk
    +-- Temporary Disk

A disk cannot be used to solve a CPU or RAM shortage.

---

## OS Disk vs Data Disk

OS disk:

- Contains the operating system
- Persistent

Data disk:

- Intended for persistent application data
- Can be attached independently of the OS disk

Temporary disk:

- Temporary/non-persistent
- Appropriate for scratch data and cache

Mental model:

CPU/RAM problem
    |
    +-- VM Size

Storage problem
    |
    +-- Managed Disk

Temporary workload
    |
    +-- Temporary Disk

---

## Disk Expansion

When a managed disk is expanded:

Azure disk capacity
    |
    v
Guest OS
    |
    v
Partition/filesystem may need extension

Therefore:

Azure-side capacity increase
    !=
Automatically usable filesystem capacity in every guest OS scenario

---

## Azure Run Command

Run Command provides a way to execute scripts or commands inside the guest operating system without relying on inbound RDP or SSH.

Mental model:

Azure management
    |
    v
Run Command
    |
    v
Guest OS
    |
    v
Command / Script

This is different from remote interactive administration through:

- RDP
- SSH

---

## Managed Disk vs Snapshot

Managed Disk:

- Active persistent block storage
- Used by VMs

Snapshot:

- Point-in-time copy of disk state
- Can be used as a source for creating another managed disk

Mental model:

Managed Disk
    |
    | snapshot
    v
Point-in-time copy

Do not automatically equate a snapshot with a complete backup strategy.

---

## Availability and Recovery Layers

Availability Set:

- Fault domains
- Update domains
- Helps reduce impact from hardware failures and planned maintenance

Availability Zone:

- Physically separate zone within a region
- Stronger infrastructure isolation

Site Recovery:

- Disaster recovery
- Regional failover scenarios

Mental model:

Hardware / maintenance
        |
        v
Availability Set

Zone-level failure
        |
        v
Availability Zone architecture

Regional disaster
        |
        v
Site Recovery

---

## Compute Q11-Q20 Reinforcement Rules

1. CPU/RAM shortages require VM sizing decisions.
2. Storage shortages require disk decisions.
3. A data disk does not provide additional CPU or RAM.
4. Temporary disk is not durable application storage.
5. Azure disk expansion may require guest OS partition/filesystem expansion.
6. Run Command is for executing commands inside the guest OS without inbound RDP/SSH.
7. Managed Disk is active persistent storage.
8. Snapshot is a point-in-time disk copy.
9. Availability Sets and Availability Zones protect against different infrastructure failure patterns.
10. Site Recovery addresses disaster recovery rather than ordinary VM availability.

---

# Compute Learning Baseline — Q1-Q20

Q1-Q10:

77.5%

Q11-Q20:

72%

The Q11-Q20 cycle exposed a recurring pattern:

Architectural reasoning
    |
    +-- Strong

Detailed Compute mechanics
    |
    +-- Needs reinforcement

The next Compute review should target the detailed mechanics before advancing to more complex scenarios.

---

# Compute Q21-Q30 Advanced Mental Model

## 1. Compute Architecture Responsibility Map

User
    |
    v
Load Balancer
    |
    v
Healthy VMSS instances
    |
    v
Application
    |
    v
Dependencies

VMSS:
- Instance management
- Scale out/in
- Capacity management

Load Balancer:
- Frontend endpoint
- Traffic distribution
- Health-probe based backend selection

Health Probe:
- Determines backend health according to configured protocol/port/check

Availability Zones:
- Physical infrastructure isolation

Guest OS:
- Windows/Linux operating system and application runtime

## 2. Health Is Layered

VM Running
    !=
Application Healthy
    !=
Dependency Healthy
    !=
User Request Successful

Troubleshooting must distinguish these layers.

## 3. Capacity vs Distribution

Most instances overloaded:
    ->
Capacity problem
    ->
Investigate VMSS autoscaling

Few instances overloaded:
    ->
Possible distribution/application behavior
    ->
Investigate Load Balancer and request patterns

## 4. Availability vs Scaling

Availability:
    ->
Survive failures

Scaling:
    ->
Handle changing workload

Load Balancing:
    ->
Distribute traffic

VMSS:
    ->
Manage instances and capacity

These are related but different responsibilities.

## 5. Storage

OS Disk:
    ->
Persistent OS storage

Data Disk:
    ->
Persistent application/database data

Temporary Disk:
    ->
Temporary/cache/scratch data

## 6. Production Troubleshooting

Use evidence to eliminate layers:

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

## Compute SME Decision Rules

1. High CPU across most instances -> investigate capacity/autoscaling.
2. High CPU on only a few instances -> investigate distribution/application behavior.
3. VM Running -> does not prove application health.
4. Healthy probe -> means the configured health check passes, not that every dependency is healthy.
5. Contributor -> Azure resource management, not Windows administrator login.
6. Windows remote administration -> RDP/TCP 3389.
7. Production database -> persistent managed storage, not temporary disk.
8. Availability Zones -> zone-level infrastructure isolation.
9. Load Balancer -> traffic distribution, not instance creation.
10. VMSS -> instance management and autoscaling.
11. Configuration change immediately before incident -> high-priority investigation candidate.
12. CPU/memory normal -> investigate disk, network, application, and dependencies.
