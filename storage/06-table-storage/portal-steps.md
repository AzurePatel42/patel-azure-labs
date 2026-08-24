
---

# 3. `portal-steps.md`

```powershell
@'
# Azure Table Storage - Portal Steps

## Objective

Create and review an Azure Table Storage table using the Azure Portal.

The lab uses the existing AZ-104 Storage environment.

---

## Lab Environment

```text
Resource Group:  rg-az104-storage-01
Storage Account: staz104az01
Region:          eastus
Table:           customers



Step 1 - Sign in to Azure Portal

Open the Azure Portal:

https://portal.azure.com

Sign in using the Azure account associated with the AZ-104 lab subscription.

Step 2 - Open Resource Groups

Search for:

Resource groups

Open:

rg-az104-storage-01

Verify that the Resource Group is in:

eastus
Step 3 - Open the Storage Account

Inside the Resource Group, open:

staz104az01

Verify the Storage Account.

Expected configuration:

Kind: StorageV2
SKU:  Standard_LRS
Region: eastus
Step 4 - Open Tables

From the Storage Account navigation menu, locate:

Data storage
    |
    +-- Tables

Open:

Tables
Step 5 - Create the Table

Select:

+ Table

Enter:

customers

Create the table.

Step 6 - Verify the Table

After creation, the Tables list should contain:

customers

Open the table.

Step 7 - Review Table Structure

Review the table and understand that Azure Table Storage stores:

Entities
    |
    +-- PartitionKey
    |
    +-- RowKey
    |
    +-- Timestamp
    |
    +-- Custom Properties

The lab entity used:

PartitionKey = Customers
RowKey       = 1001
Step 8 - Entity Operations

Entity CRUD operations for this lab were performed using Azure CLI.

The Azure Portal was used primarily to:

Navigate the Storage Account
Open the Tables interface
Create/review the table
Capture visual evidence

Azure CLI provided the detailed entity-level operations.

Step 9 - Understand PartitionKey

The PartitionKey determines the logical partition used by the entity.

For this lab:

PartitionKey = Customers

PartitionKey design affects:

Scalability
Distribution
Performance
Partition behavior
Step 10 - Understand RowKey

The RowKey uniquely identifies an entity within a partition.

For this lab:

RowKey = 1001

Together:

PartitionKey + RowKey

form the entity's unique key.

Step 11 - Review the Completed CRUD Workflow

The completed workflow was:

Create customers table
        |
        v
Insert entity
        |
        v
Query entity
        |
        v
Update Phone
        |
        v
Verify update
        |
        v
Delete entity
        |
        v
Verify deletion
Step 12 - Final Validation

Azure CLI was used to confirm:

Table: customers
Storage Account: staz104az01
Region: eastus
Provisioning State: Succeeded
Screenshot Evidence

Screenshots captured during the lab:

screenshots/
├── 01-storage-account-overview.png
├── 02-tables-menu.png
├── 03-create-table.png
├── 04-customers-table.png
├── 05-entity-created-and-queried.png
├── 06-entity-updated.png
├── 07-entity-deleted-and-validated.png
└── 08-final-table-storage-validation.png
Portal Validation Checklist
 Azure Portal opened
 Resource Group located
 Storage Account opened
 Tables interface opened
 customers table created
 Table verified
 Table architecture reviewed
 PartitionKey understood
 RowKey understood
 CLI CRUD operations completed
 Final resource validation completed
Important Notes

Azure Portal interfaces can change over time.

Menu names, page layouts, and available options may vary from the interface shown during this lab.

The commands and screenshots in this documentation record the workflow used during this AZ-104 hands-on lab.