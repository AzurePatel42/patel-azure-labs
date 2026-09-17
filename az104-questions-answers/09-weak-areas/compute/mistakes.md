# Compute Mistakes

## AZ-104 Compute Weak-Area Mistakes

### 1. VM Health vs Application Health

### Mistake Pattern
Treating an application availability problem as automatically being a VM infrastructure problem.

### Correct Reasoning
A VM can be running normally while the application inside the VM is stopped,
misconfigured, listening on the wrong port, or experiencing dependency issues.

### Correction

Check the layers separately:

VM health
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
Dependencies

---

## 2. Capacity vs Traffic Distribution

### Mistake Pattern
Assuming that poor application performance or unavailable requests always
means more VM capacity is required.

### Correct Reasoning
First determine whether the problem is insufficient compute capacity or
whether traffic is being distributed incorrectly.

### Correction

Capacity problem:
- CPU or memory pressure
- Insufficient VM instances
- Incorrect VM SKU
- Insufficient VM Scale Set capacity

Traffic distribution problem:
- Backend pool configuration
- Health probe failure
- Load-balancing rule
- Application Gateway configuration
- Load Balancer configuration

---

## 3. Troubleshooting Without Identifying the Failure Layer

### Mistake Pattern
Jumping directly to a resource change before identifying where the failure
actually occurs.

### Correct Reasoning
Troubleshooting should be evidence-driven and performed layer by layer.

### Correction

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

Only after identifying the failing layer should remediation be selected.

---

## 4. Availability Zone Failure Reasoning

### Mistake Pattern
Assuming that an Azure VM in one Availability Zone will automatically become
available in another zone when its zone fails.

### Correct Reasoning
A zonal VM is associated with its selected Availability Zone.

High availability requires architecture that distributes workloads across
appropriate zones.

### Correction

Single-zone workload:
- One zone failure can make the zonal resource unavailable.

Multi-zone workload:
- Resources in unaffected zones can continue operating.

Availability Zones provide zone-level resilience within a region.
They are not a substitute for a broader disaster recovery strategy.

---

## 5. Production Incident Troubleshooting

### Mistake Pattern
Focusing on the visible symptom instead of determining the scope and root
cause.

### Correct Reasoning
A production incident should begin with:

1. What is the symptom?
2. What is the scope?
3. Which resources are affected?
4. Is Azure reporting a platform issue?
5. Is the VM healthy?
6. Is the network healthy?
7. Is the guest OS healthy?
8. Is the application healthy?
9. Are dependencies healthy?

### Correction

Do not make multiple uncontrolled changes during an incident.

Identify the failure domain first, apply one controlled remediation,
and verify the result.

---

## 6. General Compute Reasoning Mistake

### Mistake Pattern
Selecting an Azure service or action based only on keywords in the question.

### Correct Reasoning
AZ-104 scenario questions require identifying:

- The actual problem
- The affected layer
- The required behavior
- The Azure service responsible for that behavior
- The least disruptive appropriate action

### Exam Strategy

Do not ask:

"What Azure service do I remember?"

Ask:

"What problem is actually occurring?"

Then map the problem to the Azure capability that addresses it.

---

## Final Compute Mistake-Reduction Model

Symptom
    |
    v
Scope
    |
    v
Failure Layer
    |
    v
Evidence
    |
    v
Root Cause
    |
    v
Controlled Remediation
    |
    v
Verification

## Goal

Eliminate keyword-based guessing and use structured Azure Compute reasoning
during scenario questions and production troubleshooting.
