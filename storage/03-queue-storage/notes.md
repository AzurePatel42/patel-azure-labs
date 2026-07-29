# Notes

## Key Concepts Learned

- Azure Queue Storage provides reliable message-based communication.
- Queue messages are processed asynchronously.
- Producers add messages to a queue.
- Consumers retrieve and process messages.
- Messages remain in the queue until successfully deleted.
- Visibility timeout prevents multiple workers from processing the same message simultaneously.

---

## Best Practices

- Keep queue messages small and focused.
- Design applications to handle duplicate message processing safely.
- Delete messages only after successful processing.
- Monitor queue length to understand system workload.
- Use meaningful queue names that reflect their purpose.

---

## Challenges Encountered

- Learned the difference between peeking at a message and receiving a message.
- Observed how message visibility changes during processing.

---

## Lessons Learned

Azure Queue Storage decouples applications from background processing. This architecture improves scalability, reliability, and fault tolerance by allowing work to be processed asynchronously.

---

## PPST Integration

Azure Queue Storage can be integrated into the PPST Data Ingestion Pipeline as follows:

User Upload
↓
Azure Blob Storage
↓
Azure Queue Storage
↓
PPST Worker
↓
Download Document
↓
Chunk Document
↓
Generate Embeddings
↓
Store in PostgreSQL (pgvector)

This design allows file uploads to return immediately while background workers process documents independently.