# AZ-104 Storage - Questions Q1-Q10

## Q1 - What is an Azure Storage Account?
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


## Q2 - What is Blob Storage?
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


## Q3 - What is a Blob Container?
### Question
What is the purpose of a container in Azure Blob Storage?

### Answer
A container is a logical grouping and separation boundary for blobs inside a Storage Account.

Example:

Subscription
  +-- Resource Group
       +-- Storage Account
            +-- customer-a
                 +-- invoice1.pdf
                 +-- invoice2.pdf
            +-- customer-b
            +-- customer-c

A container contains blobs, not arbitrary Azure resources.


## Q4 - Which RBAC role allows read-only blob access?
### Question
A developer should be able to read and download blobs from the customer-a container but should not modify or delete them. What Azure RBAC role and scope should be used?

### Answer
Use:

Storage Blob Data Reader

Scope:

customer-a container

This provides data-plane read access to blob contents while following least privilege.


## Q5 - Which storage redundancy protects against an availability-zone failure?
### Question
An application requires high availability and protection against an Azure regional outage. Which storage redundancy option would you choose?

### Answer
Choose GZRS â€” Geo-Zone-Redundant Storage when both zone resilience and regional resilience are required.

GZRS provides:

- Zone redundancy in the primary region
- Geo-replication to a secondary region


## Q6 - How should millions of small files be organized in Blob Storage?
### Question
How would you organize millions of blobs into logical groups such as invoices, images, and reports?

### Answer
Use separate Blob containers such as:

- container-invoices
- container-images
- container-reports

Containers provide logical organization and can also be used as a scope for access control.


## Q7 - Which Blob Storage tier is appropriate for frequently accessed data?
### Question
An application frequently reads millions of blobs and performance/cost economics for frequent access are more important than minimizing storage cost. Which access tier should be used?

### Answer
Use the Hot access tier.

Hot is designed for data that is accessed frequently.

Key idea:

Frequent access ? Hot


## Q8 - How can Blob Storage automatically move data to a lower-cost tier?
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


## Q9 - How would you design a long-term invoice lifecycle policy?
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


## Q10 - Why can a user with Reader access still receive 403 when downloading a blob?
### Question
A developer has the Reader RBAC role on a Storage Account but receives HTTP 403 when trying to download a blob. Why?

### Answer
Reader is a management-plane role. It allows viewing the Azure resource but does not provide access to blob data.

Downloading blob contents is a data-plane operation.

Assign:

Storage Blob Data Reader

at the least-privilege scope required, such as the relevant container.

## Q11

### Question
An application running in Azure needs to access Blob Storage. The developer does not want to store a storage key, password, or other secret in application configuration. What authentication approach should be used?

### Answer
Use a Managed Identity for the Azure application.

The Managed Identity authenticates through Microsoft Entra ID, and Azure RBAC determines what the identity is allowed to do.

Example:

Application
  |
  +-- Managed Identity
          |
          +-- Microsoft Entra ID
                  |
                  +-- Storage Blob Data Reader
                          |
                          +-- Storage Account / Container

Key idea:

Managed Identity = authentication without storing application secrets.


## Q12

### Question
An application frequently accesses blobs during the first 30 days. After that, the data becomes infrequently accessed. How would you automatically reduce storage costs?

### Answer
Use Azure Blob Storage Lifecycle Management.

Example rule:

Hot
  |
  +-- after 30 days
          |
          +-- Cool

Lifecycle Management evaluates blob conditions such as age and automatically changes the access tier.

Key idea:

Lifecycle Management = automated storage lifecycle transitions.


## Q13

### Question
A storage workload must remain available if an entire Azure availability zone fails. Protection against a complete regional outage is not required. Which redundancy option should be selected?

### Answer
Use ZRS - Zone-Redundant Storage.

ZRS stores copies of data across multiple availability zones within the primary Azure region.

Key idea:

ZRS = protection against availability-zone failure.

ZRS does not provide protection against a complete regional outage.


## Q14

