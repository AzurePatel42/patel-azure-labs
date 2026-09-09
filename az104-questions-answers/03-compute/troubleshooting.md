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
