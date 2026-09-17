# Compute Weak-Area Retest

## AZ-104 Compute Weak-Area Retest

### Purpose

Retest and reinforce the Compute weaknesses identified during the
AZ-104 Compute Q1-Q30 question sets.

The retest focused on conceptual understanding, scenario reasoning,
and structured troubleshooting.

---

# Retest Areas

## 1. VM Health vs Application Health

### Retest Result

Status: COMPLETE

Understanding demonstrated:

- Distinguished VM infrastructure health from application health.
- Recognized that a running and reachable VM does not guarantee that the
  application inside the VM is healthy.
- Applied separate checks for VM, guest OS, network, application, and
  dependencies.

Result: Reinforced

---

## 2. Capacity vs Traffic Distribution

### Retest Result

Status: COMPLETE

Understanding demonstrated:

- Distinguished insufficient compute capacity from traffic distribution
  problems.
- Identified VM SKU, CPU, memory, instance count, and VM Scale Set capacity
  as capacity considerations.
- Identified backend pools, health probes, Load Balancer, and Application
  Gateway as traffic-distribution considerations.

Result: Reinforced

---

## 3. Layer-by-Layer Troubleshooting

### Retest Result

Status: COMPLETE

Understanding demonstrated:

- Applied structured troubleshooting instead of immediately changing
  resources.
- Identified the failure layer before selecting remediation.
- Used the sequence:

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
Remediation
    |
    v
Verification

Result: Reinforced

---

## 4. Availability Zone Failure Behavior

### Retest Result

Status: COMPLETE

Understanding demonstrated:

- Distinguished single-zone and multi-zone architecture.
- Understood that a zonal VM does not automatically move to another zone.
- Understood that workloads distributed across zones can continue operating
  in unaffected zones.
- Distinguished Availability Zone high availability from broader disaster
  recovery.

Result: Reinforced

---

## 5. Production Incident Troubleshooting

### Retest Result

Status: COMPLETE

Understanding demonstrated:

- Identify the symptom.
- Determine the scope.
- Check Azure/platform health.
- Check VM health.
- Check network.
- Check guest OS.
- Check application.
- Check dependencies.
- Identify root cause.
- Apply controlled remediation.
- Verify recovery.
- Document findings.

Result: Reinforced

---

# Original Compute Question Performance

## Q1-Q30

Questions completed: 30 / 30

Cumulative Compute average: 76.5%

Foundation status: COMPLETE

### Q21-Q30 Session

Questions completed: 10 / 10

Session score: 80%

Session scores:

- Q21: 9/10
- Q22: 8/10
- Q23: 6.5/10
- Q24: 7.5/10
- Q25: 7/10
- Q26: 7/10
- Q27: 8/10
- Q28: 8/10
- Q29: 9/10
- Q30: 8/10

---

# Weak-Area Retest Summary

| Area | Status | Result |
|---|---|---|
| VM Health vs Application Health | COMPLETE | Reinforced |
| Capacity vs Traffic Distribution | COMPLETE | Reinforced |
| Layer-by-Layer Troubleshooting | COMPLETE | Reinforced |
| Availability Zone Failure Behavior | COMPLETE | Reinforced |
| Production Incident Troubleshooting | COMPLETE | Reinforced |

---

# Final Decision

Status: COMPLETE

The Compute weak-area brainstorming and retest have been completed.

The major identified Compute weaknesses were reinforced through
scenario-based reasoning and troubleshooting analysis.

No major Compute weak-area blocker remains before progressing to the
Networking module.

---

# Next Step

1. Update the AZ-104 progress tracker.
2. Review the final Compute documentation.
3. Commit the completed Compute weak-area work.
4. Push the changes to GitHub.
5. Begin AZ-104 Networking.
