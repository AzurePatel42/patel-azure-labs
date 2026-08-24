
# Lab 02 - Azure Blob Storage

## Objective

Create and manage an Azure Blob Storage container using the Storage Account created in Lab 01, then validate Blob data operations using Microsoft Entra ID authentication and Azure RBAC.

This lab demonstrates container creation, Blob upload, Blob properties, metadata, access tiers, download validation, and read-only SAS access.

---

## Learning Objectives

After completing this lab, you should be able to:

- Create a Blob container
- Configure a private container
- Understand Azure Storage data-plane RBAC
- Assign `Storage Blob Data Contributor`
- Upload a Blob using Microsoft Entra ID authentication
- List and inspect Blobs
- View Blob properties
- Add and inspect custom Blob metadata
- Understand Blob access tiers
- Set and verify the Hot access tier
- Download a Blob using Azure CLI
- Validate downloaded content
- Generate a short-lived read-only user-delegation SAS
- Navigate Blob Storage using the Azure Portal

---

## Azure Services Used

- Azure Storage Account
- Azure Blob Storage
- Blob Container
- Microsoft Entra ID
- Azure RBAC

---

## Lab Resources

| Resource | Value |
|---|---|
| Resource Group | `rg-az104-storage-01` |
| Storage Account | `staz104az01` |
| Location | `eastus` |
| Container | `documents` |
| Blob | `sample.txt` |
| Container Access | Private |
| Blob Access Tier | Hot |
| Authentication | Microsoft Entra ID |
| Data Role | Storage Blob Data Contributor |

---

## Architecture

```text
Microsoft Entra ID
       |
       | Storage Blob Data Contributor
       v
Azure Storage Account
       |
       +-- documents (Private)
              |
              +-- sample.txt
                    |
                    +-- Properties
                    +-- Metadata
                    +-- Hot Access Tier
                    +-- Read-only SAS


Authentication and Authorization

The initial Blob upload failed because the signed-in Azure identity had subscription/resource management permissions but did not yet have an appropriate Blob data-plane role.

The following role was assigned at the Storage Account scope:

Storage Blob Data Contributor

After RBAC propagation, the upload succeeded using:

--auth-mode login

No Storage Account key was required.

This demonstrates the distinction between:

Azure resource management permissions
Azure Storage data-plane permissions
Blob Configuration

The documents container was created with public access disabled.

The following Blob was uploaded:

sample.txt

The Blob was validated with:

Size: 93 bytes
Server encrypted: True
Access tier: Hot
Custom metadata

Metadata applied:

purpose = az104-lab
source  = patel-azure-labs
module  = blob-storage
SAS Validation

A short-lived, read-only user-delegation SAS was generated for:

documents/sample.txt

The SAS was configured with:

Read permission
Limited expiration
Microsoft Entra authentication
User delegation

The SAS token itself was not stored in the repository or included in the documentation.

Download Validation

The Blob was downloaded to:

downloaded-sample.txt

Both files were verified as:

sample.txt                93 bytes
downloaded-sample.txt     93 bytes

Compare-Object returned no differences, confirming that the downloaded content matched the original file.

Validation Checklist
Storage Account available
Private Blob container created
Microsoft Entra identity identified
Storage Blob Data Contributor assigned
Blob upload successful
Blob listed successfully
Blob properties inspected
Blob metadata created and verified
Hot access tier verified
Blob downloaded successfully
Downloaded content matched original
Read-only SAS generated
Six screenshots captured
Screenshots
Screenshot	Description
01-blob-container-created.png	Private Blob container created
02-blob-uploaded.png	sample.txt uploaded
03-blob-properties-metadata.png	Blob properties and metadata
04-blob-access-tier-hot.png	Hot access tier
05-blob-download-validation.png	Blob download validation
06-blob-sas-read-access.png	Read-only SAS configuration
PPST Integration

Azure Blob Storage can provide the document storage layer for the Patel Platform Service Template (PPST).

Potential workflow:

User Upload
     |
     v
Azure Blob Storage
     |
     v
Azure Queue Storage
     |
     v
PPST Worker
     |
     v
Document Extraction
     |
     v
Chunking
     |
     v
OpenAI Embeddings
     |
     v
PostgreSQL / pgvector

Blob Storage can therefore serve as the durable document-ingestion boundary for the PPST Data Ingestion Pipeline.

Outcome

Successfully created and validated a private Azure Blob container and performed authenticated Blob data operations using Microsoft Entra ID and Azure RBAC.

The lab was intentionally built, inspected, validated, documented, and evidenced for repeatability through Azure CLI and Azure Portal.
