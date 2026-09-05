# AZ-104 Storage — Questions Q1–Q10

## Q1 — What is an Azure Storage Account?

### Question
What is an Azure Storage Account and how does it relate to Azure Storage services?

### Answer
An Azure Storage Account is a top-level Azure resource that provides a namespace, security boundary, and configuration boundary for Azure Storage services.

A Storage Account can provide services such as:

- Blob Storage
- Azure Files
- Queue Storage
- Table Storage

Mental model:

Resource Group
  +-- Storage Account
       +-- Blob Storage
       +-- Azure Files
       +-- Queue Storage
       +-- Table Storage


## Q2 — What is Blob Storage?

### Question
What type of data is Azure Blob Storage designed to store?

### Answer
Azure Blob Storage is object storage designed for large amounts of unstructured data.

Examples:

- Images
- PDFs
- Videos
- Backups
- Logs
- Documents

Each object is stored as a blob.


## Q3 — What is a Blob Container?

### Question
What is the purpose of a container in Azure Blob Storage?

### Answer
A container is a logical grouping and separation boundary for blobs inside a Storage Account.

Example:

Subscription
  +-- Resource Group
       +-- Storage Account
            +-- customer-a
            ¦    +-- invoice1.pdf
            ¦    +-- invoice2.pdf
            +-- customer-b
            +-- customer-c

A container contains blobs, not arbitrary Azure resources.


## Q4 — Which RBAC role allows read-only blob access?

### Question
A developer should be able to read and download blobs from the customer-a container but should not modify or delete them. What Azure RBAC role and scope should be used?

### Answer
Use:

Storage Blob Data Reader

Scope:

customer-a container

This provides data-plane read access to blob contents while following least privilege.


## Q5 — Which storage redundancy option protects against regional failure?

### Question
An application requires high availability and protection against an Azure regional outage. Which storage redundancy option would you choose?

### Answer
Choose GZRS — Geo-Zone-Redundant Storage when both zone resilience and regional resilience are required.

GZRS provides:

- Zone redundancy in the primary region
- Geo-replication to a secondary region


## Q6 — How do containers organize blobs?

### Question
How would you organize millions of blobs into logical groups such as invoices, images, and reports?

### Answer
Use separate Blob containers such as:

- container-invoices
- container-images
- container-reports

Containers provide logical organization and can also be used as a scope for access control.


## Q7 — Which Blob access tier is appropriate for frequently accessed data?

### Question
An application frequently reads millions of blobs and performance/cost economics for frequent access are more important than minimizing storage cost. Which access tier should be used?

### Answer
Use the Hot access tier.

Hot is designed for data that is accessed frequently.

Key idea:

Frequent access ? Hot


## Q8 — How can Blob access tiers be changed automatically?

### Question
Documents are accessed frequently for the first 30 days and rarely accessed afterward. How can Azure automatically move them to a lower-cost tier?

### Answer
Use Azure Blob Storage Lifecycle Management.

Example rule:

Blob starts in Hot
  ?
After 30 days
  ?
Move to Cool

Lifecycle Management automates tier transitions based on conditions such as blob age.


## Q9 — How would you design a multi-stage lifecycle policy?

### Question
Invoices are frequently accessed for the first 30 days, rarely accessed after 30 days, almost never accessed after 180 days, and must be deleted after 7 years.

### Answer
Configure the lifecycle policy:

Hot
  ? after 30 days
Cool
  ? after 180 days
Archive
  ? after 7 years
Delete

This automatically changes the storage tier as the access pattern changes and enforces the retention policy.


## Q10 — Why does Reader not allow downloading blobs?

### Question
A developer has the Reader RBAC role on a Storage Account but receives HTTP 403 when trying to download a blob. Why?

### Answer
Reader is a management-plane role. It allows viewing the Azure resource but does not provide access to blob data.

Downloading blob contents is a data-plane operation.

Assign:

Storage Blob Data Reader

at the least-privilege scope required, such as the relevant container.
