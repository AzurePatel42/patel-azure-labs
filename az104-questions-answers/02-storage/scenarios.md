# AZ-104 Storage — Scenarios Q1–Q10

## Scenario 1 — Choosing Blob Storage

Requirement:
Store images and PDFs.

Decision:
Use Blob Storage.

Reason:
Images and PDFs are unstructured/object data.


## Scenario 2 — Organizing Customer Data

Requirement:
Separate blobs for customer-a, customer-b, and customer-c.

Decision:
Use separate containers.

Example:

Storage Account
  +-- customer-a
  +-- customer-b
  +-- customer-c


## Scenario 3 — Read-Only Blob Access

Requirement:
Developer can download blobs but cannot modify or delete them.

Decision:
Storage Blob Data Reader.

Scope:
Specific container when possible.

Reason:
Least privilege + data-plane read access.


## Scenario 4 — Zone Failure

Requirement:
Protect storage from an availability-zone failure.

Decision:
ZRS.

Reason:
Data is replicated across availability zones within the primary region.


## Scenario 5 — Regional Failure

Requirement:
Protect storage from an Azure regional outage.

Decision:
Use geo-redundancy.

When both zone and regional resilience are required:

GZRS.


## Scenario 6 — Frequently Accessed Data

Requirement:
Application frequently reads blobs.

Decision:
Hot tier.

Reason:
The access pattern is frequent.


## Scenario 7 — Changing Access Pattern

Requirement:
Data is frequently accessed initially but becomes less frequently accessed over time.

Decision:
Use Lifecycle Management.

Example:

Hot ? Cool ? Archive


## Scenario 8 — Retention Policy

Requirement:
Invoices must eventually be deleted after 7 years.

Decision:
Use Lifecycle Management with a deletion condition.

Example:

Hot ? Cool ? Archive ? Delete


## Scenario 9 — Management vs Data Plane

Requirement:
Developer can see the Storage Account but cannot download blobs.

Existing role:
Reader.

Problem:
Reader is management-plane access.

Solution:
Assign Storage Blob Data Reader for blob data access.


## Scenario 10 — Least Privilege Design

Requirement:
Developer needs read-only access to one customer container.

Preferred design:

Principal:
Developer

Role:
Storage Blob Data Reader

Scope:
customer-a container

Avoid unnecessarily granting access at the entire Storage Account scope.
