
---

# 4. `notes.md`

```powershell
@'
# Azure Table Storage - Notes

## Overview

Azure Table Storage is a NoSQL key-value store designed for storing large volumes of structured, non-relational data.

It is part of Azure Storage Accounts.

Table Storage is useful when an application needs scalable structured data without the relational features of a traditional SQL database.

---

## Core Characteristics

Azure Table Storage provides:

- NoSQL data storage
- Schema-less entities
- PartitionKey
- RowKey
- Scalable storage
- Low-cost storage
- REST-based access
- Azure CLI support
- Azure SDK support
- Azure Portal management

---

## Data Model

The primary data object is an Entity.

An entity contains:

```text
PartitionKey
RowKey
Timestamp
Custom Properties



PartitionKey

PartitionKey identifies the logical partition containing an entity.

Example:

PartitionKey = Customers

Entities with the same PartitionKey belong to the same logical partition.

PartitionKey design is important because it affects:

Data distribution
Scalability
Performance
Partition behavior
Workload distribution
RowKey

RowKey uniquely identifies an entity within its partition.

Example:

RowKey = 1001

The combination of:

PartitionKey + RowKey

forms the unique key for an entity.

Example:

Customers + 1001
Entity

An entity is similar to a record in a traditional database, but Table Storage is not relational.

An entity can contain different properties from another entity.

Example:

Entity 1
PartitionKey = Customers
RowKey       = 1001
FirstName    = John
LastName     = Smith
Email        = john.smith@example.com
Phone        = 555-0202
CRUD

Table Storage supports common data operations.

Create

Insert an entity.

Read

Query or retrieve an entity.

Update

Merge or replace entity properties.

Delete

Delete an entity.

The lab demonstrated all four operations.

Lab CRUD Sequence

The actual lab sequence was:

CREATE
customers table
        |
        v
CREATE
Customer entity
        |
        v
READ
Customer entity
        |
        v
UPDATE
Phone 555-0101 -> 555-0202
        |
        v
READ
Updated entity
        |
        v
DELETE
Customer entity
        |
        v
VALIDATE
Entity no longer exists
Scalability

PartitionKey selection is an important architectural decision.

A good PartitionKey can help distribute workload.

A poor PartitionKey can create hot partitions and uneven workload distribution.

When designing a Table Storage application:

Understand access patterns
Understand query patterns
Select PartitionKey carefully
Use RowKey for efficient entity identification
Avoid concentrating excessive traffic on a single partition
Keep entities appropriately sized
Schema-less Design

Table Storage does not require every entity to have exactly the same set of properties.

This allows applications to evolve their data model without traditional relational schema migrations.

However, application-level consistency is still important.

Schema-less does not mean design-less.

Querying

Efficient queries generally use:

PartitionKey
RowKey

The PartitionKey and RowKey combination provides efficient entity identification.

Applications should design their data model around the queries they need to perform.

Advantages

Azure Table Storage can provide:

Low-cost storage
High scalability
Simple key/value access
Schema flexibility
Large data volumes
High availability depending on storage configuration
Simple integration with Azure applications
Limitations

Table Storage does not provide traditional relational database features such as:

Joins
Foreign keys
Stored procedures
Relational constraints
Complex relational queries
Traditional relational transactions across arbitrary records
Common Use Cases

Potential use cases include:

User profiles
Device metadata
IoT data
Configuration settings
Audit information
Product catalogs
Session information
Application metadata
Table Storage vs Azure SQL
Table Storage
NoSQL
Key/value model
Schema-less
PartitionKey and RowKey
Highly scalable
Simple access patterns
Azure SQL
Relational
Structured schema
Tables and relationships
Joins
Foreign keys
Stored procedures
Complex queries
ACID transactional capabilities

Choose based on application requirements rather than simply choosing the newest technology.

Table Storage vs Cosmos DB
Azure Table Storage

Best suited to:

Simpler workloads
Lower-cost storage
Key/value access patterns
Applications that fit the PartitionKey/RowKey model
Cosmos DB

Can provide capabilities such as:

Global distribution
Low-latency access
Multiple consistency models
Automatic indexing
Large-scale throughput

Cosmos DB generally targets more advanced distributed application requirements.

Security

Protect Storage Account credentials.

Do not commit:

Storage Account keys
Passwords
Connection strings
SAS tokens
Access tokens

For production workloads, prefer appropriate identity-based authentication and least-privilege access where supported.

Azure CLI

Azure CLI can manage both:

Resource Plane

and, with appropriate authentication:

Data Plane

This distinction is important.

Creating a Storage Account is a resource-management operation.

Creating and querying an entity inside a Table is a data-plane operation.

Resource Plane vs Data Plane
Azure Resource Manager
        |
        +-- Resource Group
        |
        +-- Storage Account
        |
        +-- Storage configuration


Storage Data Plane
        |
        +-- Tables
        |
        +-- Entities
        |
        +-- Table data

Understanding this distinction helps explain why an Azure CLI command may require additional Storage credentials or data-plane RBAC permissions.

AZ-104 Exam Notes

Know these concepts:

Table Storage is NoSQL.
It is part of Azure Storage.
Data is stored as entities.
Entities use PartitionKey and RowKey.
PartitionKey affects partitioning and scalability.
RowKey identifies an entity within a partition.
PartitionKey + RowKey form the entity key.
Table Storage is schema-less.
Table Storage does not provide relational joins.
Table Storage is different from Azure SQL.
Table Storage is different from Blob Storage.
Table Storage is different from Managed Disks.
Interview Questions
What is Azure Table Storage?

A scalable NoSQL key-value storage service within Azure Storage designed for structured, non-relational data.

What is PartitionKey?

The key that determines the logical partition for an entity.

What is RowKey?

The key that uniquely identifies an entity within its partition.

What forms the unique key of an entity?

PartitionKey + RowKey.

Why is PartitionKey important?

It affects data distribution, scalability, and workload performance.

Is Table Storage relational?

No. It is a NoSQL key-value/entity store.

Does Table Storage support joins?

No traditional relational joins are provided.

When would you choose Table Storage over Azure SQL?

When the workload fits a scalable key/value model and does not require complex relational queries or relationships.

Key Takeaways
Azure Table Storage is a scalable NoSQL service.
It stores entities rather than relational rows.
Entities contain PartitionKey and RowKey.
PartitionKey is important for scalability.
RowKey identifies an entity within a partition.
Schema-less storage provides flexibility.
Data access patterns should drive PartitionKey design.
Azure CLI can manage Table Storage data.
Resource-plane and data-plane operations are different.
Storage credentials must be protected.
Table Storage is useful for simple, high-volume structured data.
Lab Outcome

The lab successfully demonstrated:

Azure Storage Account validation
Azure Table creation
Entity creation
Entity querying
Entity updating
Entity deletion
PartitionKey
RowKey
Azure Portal
Azure CLI
NoSQL data modeling
Final resource validation

This completes the AZ-104 Storage Module 06 - Azure Table Storage hands-on lab.