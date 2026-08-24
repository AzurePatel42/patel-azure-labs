# Azure CLI Commands

## Login

```powershell
az login
```

---

## Create Resource Group

```powershell
az group create `
  --name rg-az104-storage-01 `
  --location eastus `
  --tags Environment=Lab Module=Storage AZ104=True `
  --output table
```

---

## Check Storage Account Name Availability

```powershell
az storage account check-name `
  --name staz104az01 `
  --query "{Name:name,Available:nameAvailable,Reason:reason,Message:message}" ``
  --output table
```

---

## Create Storage Account

```powershell
az storage account create `
  --name staz104az01 `
  --resource-group rg-az104-storage-01 `
  --location eastus `
  --sku Standard_LRS `
  --kind StorageV2 `
  --access-tier Hot `
  --https-only true `
  --min-tls-version TLS1_2 `
  --allow-blob-public-access false `
  --output table
```

---

## List Storage Accounts

```powershell
az storage account list `
  --query "[].{Name:name,ResourceGroup:resourceGroup,Location:location,Sku:sku.name,Kind:kind}" ``
  --output table
```

---

## Verify Storage Account Configuration

```powershell
az storage account show `
  --name staz104az01 `
  --resource-group rg-az104-storage-01 `
  --query "{Name:name,ResourceGroup:resourceGroup,Location:location,Kind:kind,Sku:sku.name,AccessTier:accessTier,HTTPSOnly:enableHttpsTrafficOnly,MinTLS:minimumTlsVersion,PublicBlobAccess:allowBlobPublicAccess}" ``
  --output table
```

---

## Verify Networking Configuration

```powershell
az storage account show `
  --name staz104az01 `
  --resource-group rg-az104-storage-01 `
  --query "{Name:name,PublicNetworkAccess:publicNetworkAccess,DefaultNetworkAction:networkRuleSet.defaultAction,Bypass:networkRuleSet.bypass,AllowBlobPublicAccess:allowBlobPublicAccess}" ``
  --output table
```

---

## Verify Operational State

```powershell
az storage account show `
  --name staz104az01 `
  --resource-group rg-az104-storage-01 `
  --query "{Name:name,ProvisioningState:provisioningState,Status:statusOfPrimary,PrimaryLocation:primaryLocation,SecondaryLocation:secondaryLocation}" ``
  --output table
```
