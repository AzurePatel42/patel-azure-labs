# Notes

## Key Concepts Learned

- Every Azure Storage Account must have a globally unique name.
- A Storage Account can host multiple storage services including Blob, Queue, File, and Table Storage.
- Resource Groups help organize Azure resources.
- Standard performance is suitable for most workloads.
- Locally Redundant Storage (LRS) stores multiple copies of data within a single Azure region.
- StorageV2 is the recommended storage account type for modern Azure deployments.

---

## Best Practices

- Use meaningful naming conventions.
- Apply consistent resource tagging.
- Select the appropriate redundancy option based on business requirements.
- Restrict public network access when appropriate.
- Monitor storage usage and costs.

---

## Challenges Encountered

- Azure subscription activation required verification before creating resources.
- Reviewed naming requirements to ensure global uniqueness.

---

## Lessons Learned

Azure Storage Accounts are the foundation for many Azure services. Proper planning of naming, redundancy, performance, and security settings simplifies future deployments.

---

## PPST Integration

This Storage Account will be used in later labs to support the PPST Data Ingestion Pipeline:

- Azure Blob Storage for document uploads
- Azure Queue Storage for processing requests
- Future integration with Azure Container Apps and PostgreSQL