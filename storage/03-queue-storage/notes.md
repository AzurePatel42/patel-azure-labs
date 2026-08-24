# Notes

## Key Concepts Learned

- Azure Queue Storage provides message-based communication between application components.
- Queues allow producers and consumers to operate independently.
- Producers add messages to a queue.
- Consumers receive messages for processing.
- Messages should be deleted only after successful processing.
- Receiving a message makes it temporarily invisible to other consumers.
- Visibility timeout provides time for a worker to process a message.
- Queue Storage is useful for asynchronous and decoupled workloads.

---

## Queue Processing Pattern

```text
Producer
   │
   ▼
Azure Queue Storage
   │
   ▼
Consumer / Worker
   │
   ├── Process Message
   └── Delete Message
```

---

## Best Practices

- Keep messages focused on a single unit of work.
- Make processing operations safe to retry.
- Delete messages only after successful processing.
- Use an appropriate visibility timeout.
- Monitor queue depth and processing failures.
- Use meaningful queue names.
- Avoid placing large documents directly into queue messages.
- Store documents in Blob Storage and place processing instructions or references in the queue.

---

## Blob + Queue Pattern

For document-processing workloads:

```text
Document
   │
   ▼
Azure Blob Storage
   │
   └── sample.txt
          │
          ▼
Azure Queue Storage
          │
          └── Process document sample.txt
                       │
                       ▼
                   PPST Worker
```

Blob Storage stores the document.

Queue Storage communicates the processing work.

The worker performs the processing.

---

## Challenges Encountered

This lab validates the complete Queue Storage message lifecycle:

1. Create Queue
2. Add Message
3. Peek Message
4. Receive Message
5. Observe visibility behavior
6. Delete Message
7. Verify final Queue state

---

## Lessons Learned

Azure Queue Storage provides a simple mechanism for decoupling producers from consumers.

Instead of forcing an upload request to wait for document processing, an application can:

1. Store the document in Blob Storage.
2. Place a processing message into Queue Storage.
3. Return control to the client.
4. Allow a worker to process the message asynchronously.

This pattern improves scalability and helps prevent long-running processing from blocking user requests.

---

## PPST Integration

Azure Queue Storage can serve as the asynchronous processing boundary for the PPST Data Ingestion Pipeline.

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
PPST Worker
  │
  ├── Download Document
  ├── Extract Content
  ├── Chunk Document
  ├── Generate Embeddings
  └── Store in PostgreSQL (pgvector)
```

Example queue message:

```text
Process document sample.txt
```

The queue message represents work to be performed rather than the document itself.

---

## AZ-104 Skills Practiced

- Storage Account management
- Queue Storage
- Azure CLI
- Azure Portal
- Data-plane operations
- Message lifecycle management
- Visibility timeout
- Resource validation
- Asynchronous architecture