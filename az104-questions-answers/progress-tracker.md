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
| Storage | 0 | 0 | 0 | Not assessed | PENDING |
| Compute | 0 | 0 | 0 | Not assessed | PENDING |
| Networking | 0 | 0 | 0 | Not assessed | PENDING |
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
| Storage | Not assessed | Not assessed | Interview-ready |
| Compute | Not assessed | Not assessed | Interview-ready |
| Networking | Not assessed | Not assessed | Interview-ready |
| Monitoring | Not assessed | Not assessed | Interview-ready |

---

## Study Milestones

- [x] Start daily 45-minute sessions
- [x] Complete first 20 Identity & Governance questions
- [x] Complete Identity & Governance 30-question foundation
- [ ] Complete Storage question foundation
- [ ] Complete Compute question foundation
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

AZ-104 Identity & Governance

Questions completed:

30

Current next target:

Storage Q1-Q10

Identity & Governance foundation is complete. The next objective is Storage.

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
