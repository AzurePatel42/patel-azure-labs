# Lab 03 - Azure Queue Storage

## Objective

Create and manage Azure Queue Storage using Azure CLI and the Azure Portal, then validate queue creation, message processing, visibility behavior, and message deletion.

This lab demonstrates how Azure Queue Storage can decouple document uploads from asynchronous background processing.

---

## Learning Objectives

After completing this lab, you should be able to:

- Create an Azure Storage Queue
- Understand queue naming requirements
- Add messages to a queue
- List and inspect queue messages
- Peek messages without removing them
- Receive messages for processing
- Understand message visibility timeout
- Delete processed messages
- Validate queue state using Azure CLI
- Navigate Azure Queue Storage using the Azure Portal
- Explain how Queue Storage supports asynchronous processing

---

## Azure Services Used

- Azure Resource Group
- Azure Storage Account
- Azure Queue Storage

---

## Prerequisites

- Active Azure Subscription
- Azure Portal access
- Azure CLI installed and authenticated
- Completed Lab 01 - Azure Storage Account
- Completed Lab 02 - Azure Blob Storage

---

## Lab Environment

| Resource | Value |
|---|---|
| Resource Group | `rg-az104-storage-01` |
| Storage Account | `staz104az01` |
| Queue | `documents` |
| Region | `eastus` |

The Queue will use the Storage Account created in Lab 01.

---

## Architecture

```text
Azure Subscription
│
└── Resource Group
    │
    └── Storage Account
        │
        ├── Blob Container
        │   └── documents
        │
        └── Queue
            └── documents
                │
                └── Queue Messages
```

---

## Asynchronous Processing Pattern

```text
User Upload
     │
     ▼
Azure Blob Storage
     │
     │  processing request
     ▼
Azure Queue Storage
     │
     │  message
     ▼
PPST Worker
     │
     ├── Download Document
     ├── Chunk Document
     ├── Generate Embeddings
     └── Store in PostgreSQL (pgvector)
```

Queue Storage allows the upload operation and background processing operation to be decoupled.

---

## Validation Checklist

- [ ] Storage Account verified
- [ ] Queue created
- [ ] Queue listed successfully
- [ ] Message added
- [ ] Message visible through peek
- [ ] Message received
- [ ] Message visibility behavior observed
- [ ] Processed message deleted
- [ ] Final queue state verified

---

## Screenshots

| Screenshot | Evidence |
|---|---|
| `00-queue-environment-inventory.png` | Storage environment before Queue work |
| `01-queue-created.png` | Queue successfully created |
| `02-queue-message-added.png` | Message successfully added |
| `03-queue-peek-message.png` | Message inspected without removal |
| `04-queue-receive-message.png` | Message received for processing |
| `05-queue-message-deleted.png` | Processed message deleted |
| `06-queue-final-validation.png` | Final Queue validation |

---

## Outcome

Successfully created and validated Azure Queue Storage using the existing Storage Account.

The lab demonstrates how Queue Storage can provide asynchronous communication between an upload workflow and background workers.

---

## PPST Integration

Azure Queue Storage can serve as the asynchronous boundary between the PPST document upload workflow and background processing workers.

Example:

```text
Client
  │
  ▼
Upload API
  │
  ▼
Azure Blob Storage
  │
  ▼
Azure Queue Storage
  │
  ▼
PPST Task / Worker
  │
  ├── Download
  ├── Extract
  ├── Chunk
  ├── Embed
  └── Persist
```

This design allows the upload request to complete without requiring document processing to finish synchronously.

---

## Key AZ-104 Concepts

This lab reinforces:

- Storage Accounts
- Queue Storage
- Data-plane access
- Azure RBAC
- Azure CLI
- Portal validation
- Asynchronous processing
- Message visibility
- Operational validation