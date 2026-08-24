
---

# 2. `cli-commands.md`

```powershell
@'
# Azure Table Storage - CLI Commands

## Objective

Use Azure CLI to inspect, create, validate, and manage Azure Table Storage.

The commands in this document use the actual AZ-104 Storage learning environment used during this lab.

---

## Lab Environment

```text
Resource Group:  rg-az104-storage-01
Storage Account: staz104az01
Table:           customers
Region:          eastus



Prerequisites

Verify Azure CLI:

az version

Verify the active Azure subscription:

az account show `
  --query "{User:user.name,Subscription:id,SubscriptionName:name}" `
  --output table
Variables
$resourceGroup = "rg-az104-storage-01"
$storageAccount = "staz104az01"
$tableName = "customers"
Verify Resource Group
az group show `
  --name $resourceGroup `
  --query "{Name:name,Location:location,ProvisioningState:properties.provisioningState}" `
  --output table

Expected:

Name                 Location    ProvisioningState
-------------------  ----------  -------------------
rg-az104-storage-01  eastus      Succeeded
Verify Storage Account
az storage account show `
  --name $storageAccount `
  --resource-group $resourceGroup `
  --query "{Name:name,Location:location,Kind:kind,SKU:sku.name,ProvisioningState:provisioningState}" `
  --output table

Expected:

Name         Location    Kind       SKU           ProvisioningState
-----------  ----------  ---------  ------------  -------------------
staz104az01  eastus      StorageV2  Standard_LRS  Succeeded
Obtain Storage Account Key

Data-plane Table Storage commands require appropriate authentication.

For this lab:

$storageKey = (
    az storage account keys list `
      --account-name $storageAccount `
      --resource-group $resourceGroup `
      --query "[0].value" `
      --output tsv
)

Do not print the value of $storageKey.

Do not commit the key to Git.

List Tables
az storage table list `
  --account-name $storageAccount `
  --account-key $storageKey `
  --output table
Create Table
az storage table create `
  --name $tableName `
  --account-name $storageAccount `
  --account-key $storageKey `
  --output table

Expected:

Created
-------
True
Verify Table
az storage table list `
  --account-name $storageAccount `
  --account-key $storageKey `
  --output table

Expected:

Name
---------
customers
Insert Entity

Create the first entity:

az storage entity insert `
  --account-name $storageAccount `
  --account-key $storageKey `
  --table-name $tableName `
  --entity PartitionKey=Customers RowKey=1001 FirstName=John LastName=Smith Email=john.smith@example.com Phone=555-0101 `
  --output table

Entity model:

PartitionKey = Customers
RowKey       = 1001
FirstName    = John
LastName     = Smith
Email        = john.smith@example.com
Phone        = 555-0101
Query Entities
az storage entity query `
  --account-name $storageAccount `
  --account-key $storageKey `
  --table-name $tableName `
  --output table

This validates that the entity exists.

Show Specific Entity
az storage entity show `
  --account-name $storageAccount `
  --account-key $storageKey `
  --table-name $tableName `
  --partition-key Customers `
  --row-key 1001 `
  --output table
Update Entity

The lab updated the Phone property from:

555-0101

to:

555-0202

Command:

az storage entity merge `
  --account-name $storageAccount `
  --account-key $storageKey `
  --table-name $tableName `
  --entity PartitionKey=Customers RowKey=1001 Phone=555-0202 `
  --output table
Verify Updated Entity
az storage entity show `
  --account-name $storageAccount `
  --account-key $storageKey `
  --table-name $tableName `
  --partition-key Customers `
  --row-key 1001 `
  --output table

Expected Phone value:

555-0202
Delete Entity
az storage entity delete `
  --account-name $storageAccount `
  --account-key $storageKey `
  --table-name $tableName `
  --partition-key Customers `
  --row-key 1001
Verify Entity Deletion
az storage entity show `
  --account-name $storageAccount `
  --account-key $storageKey `
  --table-name $tableName `
  --partition-key Customers `
  --row-key 1001 `
  --output table

Expected result:

ErrorCode:ResourceNotFound

This confirms the entity no longer exists.

Query After Deletion
az storage entity query `
  --account-name $storageAccount `
  --account-key $storageKey `
  --table-name $tableName `
  --output table

Expected result:

No entity rows returned
Final Table Validation
az storage table list `
  --account-name $storageAccount `
  --account-key $storageKey `
  --output table

Expected:

Name
---------
customers
Final Storage Account Validation
az storage account show `
  --name $storageAccount `
  --resource-group $resourceGroup `
  --query "{Name:name,Location:location,Kind:kind,SKU:sku.name,ProvisioningState:provisioningState}" `
  --output table

Expected state:

ProvisioningState = Succeeded
Cleanup

The customers table is intentionally retained after the lab for the final resource validation.

If cleanup is required:

az storage table delete `
  --name $tableName `
  --account-name $storageAccount `
  --account-key $storageKey

Verify:

az storage table list `
  --account-name $storageAccount `
  --account-key $storageKey `
  --output table
Security Notes

Never commit:

Storage Account keys
Passwords
Connection strings
SAS tokens
Access tokens

Use secure authentication and least-privilege access in production environments.

Validation

The completed lab validated:

Azure subscription
Resource Group
Storage Account
Table creation
Entity insertion
Entity query
Entity update
Entity deletion
Final table existence
Final Storage Account state

This completes the Azure CLI portion of the AZ-104 Table Storage lab.