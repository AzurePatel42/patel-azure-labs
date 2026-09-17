# Compute Weak Topics

## 1. VM Health vs Application Health

### Weak Area
Distinguishing Azure VM infrastructure health from the health of the application running inside the VM.

### Key Understanding
A VM can be running and reachable while the application inside the VM is unhealthy.

### VM Health
Check:
- VM power state
- Boot diagnostics
- Azure platform health
- VM availability
- Network connectivity
- NIC configuration
- NSG configuration

### Application Health
Check:
- Application/service status
- Application process
- Application ports
- Application logs
- Application dependencies
- Application configuration

### Mental Model

Azure Platform
    |
    v
VM
    |
    v
Guest OS
    |
    v
Network
    |
    v
Application
    |
    v
Application Dependencies

### Troubleshooting Question
Is the VM unhealthy, or is the application unhealthy?

---

## 2. Capacity vs Traffic Distribution

### Weak Area
Distinguishing insufficient compute capacity from incorrect traffic distribution.

### Capacity
Capacity asks:

"Do I have enough compute resources?"

Consider:
- VM SKU
- CPU
- Memory
- Number of VM instances
- VM Scale Set capacity

### Traffic Distribution
Traffic distribution asks:

"Is traffic reaching the correct healthy backend instances?"

Consider:
- Azure Load Balancer
- Application Gateway
- Backend pools
- Health probes
- Load-balancing rules

### Mental Model

Capacity Problem
    |
    v
Not enough compute resources

Traffic Distribution Problem
    |
    v
Resources exist, but traffic is not reaching
healthy instances correctly

---

## 3. Layer-by-Layer Troubleshooting

### Weak Area
Avoiding random troubleshooting and identifying the actual failure layer first.

### Troubleshooting Model

Authentication
    |
    v
Authorization
    |
    v
Scope
    |
    v
Network
    |
    v
Resource
    |
    v
Guest OS
    |
    v
Application
    |
    v
Health
    |
    v
Root Cause
    |
    v
Controlled Remediation
    |
    v
Verification

### Key Understanding
Do not immediately change the VM or application.

First identify which layer is failing.

Examples:

- Network failure -> investigate network configuration.
- VM failure -> investigate VM/platform health.
- Application failure -> investigate the application/service.
- Dependency failure -> investigate the dependent resource.

---

## 4. Availability Zone Failure Behavior

### Weak Area
Understanding what happens when an Availability Zone fails and distinguishing high availability from disaster recovery.

### Key Understanding

Availability Zones provide physical separation within an Azure region.

A workload deployed only to one zone has a different failure behavior from a workload distributed across multiple zones.

### Single-Zone Architecture

East US
    |
    +-- Zone 1
          |
          +-- VM

If Zone 1 becomes unavailable, the zonal VM is unavailable.

### Multi-Zone Architecture

East US
    |
    +-- Zone 1 -> VM
    +-- Zone 2 -> VM
    +-- Zone 3 -> VM

If one zone fails, resources in other zones can continue operating.

### Important Distinction

Availability Zones provide high availability within a region.

Disaster recovery generally requires a recovery strategy that addresses
larger-scale failures, including regional failure scenarios.

---

## 5. Production Incident Troubleshooting

### Weak Area
Applying a structured troubleshooting process during a Compute incident.

### Incident Flow

1. Identify the symptom
2. Determine the scope
3. Check Azure platform health
4. Check VM health
5. Check network
6. Check guest OS
7. Check application
8. Check dependencies
9. Identify root cause
10. Apply controlled remediation
11. Verify recovery
12. Document findings

### Scope Questions

- Is one VM affected?
- Are multiple VMs affected?
- Is one availability zone affected?
- Is the entire application affected?
- Is the problem affecting all users?
- Did the problem begin after a configuration change?

### Key Principle

Troubleshoot using evidence.

Do not assume the application is the problem simply because users
cannot access it.

---

## Compute Cross-Domain Reasoning

Authentication
    |
    v
Authorization
    |
    v
Scope
    |
    v
Network
    |
    v
Resource
    |
    v
Guest OS
    |
    v
Application
    |
    v
Health
    |
    v
Root Cause
    |
    v
Controlled Remediation
    |
    v
Verification

## Final Goal

Before starting the AZ-104 Networking module, be able to analyze
Compute scenarios systematically, identify the failing layer, and
select the appropriate Azure troubleshooting or architectural action.
