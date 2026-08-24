

## Key Concepts Learned

- Azure Blob Storage provides object storage for unstructured data.
- Blob Containers organize related Blobs.
- Private containers should be the default unless public access is explicitly required.
- Blob data operations require appropriate data-plane permissions.
- Microsoft Entra ID can be used instead of Storage Account keys.
- `Storage Blob Data Contributor` provides Blob data management permissions.
- Blob properties describe the stored object.
- Blob metadata provides application-defined key/value information.
- Blob access tiers can optimize storage costs based on access patterns.
- SAS provides delegated, time-limited access to storage resources.

---

## Actual Lab Configuration

```text
Storage Account:  staz104az01
Resource Group:   rg-az104-storage-01
Container:        documents
Container Access: Private
Blob:             sample.txt
Access Tier:      Hot

RBAC Lesson

The first Blob upload failed because the signed-in identity did not have a suitable Blob data-plane role.

The following role was then assigned at Storage Account scope:

Storage Blob Data Contributor

After RBAC propagation, the same upload command using:

--auth-mode login

succeeded.

This reinforced the difference between Azure resource management authorization and Storage data-plane authorization.

Blob Properties

The uploaded Blob was verified with:

Name:             sample.txt
Size:             93 bytes
Last Modified:    2026-08-24T15:03:58+00:00
Server Encrypted: True
Access Tier:      Hot
Blob Metadata

Custom metadata was added:

purpose = az104-lab
source  = patel-azure-labs
module  = blob-storage

The metadata was subsequently retrieved and verified through Azure CLI.

Download Validation

The Blob was downloaded as:

downloaded-sample.txt

Both the original and downloaded files were:

93 bytes

Compare-Object returned no differences, confirming the downloaded content matched the original.

SAS

A short-lived read-only user-delegation SAS was generated for:

documents/sample.txt

The SAS token was intentionally not stored in the repository.

Security principle:

Least privilege
+
Short expiration
+
Read-only permission
=
Safer delegated Blob access
Challenges Encountered

The first Blob upload returned a permissions error.

The issue was resolved by assigning:

Storage Blob Data Contributor

to the signed-in Microsoft Entra user at the Storage Account scope.

RBAC propagation delayed the first retry, after which the upload succeeded.

Lessons Learned

A user who can manage Azure resources is not automatically authorized to perform every Storage data operation.

For Blob data operations, the identity must have an appropriate Storage data-plane role.

Using Microsoft Entra authentication with Azure RBAC avoids distributing Storage Account keys to applications or administrators when they are not required.

PPST Integration

Azure Blob Storage can serve as the durable document storage boundary for the PPST Data Ingestion Pipeline.

Potential workflow:

User
  |
  v
Blob Storage
  |
  v
Queue Storage
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

This provides a natural separation between document storage, asynchronous processing, extraction, and vector persistence.
