# Notes

## Key Concepts Learned

- Azure Blob Storage is designed for unstructured data.
- Blob Containers organize related blobs within a Storage Account.
- Access levels determine how blob data can be accessed.
- SAS tokens provide secure, time-limited access without exposing account keys.
- Blob Storage supports multiple access tiers for optimizing storage costs.

---

## Best Practices

- Use private containers unless public access is required.
- Apply the principle of least privilege when generating SAS tokens.
- Organize blobs using logical naming conventions.
- Monitor storage usage and lifecycle policies.
- Avoid exposing account keys in applications.

---

## Challenges Encountered

- Ensured the Storage Account from Lab 01 was available before creating the container.
- Verified uploaded files and reviewed blob properties.

---

## Lessons Learned

Azure Blob Storage is a foundational service for cloud-native applications. It offers secure, durable, and scalable object storage that integrates with many Azure services.

---

## PPST Integration

Within the PPST platform, Azure Blob Storage can be used to:

- Store uploaded documents for processing.
- Receive files before ingestion into the Data Ingestion Pipeline.
- Trigger Azure Queue Storage messages for asynchronous processing.
- Archive processed files for long-term retention.

Future workflow:

User Upload
↓
Azure Blob Storage
↓
Azure Queue Storage
↓
PPST Worker
↓
Document Chunking
↓
OpenAI Embeddings
↓
PostgreSQL (pgvector)