### Question
An application needs to upload and read invoices in the customer-a container. It should not need access to other containers. Which Azure RBAC role and scope should be used?

### Answer
Use:

Storage Blob Data Contributor

Scope:

customer-a container

This provides the required data-plane permissions to read and write blob data while keeping access limited to the required container.

Key idea:

Storage Blob Data Contributor = read/write/delete blob data.


## Q15

### Question
Invoices are frequently accessed during the first 30 days, rarely accessed after 30 days, almost never accessed after 180 days, and must be retained for 7 years before deletion.

### Answer
Configure the lifecycle policy:

Hot
  |
  +-- after 30 days
          |
          +-- Cool
                  |
                  +-- after 180 days
                          |
                          +-- Archive
                                  |
                                  +-- after 7 years
                                          |
                                          +-- Delete

This automatically transitions the blobs through lower-cost storage tiers as their access frequency decreases and deletes them after the required retention period.


## Q16

### Question
An Azure VM needs to read blobs from a Storage Account. The application must not store a storage key or SAS token in its configuration. What authentication and authorization approach should be used?

### Answer
Use the VM's Managed Identity for authentication and Azure RBAC for authorization.

Example:

Azure VM
  |
  +-- Managed Identity
          |
          +-- Microsoft Entra ID
                  |
                  +-- Storage Blob Data Reader
                          |
                          +-- Required container

The Managed Identity eliminates the need to store a storage key, SAS token, or other application credential.

Key idea:

Authentication = Managed Identity / Microsoft Entra ID

Authorization = Azure RBAC


## Q17

### Question
A developer has the Storage Blob Data Reader role at the customer-a container scope. They can download invoices successfully but receive HTTP 403 when trying to delete a blob. Why is deletion failing, and what role should be used if deletion is required?

### Answer
Deletion fails because Storage Blob Data Reader provides read-only access to blob data.

If the developer must be able to read, write, and delete blobs, use:

Storage Blob Data Contributor

at the required container scope.

Key idea:

Storage Blob Data Reader
  = read

Storage Blob Data Contributor
  = read + write + delete


## Q18

### Question
An external customer needs temporary access to download one specific blob. The access should expire after 24 hours, and the customer should not receive the Storage Account key. What should be used?

### Answer
Use a SAS token scoped to the specific blob.

Configure the SAS with:

- Read permission only
- Specific blob scope
- 24-hour expiration

A SAS token provides delegated, time-limited access without giving the customer the Storage Account key.

Important distinction:

Microsoft Entra ID + RBAC
  = identity-based authorization

SAS
  = delegated, time-limited access

SAS permissions are not Azure RBAC roles.


## Q19

### Question
A legacy application running on multiple Azure VMs expects a traditional shared file system using a path such as `\\server\share\file.txt`. Which Azure Storage service should be used?

### Answer
Use Azure Files.

Azure Files provides managed file shares that can be accessed using protocols such as SMB.

Key distinction:

Azure Blob Storage
  = object storage

Azure Files
  = managed file shares / shared file-system access


## Q20

### Question
An application successfully authenticates using its Managed Identity but receives `403 AuthorizationPermissionMismatch` when uploading a blob.

The Managed Identity has the Storage Blob Data Reader role at the container scope. Network connectivity and the Storage Account are healthy.

Why is the upload failing, and how should it be fixed?

### Answer
Authentication is working because the application successfully reaches the Storage Account using its Managed Identity.

Authorization is failing because:

Storage Blob Data Reader

provides read-only access and does not allow blob uploads.

Change the required role to:

Storage Blob Data Contributor

at the appropriate container scope.

Mental model:

Authentication
  |
  +-- Managed Identity
          |
          +-- SUCCESS

Authorization
  |
  +-- Storage Blob Data Reader
          |
          +-- Upload denied

Fix:

Storage Blob Data Contributor
  |
  +-- Read
  +-- Write
  +-- Delete

Key troubleshooting rule:

403 AuthorizationPermissionMismatch
  -> Check data-plane permissions and RBAC role/scope.