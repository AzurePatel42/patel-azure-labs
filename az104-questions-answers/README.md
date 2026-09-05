
# AZ-104 Questions & Answers

## Purpose

This repository contains the structured study and interview-preparation system for the AZ-104 Azure Administrator certification.

The hands-on AZ-104 lab roadmap is maintained separately in:

```text
C:\patel-azure-labs


This repository focuses on:

Azure interview questions
AZ-104 exam-style questions
Scenario-based reasoning
Troubleshooting
Architecture decisions
Mock exams
Weak-area tracking
Daily study sessions
Study Start Date

Daily 45-minute Azure interview and AZ-104 question-and-answer sessions begin:

September 1, 2026

The schedule begins after settling in Fayetteville, North Carolina.

Study Philosophy

The objective is not to memorize answers.

The objective is to be able to:

Understand the Azure scenario.
Identify the relevant Azure service or feature.
Explain the correct answer.
Explain why alternative answers are wrong.
Troubleshoot the situation.
Connect the concept to real engineering work.
Domains
01 - Identity & Governance

Topics include:

Microsoft Entra ID
Users and groups
RBAC
Managed identities
App registrations
Service principals
Key Vault
Access control
Governance concepts
02 - Storage

Topics include:

Storage Accounts
Blob Storage
Queue Storage
Azure Files
Table Storage
Managed Disks
Storage security
Storage monitoring

The hands-on Storage roadmap is already complete in the main Azure lab repository.

03 - Compute

Topics include:

Virtual Machines
VM networking
Availability
Scaling
VM management
App Service
Azure Container Instances
04 - Networking

Topics include:

Virtual Networks
Subnets
Network Security Groups
Route tables
IP addressing
VNet architecture
Connectivity
Troubleshooting
05 - Monitoring

Topics include:

Azure Monitor
Metrics
Log Analytics
Diagnostic Settings
Alerts
Action Groups
Monitoring troubleshooting
Cross-Domain Reasoning

AZ-104 scenarios frequently combine multiple Azure services.

The cross-domain section focuses on questions such as:

Identity
   +
Networking
   +
Storage
   +
Compute
   +
Monitoring

The goal is to reason about the entire Azure environment rather than isolated services.

Interview Mode

The interview section focuses on:

Technical questions
Architecture questions
Troubleshooting
Real-world scenarios
Behavioral questions

Answers should be explained in engineering language rather than certification-only language.

Mock Exams

Mock exams will be used later in the study cycle.

Each mock exam should record:

Score
Incorrect answers
Weak topics
Reasoning mistakes
Topics requiring repetition
Weak Areas

The weak-area system tracks:

Topic
Why it was missed
Correct reasoning
Required repetition
Retest result

A wrong answer becomes a learning artifact rather than simply a missed question.

Daily Sessions

Daily sessions are stored under:

10-daily-sessions/

Each session is recorded by date.

Example:

10-daily-sessions/
└── 2026-09/
    ├── 2026-09-01.md
    ├── 2026-09-02.md
    └── ...
45-Minute Daily Structure
10 minutes
Recall + previous mistakes

20 minutes
Azure questions and answers

10 minutes
Scenario / troubleshooting

5 minutes
Score + weak-area tracking

The structure can evolve as performance data shows where additional time is needed.

Relationship to Hands-On Labs

The hands-on repository is:

C:\patel-azure-labs

The Q&A repository is:

C:\patel-azure-labs\az104-questions-answers

The two repositories work together:

Hands-On Lab
     |
     v
Understand Azure
     |
     v
Questions
     |
     v
Scenario
     |
     v
Troubleshooting
     |
     v
Interview Explanation
Long-Term Engineering Goal

The goal is to combine:

AZ-104 Knowledge
        +
Hands-On Azure Labs
        +
Backend Engineering
        +
PPST Architecture
        +
Azure Deployment
        =
Production-Oriented Engineering Portfolio
Completion Criteria

The AZ-104 preparation system will be considered mature when:

Core questions can be answered without memorization.
Scenario questions can be reasoned through.
Troubleshooting questions can be explained step-by-step.
Weak topics are tracked and improving.
Mock exam performance is consistent.
Azure concepts can be explained in interview language.
Hands-on experience can be connected to real projects.
Repository Structure
az104-questions-answers/
├── 01-identity-governance/
├── 02-storage/
├── 03-compute/
├── 04-networking/
├── 05-monitoring/
├── 06-cross-domain-scenarios/
├── 07-interview-mode/
├── 08-mock-exams/
├── 09-weak-areas/
├── 10-daily-sessions/
├── README.md
├── study-plan.md
└── progress-tracker.md
---

## Current Study Status

As of September 2, 2026:

Identity & Governance

Questions completed:
20

Completed question sets:

Q1-Q10
Q11-Q20

Current phase:

Phase 1 - Foundation Review

Current focus:

Identity & Governance

Next target:

Q21-Q30

The study system is intentionally progressing through one focused question set at a time. Previously identified weak concepts will return through scenarios, troubleshooting, and retesting rather than being discarded after the initial question set.

The objective remains:

Understand
    +
Reason
    +
Troubleshoot
    +
Explain
    +
Apply

---

## Current Study Status

As of September 5, 2026:

### Identity & Governance

Questions completed:

30 / 30

Completed question sets:

Q1-Q10
Q11-Q20
Q21-Q30

Domain status:

COMPLETE

Key areas covered:

- Microsoft Entra ID
- Azure RBAC
- RBAC scope and inheritance
- Least privilege
- Management plane vs data plane
- Managed identities
- System-assigned vs user-assigned identities
- Key Vault authorization
- Storage Blob data access
- Microsoft Entra VM login
- Authentication vs authorization
- RBAC troubleshooting

### Current Phase

Phase 1 - Foundation Review

### Next Domain

Storage

### Next Target

Storage Q1-Q10

Previously identified Identity & Governance weak areas will continue to return through scenarios, troubleshooting, and retesting.

The objective remains:

Understand
    +
Reason
    +
Troubleshoot
    +
Explain
    +
Apply
