
# Lab 06 - Azure Table Storage

## Objective

Create, manage, validate, and document Azure Table Storage using the existing AZ-104 Storage learning environment.

This lab demonstrates Azure Table Storage as a scalable, schema-less NoSQL data store and provides hands-on experience with tables, entities, PartitionKey, RowKey, and CRUD operations.

---

## Learning Objectives

After completing this lab, you should be able to:

- Explain Azure Table Storage
- Explain the Table Storage data model
- Create an Azure Table
- Understand entities and properties
- Understand PartitionKey
- Understand RowKey
- Insert entities
- Query entities
- Update entities
- Delete entities
- Validate Table Storage using Azure CLI
- Navigate Table Storage through the Azure Portal
- Compare Azure Table Storage with relational databases
- Understand common Table Storage use cases

---

## Lab Environment

| Setting | Value |
|---|---|
| Subscription | `patel-platform-service-template` |
| Resource Group | `rg-az104-storage-01` |
| Region | `eastus` |
| Storage Account | `staz104az01` |
| Storage Account Kind | `StorageV2` |
| Storage Account SKU | `Standard_LRS` |
| Table | `customers` |

---

## Azure Table Storage Overview

Azure Table Storage is a NoSQL key-value store designed for large volumes of structured, non-relational data.

It is part of an Azure Storage Account.

Conceptually:

```text
Azure Subscription
        |
        v
Resource Group
        |
        v
Storage Account
        |
        v
Table Storage
        |
        v
customers
        |
        v
Entities


Unlike a relational database, Table Storage does not require a fixed relational schema.

Table Storage Data Model

The primary unit of data is an Entity.

Each entity contains:

PartitionKey
RowKey
Timestamp
Custom properties

For this lab, the entity was:

PartitionKey = Customers
RowKey       = 1001
FirstName    = John
LastName     = Smith
Email        = john.smith@example.com
Phone        = 555-0101

The phone number was later updated to:

Phone = 555-0202
PartitionKey

The PartitionKey identifies the partition to which an entity belongs.

For this lab:

PartitionKey = Customers

Entities with the same PartitionKey belong to the same logical partition.

PartitionKey design is important for:

Scalability
Distribution
Performance
Avoiding hot partitions
Efficient queries

A poor PartitionKey design can create uneven workloads.

RowKey

The RowKey uniquely identifies an entity within its partition.

For this lab:

RowKey = 1001

The combination of:

PartitionKey + RowKey

forms the unique key for the entity.

For this lab:

Customers + 1001

uniquely identified the customer entity.

CRUD Workflow

The hands-on CRUD workflow was:

Create Table
     |
     v
Insert Entity
     |
     v
Query Entity
     |
     v
Update Entity
     |
     v
Query Updated Entity
     |
     v
Delete Entity
     |
     v
Validate Deletion

The completed operations were:

CREATE
  customers table

CREATE
  Customer entity

READ
  Customer entity

UPDATE
  Phone: 555-0101 -> 555-0202

DELETE
  Customer entity

VALIDATE
  Entity no longer exists
Entity Created

The initial entity used:

PartitionKey = Customers
RowKey       = 1001
FirstName    = John
LastName     = Smith
Email        = john.smith@example.com
Phone        = 555-0101

The entity was successfully inserted and queried.

Entity Updated

The phone property was changed from:

555-0101

to:

555-0202

Azure returned the updated entity with a new Timestamp.

This demonstrates that Table Storage entities can be modified without requiring a traditional relational schema migration.

Entity Deleted

The entity was deleted using:

PartitionKey = Customers
RowKey       = 1001

A subsequent entity lookup returned:

ResourceNotFound

A table-wide entity query returned no entities.

This validated that the entity had been successfully removed.

Azure Portal

The Azure Portal was used to review the Storage Account and Table Storage interface.

The portal workflow included:

Storage Account
      |
      v
Data Storage
      |
      v
Tables
      |
      v
customers

The Portal provides a graphical interface for managing Azure Storage resources.

Azure CLI was used for detailed entity-level validation and CRUD operations.

Azure CLI

Azure CLI was used to:

Verify the Azure subscription
Verify the Resource Group
Verify the Storage Account
Retrieve Storage Account credentials
Create the table
List tables
Insert entities
Query entities
Update entities
Delete entities
Validate the final state

The CLI commands are documented in:

cli-commands.md
Authentication

For this hands-on lab, Azure CLI data-plane operations used a Storage Account key stored temporarily in a PowerShell variable.

Example:

$storageKey = (
    az storage account keys list `
      --account-name $storageAccount `
      --resource-group $resourceGroup `
      --query "[0].value" `
      --output tsv
)

The key was not printed or stored in the repository.

Never commit:

Storage Account keys
Passwords
Connection strings
SAS tokens
Access tokens
Table Storage Use Cases

Common use cases include:

User profiles
Device metadata
IoT data
Configuration information
Audit information
Product catalogs
Session information
Large volumes of structured application data

Table Storage is especially useful when:

The data does not require complex relational queries
The workload requires high scalability
The data can be modeled around PartitionKey and RowKey
Low-cost NoSQL storage is desirable
Table Storage Limitations

Table Storage is not a relational database.

It does not provide traditional relational features such as:

Joins
Foreign keys
Stored procedures
Relational constraints
Complex relational query capabilities

Applications requiring complex relationships and relational transactions may be better suited to Azure SQL or another relational database service.

Azure Table Storage vs Azure SQL
Azure Table Storage	Azure SQL
NoSQL	Relational
Schema-less	Structured schema
PartitionKey + RowKey	Primary/foreign keys
No joins	Supports joins
Massive-scale key/value workloads	Complex relational workloads
Lower-cost simple workloads	Rich relational capabilities

The correct service depends on the application workload.

Azure Table Storage vs Cosmos DB

Azure Table Storage and Azure Cosmos DB can both support key/value-style workloads, but they target different requirements.

Table Storage is appropriate for:

Simpler workloads
Lower-cost storage
Large structured datasets
Applications that fit the PartitionKey/RowKey model

Cosmos DB is appropriate when applications require capabilities such as:

Global distribution
Very low latency
Multiple consistency models
Advanced indexing
Higher-scale throughput requirements
Screenshot Evidence

Screenshots captured during this lab are stored in:

screenshots/

Expected screenshots:

screenshots/
├── 01-storage-account-overview.png
├── 02-tables-menu.png
├── 03-create-table.png
├── 04-customers-table.png
├── 05-entity-created-and-queried.png
├── 06-entity-updated.png
├── 07-entity-deleted-and-validated.png
└── 08-final-table-storage-validation.png

The screenshots document:

Storage Account environment
Tables menu
Table creation
customers table
Entity creation and query
Entity update
Entity deletion and validation
Final Azure resource validation
Validation Checklist

Before considering this lab complete:

 Azure subscription verified
 Resource Group verified
 Storage Account verified
 Storage Account configuration verified
 Tables interface reviewed
 customers table created
 Table existence verified with Azure CLI
 Entity created
 PartitionKey verified
 RowKey verified
 Entity queried
 Entity updated
 Updated entity verified
 Entity deleted
 Entity deletion verified
 Final table validation completed
 Screenshots captured
 Documentation updated
 No secrets committed
Key AZ-104 Takeaways
Azure Table Storage is a NoSQL key-value store.
Table Storage is part of an Azure Storage Account.
Data is stored as entities.
Each entity has a PartitionKey and RowKey.
PartitionKey is important for scalability and distribution.
RowKey uniquely identifies an entity within a partition.
PartitionKey + RowKey form the entity key.
Table Storage is schema-less.
Table Storage does not provide traditional relational joins.
Azure CLI can perform Table Storage data-plane operations.
Storage Account credentials must be protected.
PartitionKey design is an important architecture decision.
Table Storage is different from Azure SQL.
Table Storage is different from Blob Storage.
Table Storage is different from Managed Disks.
Outcome

Successfully created, managed, validated, and documented an Azure Table Storage table using the existing AZ-104 Storage learning environment.

The lab provided hands-on experience with:

Azure Table Storage
NoSQL data modeling
Tables
Entities
PartitionKey
RowKey
CRUD operations
Azure Portal
Azure CLI
Authentication
Validation
Scalability concepts
Storage architecture
Cost awareness

This completes the AZ-104 Storage Module 06 - Azure Table Storage hands-on lab.