# Azure CLI Commands

## Login

```bash
az login
```

---

## List Storage Accounts

```bash
az storage account list --output table
```

---

## Create Blob Container

```bash
az storage container create \
  --name documents \
  --account-name <storage-account-name> \
  --auth-mode login
```

---

## Upload a Blob

```bash
az storage blob upload \
  --account-name <storage-account-name> \
  --container-name documents \
  --name sample.txt \
  --file sample.txt \
  --auth-mode login
```

---

## List Blobs

```bash
az storage blob list \
  --account-name <storage-account-name> \
  --container-name documents \
  --output table
```

---

## Download a Blob

```bash
az storage blob download \
  --account-name <storage-account-name> \
  --container-name documents \
  --name sample.txt \
  --file downloaded-sample.txt
```