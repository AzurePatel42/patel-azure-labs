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
## Q21 - Storage Account Security

### Question
A company stores sensitive customer documents in Azure Blob Storage. Applications authenticate using Microsoft Entra ID. Storage Account access keys must not be used. Developers need to manage blobs in one specific container but must not access other containers.

What authentication and authorization approach would you implement, and at what scope?

### Answer
Use Microsoft Entra ID with a security group for the developers and assign the Storage Blob Data Contributor role at the required container scope.

For an Azure application, use Managed Identity with Microsoft Entra ID and assign the minimum required data-plane RBAC role.

Key principle:

Authentication = Microsoft Entra ID / Managed Identity
Authorization = Azure RBAC
Scope = required container only


## Q22 - GZRS for Zone and Regional Protection

### Question
An application requires protection from both an availability-zone failure and a complete Azure region failure. Which storage redundancy option should be used, and why is it better than ZRS alone?

### Answer
Use Geo-Zone-Redundant Storage (GZRS).

GZRS provides zone redundancy in the primary region and geo-replication to a secondary region.

ZRS protects against an availability-zone failure within the primary region but does not provide protection against a complete regional outage.

Mental model:

ZRS = zone resilience
GZRS = zone + regional resilience


## Q23 - Managed Identity Reader Cannot Upload

### Question
An App Service uses a system-assigned managed identity. Authentication succeeds, but uploading a PDF returns 403 AuthorizationPermissionMismatch. The identity has Storage Blob Data Reader at the correct container scope.

Why does the upload fail and what should be changed?

### Answer
Authentication is working, but authorization does not allow the required operation.

Storage Blob Data Reader permits reading blob data but does not permit uploading.

Replace the Reader role with Storage Blob Data Contributor at the required container scope.

Management-plane roleAssignment/write permission is not the permission that allows the application to upload blob data.


## Q24 - Private Endpoint vs NSG

### Question
A Storage Account must not be accessible from the public internet. An application inside a VNet needs private connectivity to the Storage Account while continuing to use Microsoft Entra ID and RBAC.

Which networking feature should be used?

### Answer
Use an Azure Private Endpoint.

A Private Endpoint provides a private IP address for the Storage service inside the VNet.

Network security and identity authorization remain separate:

Private Endpoint = private network connectivity
Microsoft Entra ID / Managed Identity = authentication
Azure RBAC = authorization


## Q25 - Access Key vs Managed Identity

### Question
A production application asks for the Storage Account access key because it is easier than configuring Managed Identity and RBAC. Would you approve the request?

### Answer
No.

For an Azure-hosted application, prefer Managed Identity with Microsoft Entra ID and Azure RBAC.

This avoids storing long-lived access keys and allows permissions to be limited to the required data and scope.

SAS is useful when temporary or delegated access is required, but it is not the default replacement for Managed Identity in this scenario.


## Q26 - Private Endpoint vs Service Endpoint

### Question
An App Service needs private connectivity to a Storage Account. Public network access must be disabled, and the Storage Account should have a private IP reachable from the VNet.

Would you use a Private Endpoint or Service Endpoint?

### Answer
Use a Private Endpoint.

Private Endpoint provides a private IP address in the VNet for access to the Storage service.

Authentication and authorization remain separate and continue to use Managed Identity, Microsoft Entra ID, and Azure RBAC.

Mental model:

Private Endpoint = how traffic reaches the service
RBAC = what the identity can do


## Q27 - GRS vs RA-GRS vs Failover

### Question
A Storage Account uses GRS. The primary region experiences an outage. The application team expects the secondary region to automatically become writable. Is this correct?

### Answer
No.

GRS provides geo-replication to a secondary region, but the secondary is not automatically the active writable endpoint.

RA-GRS provides read access to the secondary endpoint.

A storage account failover operation is required to promote the secondary to the primary.

Mental model:

GRS = geo-replicated secondary
RA-GRS = secondary can also be read
Failover = secondary becomes primary


## Q28 - Private Endpoint 403 Troubleshooting

### Question
An application previously uploaded blobs successfully. After a Private Endpoint was configured and public network access was disabled, uploads begin returning 403 errors. Managed Identity and Storage Blob Data Contributor at container scope are already verified.

What should be investigated next?

### Answer
Investigate the network and DNS path first.

Recommended sequence:

1. Verify Private Endpoint connection status.
2. Verify private DNS configuration.
3. Verify the Storage hostname resolves to the expected private IP.
4. Verify VNet connectivity from the application.
5. Verify Storage networking configuration.
6. Re-check RBAC after network configuration is confirmed.

The recent Private Endpoint change is the strongest troubleshooting clue.


## Q29 - Blob Lifecycle Design

### Question
Invoice data is frequently accessed for 30 days, occasionally accessed from day 31 through day 180, almost never accessed after day 180, must be retained for 7 years, and then automatically deleted.

Design the lifecycle policy.

### Answer
Use Azure Storage Lifecycle Management.

Lifecycle:

Hot
  |
  | after 30 days
  v
Cool
  |
  | after 180 days
  v
Archive
  |
  | after 7 years
  v
Delete

The policy matches the data access pattern and retention requirement.


## Q30 - Complete Storage Security Architecture

### Question
An App Service uses a system-assigned managed identity and VNet Integration to access a Storage Account through a Private Endpoint. Public network access is disabled.

The application must upload and read invoices. Developers need read-only access to the invoices container. No Storage Account access keys may be used.

Design the complete security model.

### Answer
Application authentication:

Microsoft Entra ID through the App Service system-assigned Managed Identity.

Application authorization:

Storage Blob Data Contributor at the invoices container scope.

Developer authorization:

Storage Blob Data Reader at the invoices container scope.

Network security:

Azure Private Endpoint with public network access disabled.

Least privilege:

The application receives only the data-plane permissions required to read and upload blobs, and only within the invoices container. Developers receive read-only access at the same container scope.

Complete model:

App Service
  |
  +-- System-Assigned Managed Identity
  |
  +-- Microsoft Entra ID
  |
  +-- Storage Blob Data Contributor
  |       |
  |       +-- invoices container
  |
  +-- Developers Security Group
          |
          +-- Storage Blob Data Reader
                  |
                  +-- invoices container

Network:

App Service VNet Integration
  |
  +-- Private Endpoint
          |
          +-- Storage Account
