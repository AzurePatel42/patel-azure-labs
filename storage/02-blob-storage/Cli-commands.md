# Azure CLI Commands

## Login

```bash
az login
```

---

## Identify Signed-In User

```bash
az account show \
  --query "{User:user.name,Subscription:id}" \
  --output table
```

---

## Identify Entra User

```bash
az ad signed-in-user show \
  --query "{ObjectId:id,DisplayName:displayName,UPN:userPrincipalName}" \
  --output table
```

---

## Get Storage Account Resource ID

```bash
az storage account show \
  --name staz104az01 \
  --resource-group rg-az104-storage-01 \
  --query id \
  --output tsv
```

---

## Assign Storage Blob Data Contributor

```bash
az role assignment create \
  --assignee-object-id <user-object-id> \
  --assignee-principal-type User \
  --role "Storage Blob Data Contributor" \
  --scope <storage-account-resource-id> \
  --output table
```

---

## Verify Role Assignment

```bash
az role assignment list \
  --assignee <user-object-id> \
  --scope <storage-account-resource-id> \
  --query "[].{Role:roleDefinitionName,Principal:principalName,Scope:scope}" \
  --output table
```

---

## Create Private Blob Container

```bash
az storage container create \
  --name documents \
  --account-name staz104az01 \
  --auth-mode login \
  --public-access off \
  --output table
```

---

## List Containers

```bash
az storage container list \
  --account-name staz104az01 \
  --auth-mode login \
  --query "[].{Name:name,PublicAccess:properties.publicAccess}" \
  --output table
```

---

## Upload a Blob

```bash
az storage blob upload \
  --account-name staz104az01 \
  --container-name documents \
  --name sample.txt \
  --file sample.txt \
  --auth-mode login \
  --overwrite true \
  --output table
```

---

## List Blobs

```bash
az storage blob list \
  --account-name staz104az01 \
  --container-name documents \
  --auth-mode login \
  --query "[].{Name:name,Size:properties.contentLength,LastModified:properties.lastModified,AccessTier:properties.accessTier,Encrypted:properties.serverEncrypted}" \
  --output table
```

---

## Show Blob Properties

```bash
az storage blob show \
  --account-name staz104az01 \
  --container-name documents \
  --name sample.txt \
  --auth-mode login \
  --query "{Name:name,Size:properties.contentLength,LastModified:properties.lastModified,ETag:properties.etag,ServerEncrypted:properties.serverEncrypted,AccessTier:properties.accessTier}" \
  --output table
```

---

## Show Blob Metadata

```bash
az storage blob metadata show \
  --account-name staz104az01 \
  --container-name documents \
  --name sample.txt \
  --auth-mode login \
  --output table
```

---

## Update Blob Metadata

```bash
az storage blob metadata update \
  --account-name staz104az01 \
  --container-name documents \
  --name sample.txt \
  --auth-mode login \
  --metadata purpose=az104-lab source=patel-azure-labs module=blob-storage \
  --output table
```

---

## Set Blob Access Tier

```bash
az storage blob set-tier \
  --account-name staz104az01 \
  --container-name documents \
  --name sample.txt \
  --tier Hot \
  --auth-mode login
```

---

## Download a Blob

```bash
az storage blob download \
  --account-name staz104az01 \
  --container-name documents \
  --name sample.txt \
  --file downloaded-sample.txt \
  --auth-mode login \
  --output table
```

---

## Compare Downloaded File

```powershell
Compare-Object `
  (Get-Content .\sample.txt) `
  (Get-Content .\downloaded-sample.txt)
```

No output indicates that the downloaded file matches the original.

---

## Generate Read-Only User Delegation SAS

```bash
az storage blob generate-sas \
  --account-name staz104az01 \
  --container-name documents \
  --name sample.txt \
  --permissions r \
  --expiry <short-lived-expiration> \
  --auth-mode login \
  --as-user \
  --output tsv
```

Do not expose or commit the generated SAS token.

---

## Lab Cleanup

Keep the resource group while the remaining Storage labs are being completed.

After all Storage labs are finished:

```bash
az group delete \
  --name rg-az104-storage-01 \
  --yes \
  --no-wait
```