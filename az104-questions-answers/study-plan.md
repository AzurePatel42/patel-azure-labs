Daily Session
45-Minute Structure
10 Minutes - Recall

Review:

Previous questions
Previous mistakes
Weak topics
Important Azure terminology

The purpose is to strengthen retrieval from memory.

20 Minutes - Questions & Answers

Work through Azure interview and AZ-104 questions.

Each question should include:

Question
Answer
Why
Why the alternatives are wrong
Real-world context
10 Minutes - Scenario / Troubleshooting

Focus on realistic situations such as:

A deployment failed.
A user cannot access a resource.
A VM cannot communicate.
Storage access is denied.
A metric is missing.
A network route is incorrect.
An identity lacks permission.

The goal is to develop systematic troubleshooting.

5 Minutes - Review

Record:

Score
Mistakes
Weak areas
Questions to repeat
Domain Sequence

The primary domain sequence is:

01 Identity & Governance
02 Storage
03 Compute
04 Networking
05 Monitoring
06 Cross-Domain Scenarios
07 Interview Mode
08 Mock Exams

The final ordering may be adjusted according to performance and weak areas.

Phase 1 - Foundation Review

Focus on the five major domains:

Identity
Storage
Compute
Networking
Monitoring

The first priority is understanding the fundamentals and terminology.

Phase 2 - Scenario Reasoning

Questions become increasingly scenario-based.

Example pattern:

Situation
    |
    v
Requirement
    |
    v
Azure service / feature
    |
    v
Configuration
    |
    v
Validation

The objective is to reason rather than memorize.

Phase 3 - Troubleshooting

Troubleshooting sessions focus on:

Observe
   |
   v
Gather evidence
   |
   v
Form hypothesis
   |
   v
Test
   |
   v
Diagnose
   |
   v
Fix
   |
   v
Validate

This mirrors the engineering workflow used in the hands-on labs.

Phase 4 - Interview Mode

The questions become more conversational.

Examples:

What is Azure RBAC?

When would you use a managed identity?

How would you troubleshoot a VM with no connectivity?

How would you secure Azure Storage?

How would you monitor an Azure workload?

Why would you choose one Azure service over another?

The objective is to explain concepts clearly to a technical interviewer.

Phase 5 - Mock Exams

Mock exams begin after a strong foundation is established.

Each mock exam should record:

Total questions
Correct
Incorrect
Score
Weak topics
Reasoning mistakes
Retest topics
Phase 6 - Weak-Area Reinforcement

Weak areas receive additional repetition.

Example:

Storage RBAC
    |
    v
Question set
    |
    v
Scenario
    |
    v
Troubleshooting
    |
    v
Retest

The purpose is to turn weak areas into strengths.

Learning Rules
Rule 1 - Explain the answer

A correct answer without understanding is not enough.

Rule 2 - Explain the wrong answers

For multiple-choice questions, understand why the alternatives fail.

Rule 3 - Connect theory to hands-on work

When possible, connect the question to a completed Azure lab.

Example:

Storage security question
        |
        v
Storage Security Lab
        |
        v
Real Azure configuration
Rule 4 - Use evidence

When troubleshooting, prefer:

CLI output
Portal evidence
Metrics
Logs
Configuration

over assumptions.

Rule 5 - Record mistakes

Every important mistake should become part of the study system.

Monthly Structure
September

Primary objective:

Foundation
+
Questions
+
Scenario reasoning

Daily sessions are tracked under:

10-daily-sessions/2026-09/
October

Primary objective:

Scenario depth
+
Interview mode
+
Networking / professional growth

LinkedIn and professional networking begin October 1, 2026.

November

Primary objective:

Advanced scenarios
+
Troubleshooting
+
Mock exams
December

Primary objective:

Mock exams
+
Weak-area elimination
+
Interview readiness
---

# Current Progress - September 2, 2026

## Identity & Governance

Questions completed:

20

Question sets:

Q1-Q10
    ->
Completed September 1

Q11-Q20
    ->
Completed September 2

Current focus:

Identity & Governance foundation

Next question set:

Q21-Q30

---

## Current Learning Focus

The Identity & Governance foundation currently emphasizes:

- Microsoft Entra ID
- Azure RBAC
- RBAC scope and inheritance
- Least privilege
- Management plane vs data plane
- Managed identities
- System-assigned vs user-assigned identities
- Key Vault authorization
- Storage Blob data access
- RBAC troubleshooting
- Authentication vs authorization

---

## Study Progression Rule

Do not move to the next major domain simply because a certain number of questions have been completed.

Move forward when the current domain demonstrates:

- Understanding of core concepts
- Scenario reasoning
- Troubleshooting ability
- Ability to explain why alternatives are wrong
- Ability to connect concepts to hands-on Azure work

Weak areas should return in later sessions through:

Question
    |
    v
Scenario
    |
    v
Troubleshooting
    |
    v
Retest

---

## September 2 Session Result

Today's session completed:

10 questions

Questions:

Q11-Q20

Primary learning themes:

Managed Identity
+
Key Vault
+
Storage Data Plane
+
RBAC
+
Troubleshooting

The objective remains understanding and reasoning rather than memorization.

---

# Current Progress - September 5, 2026

## Identity & Governance

Questions completed:

30 / 30

Question sets:

Q1-Q10
    ->
Completed September 1

Q11-Q20
    ->
Completed September 2

Q21-Q30
    ->
Completed September 5

Domain status:

COMPLETE

---

## Q21-Q30 Learning Results

The advanced Identity & Governance set reinforced:

- Subscription-level RBAC design
- Resource management vs access management
- Management plane vs data plane
- Storage Blob Data Reader
- Microsoft Entra VM login
- Virtual Machine User Login
- Virtual Machine Administrator Login
- User-assigned managed identity lifecycle
- Recreated App Service identity attachment
- Key Vault 403 authorization troubleshooting
- RBAC inheritance
- Least-privilege architecture
- Group-based access management

---

## Important Weak Areas Identified

### Q23 - VM Guest OS Login

Correction:

Contributor manages the Azure VM resource but does not grant guest OS login.

Use:

Virtual Machine User Login
or
Virtual Machine Administrator Login

depending on the required OS privilege.

---

### Q29 - User-Assigned Managed Identity Lifecycle

Correction:

A user-assigned managed identity survives deletion of the workload that uses it.

However, recreating the workload does not automatically attach the existing UAMI.

Key interview sentence:

"UAMI survives the workload, but the workload does not automatically come back with the UAMI attached."

---

## Current Next Target

Storage Q1-Q10

The Identity & Governance foundation is complete.

The next major domain is Storage.

---

## Storage Learning Approach

Storage will follow the same progression:

Q1-Q10
    ->
Foundation

Q11-Q20
    ->
Intermediate

Q21-Q30
    ->
Advanced / SME

Then:

Scenario
    ->
Troubleshooting
    ->
Retest

The existing hands-on Storage labs will be connected to the question sets whenever applicable.

---

## September 5 Session Result

Questions completed:

Q21-Q30

Scores:

Q21 - 9/10
Q22 - 9/10
Q23 - 4/10
Q24 - 8/10
Q25 - 8.5/10
Q26 - 8/10
Q27 - 8.5/10
Q28 - 9.5/10
Q29 - 7/10
Q30 - 9/10

Primary learning themes:

Advanced RBAC
+
VM Login
+
Managed Identity Lifecycle
+
Key Vault Authorization
+
Storage Data Plane
+
Least Privilege

Identity & Governance is now complete at the foundation level.
