# Azure Table Storage - CLI Commands

## Prerequisites

Verify Azure CLI is installed:

```bash
az version
```

Login to Azure:

```bash
az login
```

Verify active subscription:

```bash
az account show --output table
```

List available subscriptions:

```bash
az account list --output table
```

---

## Variables

```bash
RESOURCE_GROUP=rg-ppst-storage-lab
STORAGE_ACCOUNT=<your-storage-account-name>
TABLE_NAME=customers
```

Replace `<your-storage-account-name>` with your actual storage account.

---

## List Storage Accounts

```bash
az storage account list --output table
```

---

## Show Storage Account

```bash
az storage account show \
    --resource-group $RESOURCE_GROUP \
    --name $STORAGE_ACCOUNT
```

---

## Obtain Storage Account Key

```bash
az storage account keys list \
    --resource-group $RESOURCE_GROUP \
    --account-name $STORAGE_ACCOUNT \
    --output table
```

---

## Create Table

```bash
az storage table create \
    --name $TABLE_NAME \
    --account-name $STORAGE_ACCOUNT \
    --account-key <storage-account-key>
```

---

## List Tables

```bash
az storage table list \
    --account-name $STORAGE_ACCOUNT \
    --account-key <storage-account-key> \
    --output table
```

---

## Delete Table

```bash
az storage table delete \
    --name $TABLE_NAME \
    --account-name $STORAGE_ACCOUNT \
    --account-key <storage-account-key>
```

---

## Cleanup

Delete Resource Group (Optional)

```bash
az group delete \
    --name $RESOURCE_GROUP \
    --yes \
    --no-wait
```

---

## Verification

Verify table exists:

```bash
az storage table list \
    --account-name $STORAGE_ACCOUNT \
    --account-key <storage-account-key> \
    --output table
```