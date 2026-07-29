# Azure CLI Commands

## Login

```bash
az login
```

---

## Create Resource Group

```bash
az group create \
  --name rg-storage-lab \
  --location eastus
```

---

## Create Storage Account

```bash
az storage account create \
  --resource-group rg-storage-lab \
  --name mystorageaccount \
  --location eastus \
  --sku Standard_LRS \
  --kind StorageV2
```

---

## List Storage Accounts

```bash
az storage account list --output table
```

---

## Show Storage Account

```bash
az storage account show \
  --name mystorageaccount \
  --resource-group rg-storage-lab
```

---

## Delete Resource Group (Optional)

```bash
az group delete \
  --name rg-storage-lab
```