# Azure Table Storage Notes

## Overview

Azure Table Storage is a NoSQL key-value store designed for storing large volumes of structured, non-relational data.

It is part of Azure Storage Accounts.

---

## Characteristics

- NoSQL database
- Schema-less
- Key-value storage
- Massively scalable
- Low cost
- High availability
- REST-based

---

## Data Model

Each record is called an Entity.

Each entity contains:

- PartitionKey
- RowKey
- Timestamp
- Custom Properties

Example

PartitionKey

```
Customers
```

RowKey

```
1001
```

Properties

```
FirstName
LastName
Email
Phone
```

---

## PartitionKey

The PartitionKey determines how data is distributed.

Entities sharing the same PartitionKey are stored together.

Choosing a good PartitionKey improves performance.

---

## RowKey

Uniquely identifies an entity within a partition.

Together

PartitionKey + RowKey

form the primary key.

---

## Advantages

- Extremely inexpensive
- High scalability
- Fast lookups
- Suitable for billions of records
- Automatic replication
- Highly available

---

## Limitations

- No joins
- Limited querying
- No foreign keys
- No stored procedures
- No relational constraints

---

## Common Use Cases

- User profiles
- IoT telemetry
- Device metadata
- Audit logs
- Configuration settings
- Product catalogs
- Session storage

---

## Azure Table Storage vs Azure SQL

Azure Table Storage

- NoSQL
- Key-value
- Massive scale
- Cheap
- Schema-less

Azure SQL

- Relational
- ACID transactions
- Joins
- Stored procedures
- Complex queries

---

## Azure Table Storage vs Cosmos DB Table API

Table Storage

- Lowest cost
- Simpler workloads

Cosmos DB

- Global distribution
- Automatic indexing
- Lower latency
- Multiple consistency models
- Higher throughput

---

## Best Practices

- Choose PartitionKey carefully.
- Keep entities small.
- Avoid hot partitions.
- Use RowKey for efficient lookups.
- Store only required properties.
- Design for scalability.

---

## AZ-104 Exam Notes

Know:

- Table Storage is NoSQL.
- Uses PartitionKey and RowKey.
- Part of Azure Storage Account.
- Optimized for scalability.
- Low-cost structured storage.
- Schema-less.

---

## Interview Questions

What is Azure Table Storage?

When would you use Table Storage instead of Azure SQL?

What is the purpose of PartitionKey?

How is RowKey used?

What are the limitations of Table Storage?

How does Azure Table Storage differ from Cosmos DB Table API?

---

## Key Takeaways

- Azure Table Storage is a scalable NoSQL service.
- It stores entities rather than relational rows.
- PartitionKey controls scalability.
- RowKey uniquely identifies entities.
- Excellent for inexpensive, high-volume structured data.