
# Lab 01 - Azure Storage Account

## Objective

Create and configure an Azure Storage Account using Azure CLI and Azure Portal, then validate its core configuration, security settings, networking configuration, and operational state.

This lab establishes the Storage Account foundation used by the remaining Azure Storage labs.

---

## Learning Objectives

After completing this lab, you should be able to:

- Create an Azure Resource Group for Storage workloads
- Create an Azure Storage Account
- Understand Storage Account naming requirements
- Configure Standard performance
- Configure LRS redundancy
- Configure the Hot access tier
- Require HTTPS traffic
- Configure minimum TLS version
- Disable anonymous/public Blob access
- Inspect Storage Account networking configuration
- Validate deployment using Azure CLI
- Navigate and validate the Storage Account in the Azure Portal

---

## Azure Services Used

- Azure Resource Group
- Azure Storage Account

---

## Lab Resources

| Resource | Value |
|---|---|
| Resource Group | `rg-az104-storage-01` |
| Storage Account | `staz104az01` |
| Location | `eastus` |
| Kind | `StorageV2` |
| SKU | `Standard_LRS` |
| Access Tier | `Hot` |
| HTTPS Only | `True` |
| Minimum TLS | `TLS1_2` |
| Public Blob Access | `False` |

---

## Architecture

```text
Azure Subscription
│
└── rg-az104-storage-01
    │
    └── staz104az01
        │
        ├── Blob Storage
        ├── Queue Storage
        ├── File Storage
        └── Table Storage


Deployment

The Storage Account was created with:

StorageV2
Standard performance
LRS redundancy
Hot access tier
HTTPS-only traffic
Minimum TLS 1.2
Anonymous/public Blob access disabled
Validation

Post-deployment CLI validation confirmed:

Provisioning State: Succeeded
Primary Status:     available
Primary Location:   eastus

Configuration verification confirmed:

Kind:               StorageV2
SKU:                Standard_LRS
Access Tier:        Hot
HTTPS Only:         True
Minimum TLS:        TLS1_2
Public Blob Access: False

Networking verification confirmed:

Default Network Action: Allow
Bypass:                  None
Public Blob Access:      False
Screenshots
Screenshot	Description
00-storage-environment-inventory.png	Overall Azure lab environment
01-storage-account-overview.png	Storage Account overview
02-storage-account-security-configuration.png	Security configuration
03-storage-account-networking.png	Networking configuration
Outcome

Successfully created and validated a dedicated Azure Storage Account for the AZ-104 Storage learning module.

The resource was intentionally configured, inspected, validated, and documented for repeatable Azure CLI and Portal-based deployment.
'@ | Set-Content .\README.md



### 2. Replace `cli-commands.md`


```powershell
@'
# Azure CLI Commands


## Login


```powershell
az login
Create Resource Group
az group create `
  --name rg-az104-storage-01 `
  --location eastus `
  --tags Environment=Lab Module=Storage AZ104=True `
  --output table
Check Storage Account Name Availability
az storage account check-name `
  --name staz104az01 `
  --query "{Name:name,Available:nameAvailable,Reason:reason,Message:message}" `
  --output table
Create Storage Account
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
List Storage Accounts
az storage account list `
  --query "[].{Name:name,ResourceGroup:resourceGroup,Location:location,Sku:sku.name,Kind:kind}" `
  --output table
Verify Storage Account Configuration
az storage account show `
  --name staz104az01 `
  --resource-group rg-az104-storage-01 `
  --query "{Name:name,ResourceGroup:resourceGroup,Location:location,Kind:kind,Sku:sku.name,AccessTier:accessTier,HTTPSOnly:enableHttpsTrafficOnly,MinTLS:minimumTlsVersion,PublicBlobAccess:allowBlobPublicAccess}" `
  --output table
Verify Networking Configuration
az storage account show `
  --name staz104az01 `
  --resource-group rg-az104-storage-01 `
  --query "{Name:name,PublicNetworkAccess:publicNetworkAccess,DefaultNetworkAction:networkRuleSet.defaultAction,Bypass:networkRuleSet.bypass,AllowBlobPublicAccess:allowBlobPublicAccess}" `
  --output table
Verify Operational State
az storage account show `
  --name staz104az01 `
  --resource-group rg-az104-storage-01 `
  --query "{Name:name,ProvisioningState:provisioningState,Status:statusOfPrimary,PrimaryLocation:primaryLocation,SecondaryLocation:secondaryLocation}" `
  --output table
Delete Storage Account
az storage account delete `
  --name staz104az01 `
  --resource-group rg-az104-storage-01 `
  --yes
Delete Lab Resource Group

Only use this after all Storage labs using the resource group are complete.

az group delete `
  --name rg-az104-storage-01 `
  --yes `
  --no-wait

'@ | Set-Content .\cli-commands.md



- Performance: Standard
- Redundancy: LRS
- Access Tier: Hot


---


## Step 3 - Security Configuration


Configure the Storage Account security settings:


- Secure transfer required: Enabled
- Minimum TLS version: TLS 1.2
- Allow Blob anonymous/public access: Disabled


---


## Step 4 - Review and Create


Review the configuration and select:


**Review + Create**


Then select:


**Create**


---


## Step 5 - Overview Validation


Open the deployed Storage Account.


Verify:


- Storage Account name
- Resource Group
- Region
- Subscription
- Provisioning status
- Account configuration


Screenshot:


`01-storage-account-overview.png`


---


## Step 6 - Security Validation


Open:


**Storage Account → Configuration**


Verify:


- Minimum TLS version
- Secure transfer requirement
- Public Blob access setting


Screenshot:


`02-storage-account-security-configuration.png`


---


## Step 7 - Networking Validation


Open:


**Storage Account → Networking**


Review the network access configuration.


Screenshot:


`03-storage-account-networking.png`


---


## Result


The Azure Storage Account was successfully deployed and validated through both Azure Portal and Azure CLI.
'@ | Set-Content .\portal-steps.md
4. Replace notes.md
@'
# Notes


## Key Concepts Learned


- Storage Account names must be globally unique.
- `StorageV2` is the modern general-purpose Storage Account kind.
- Standard performance is appropriate for many general workloads.
- LRS provides redundancy within the primary Azure region.
- The Hot access tier is intended for frequently accessed data.
- HTTPS-only traffic improves transport security.
- TLS 1.2 was selected as the minimum TLS version.
- Anonymous/public Blob access was disabled.
- Storage Accounts provide services including Blob, Queue, File, and Table Storage.


---


## Actual Lab Configuration


```text
Storage Account:      staz104az01
Resource Group:       rg-az104-storage-01
Location:             eastus
Kind:                 StorageV2
SKU:                  Standard_LRS
Access Tier:          Hot
HTTPS Only:           True
Minimum TLS:          TLS1_2
Public Blob Access:   False
Networking

The Storage Account networking configuration was inspected through Azure CLI and Azure Portal.

Observed configuration:

Default Network Action: Allow
Bypass:                  None
Public Blob Access:      False

The distinction between network access and anonymous Blob access is important:

Network access controls how clients can reach the Storage Account.
Public Blob access controls whether anonymous access to Blob data is permitted.
Validation

The deployed Storage Account was verified using Azure CLI.

Observed operational state:

Provisioning State: Succeeded
Primary Status:     available
Primary Location:   eastus
Challenges Encountered

The initially proposed Storage Account name was already globally registered.

The name availability check was used before deployment:

az storage account check-name

The available name staz104az01 was then selected.

Lessons Learned

A Storage Account should be validated after deployment rather than relying only on the creation command.

The lab followed this workflow:

Plan
  ↓
Create
  ↓
Inspect
  ↓
Validate
  ↓
Document
  ↓
Capture Evidence
PPST Integration

This Storage Account provides the foundation for later Azure Storage labs and can support future PPST workloads such as:

Document uploads through Azure Blob Storage
Queue-based processing requests
File-based application storage
Integration with Azure Container Apps
Integration with PostgreSQL-backed services
