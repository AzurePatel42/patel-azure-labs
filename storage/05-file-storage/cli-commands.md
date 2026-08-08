# Azure File Storage - CLI Commands

## Prerequisites

Azure CLI must be installed and authenticated.

Verify Azure CLI:

```powershell
az version

Verify the active Azure account:

az account show

List available subscriptions:

az account list --output table

Set the required subscription if necessary:

az account set --subscription "<SUBSCRIPTION_NAME_OR_ID>"

Verify the active subscription:

az account show --output table
1. Variables

Using variables makes the commands easier to reuse.

Example:

$resourceGroup = "rg-ppst-storage-lab"
$storageAccount = "<YOUR_STORAGE_ACCOUNT_NAME>"
$fileShare = "lab-files"

Verify the variables:

$resourceGroup
$storageAccount
$fileShare
2. List Storage Accounts

List Storage Accounts in the Resource Group:

az storage account list `
  --resource-group $resourceGroup `
  --output table
3. Show Storage Account

Display Storage Account details:

az storage account show `
  --name $storageAccount `
  --resource-group $resourceGroup `
  --output json

Display a concise view:

az storage account show `
  --name $storageAccount `
  --resource-group $resourceGroup `
  --query "{Name:name, Location:location, Kind:kind, SKU:sku.name}" `
  --output table
4. Retrieve Storage Account Key

Azure Files can be accessed using a Storage Account key.

Retrieve the keys:

az storage account keys list `
  --account-name $storageAccount `
  --resource-group $resourceGroup `
  --output table

Store the first key in a PowerShell variable:

$storageKey = (
    az storage account keys list `
      --account-name $storageAccount `
      --resource-group $resourceGroup `
      --query "[0].value" `
      --output tsv
)

Verify that the variable contains a value:

$storageKey.Length

Security note: Never commit storage account keys to GitHub or place them directly into documentation.

5. Create a File Share

Create the Azure File Share:

az storage share-rm create `
  --resource-group $resourceGroup `
  --storage-account $storageAccount `
  --name $fileShare `
  --quota 100

The quota value is specified in GiB.

6. List File Shares

List the file shares in the Storage Account:

az storage share-rm list `
  --resource-group $resourceGroup `
  --storage-account $storageAccount `
  --output table
7. Show File Share

Display the file share configuration:

az storage share-rm show `
  --resource-group $resourceGroup `
  --storage-account $storageAccount `
  --name $fileShare `
  --output json
8. Create a Directory

Create a directory inside the file share:

az storage directory create `
  --account-name $storageAccount `
  --account-key $storageKey `
  --share-name $fileShare `
  --name documents
9. List Directories and Files

List the contents of the file share:

az storage file list `
  --account-name $storageAccount `
  --account-key $storageKey `
  --share-name $fileShare `
  --output table

List the contents of a directory:

az storage file list `
  --account-name $storageAccount `
  --account-key $storageKey `
  --share-name $fileShare `
  --path documents `
  --output table
10. Upload a File

Create a small local test file:

"Azure Files Lab Test" | Out-File .\test.txt

Upload the file:

az storage file upload `
  --account-name $storageAccount `
  --account-key $storageKey `
  --share-name $fileShare `
  --source .\test.txt `
  --path documents/test.txt
11. Verify Uploaded File

List the directory:

az storage file list `
  --account-name $storageAccount `
  --account-key $storageKey `
  --share-name $fileShare `
  --path documents `
  --output table

The uploaded file should appear in the results.

12. Download a File

Download the test file:

az storage file download `
  --account-name $storageAccount `
  --account-key $storageKey `
  --share-name $fileShare `
  --path documents/test.txt `
  --dest .\downloaded-test.txt

Verify the downloaded file:

Get-Content .\downloaded-test.txt

Expected output:

Azure Files Lab Test
13. Delete a File

Delete the test file from Azure Files:

az storage file delete `
  --account-name $storageAccount `
  --account-key $storageKey `
  --share-name $fileShare `
  --path documents/test.txt
14. Delete a Directory

Remove the directory after deleting its contents:

az storage directory delete `
  --account-name $storageAccount `
  --account-key $storageKey `
  --share-name $fileShare `
  --name documents
15. Delete the File Share

If the lab requires cleanup:

az storage share-rm delete `
  --resource-group $resourceGroup `
  --storage-account $storageAccount `
  --name $fileShare

Confirm the deletion when prompted.

Do not execute this command until you are finished with the lab.

16. File Share Quota

The quota can be reviewed with:

az storage share-rm show `
  --resource-group $resourceGroup `
  --storage-account $storageAccount `
  --name $fileShare `
  --query "properties.shareQuota" `
  --output tsv
17. Storage Account Networking

Review the Storage Account network configuration:

az storage account show `
  --name $storageAccount `
  --resource-group $resourceGroup `
  --query "networkRuleSet" `
  --output json

This helps identify whether network restrictions are configured.

18. Storage Account Encryption

Review encryption configuration:

az storage account show `
  --name $storageAccount `
  --resource-group $resourceGroup `
  --query "encryption" `
  --output json

Encryption at rest protects stored data.

19. Storage Account HTTPS Configuration

Review whether secure transfer is required:

az storage account show `
  --name $storageAccount `
  --resource-group $resourceGroup `
  --query "enableHttpsTrafficOnly" `
  --output tsv

For secure environments, HTTPS/secure transfer should normally be enabled.

20. Authentication Concepts

Azure Files can use different authentication mechanisms depending on configuration.

Examples include:

Storage account keys
Microsoft Entra ID-based authentication
Active Directory Domain Services
Microsoft Entra Domain Services
Other supported identity-based configurations

Authentication establishes identity.

Authorization determines what that identity can access.

21. SMB Concepts

Azure Files commonly uses SMB for Windows-based file access.

Conceptually:

Windows Client
      |
      | SMB
      v
Azure File Share

SMB provides file and directory access over the network.

22. SMB Channel Encryption

SMB channel encryption protects SMB traffic while it is traveling between the client and the Azure file share.

Conceptually:

Client
  |
  | encrypted SMB traffic
  v
Azure Files

This protects data in transit.

23. Kerberos Concepts

Kerberos is a ticket-based authentication protocol used for supported identity-based SMB scenarios.

Conceptually:

User
 |
 v
Identity / Domain
 |
 | Kerberos ticket
 v
Client
 |
 | SMB authentication
 v
Azure Files

Kerberos is primarily associated with authentication.

Authorization is handled separately through permissions.

24. Useful Diagnostic Commands

Check Azure CLI authentication:

az account show

Check the Storage Account:

az storage account show `
  --name $storageAccount `
  --resource-group $resourceGroup

Check the file share:

az storage share-rm show `
  --resource-group $resourceGroup `
  --storage-account $storageAccount `
  --name $fileShare

List files:

az storage file list `
  --account-name $storageAccount `
  --account-key $storageKey `
  --share-name $fileShare `
  --output table
25. Cleanup

Remove the local test files created during the lab:

Remove-Item .\test.txt -ErrorAction SilentlyContinue
Remove-Item .\downloaded-test.txt -ErrorAction SilentlyContinue

If the Azure File Share is no longer required:

az storage share-rm delete `
  --resource-group $resourceGroup `
  --storage-account $storageAccount `
  --name $fileShare

Only remove the file share if it is not needed by another lab.

AZ-104 Command Summary

Important commands to remember:

az storage account list
az storage account show
az storage account keys list

az storage share-rm create
az storage share-rm list
az storage share-rm show
az storage share-rm delete

az storage directory create
az storage directory delete

az storage file list
az storage file upload
az storage file download
az storage file delete
Security Reminders

Never commit secrets to GitHub.

Do not place:

Storage account keys
Passwords
Connection strings
SAS tokens
Access tokens

inside:

README.md
notes.md
portal-steps.md
cli-commands.md

Use variables, Azure CLI authentication, managed identities, or secure secret-management mechanisms instead.

Lab Validation

Before considering the CLI portion complete:

 Azure CLI authentication verified
 Storage Account identified
 Storage Account key handling understood
 File Share created
 File Share listed
 File Share configuration inspected
 Directory created
 File uploaded
 File listed
 File downloaded
 File deleted
 Directory cleanup understood
 File Share cleanup understood
 Networking configuration reviewed
 Encryption configuration reviewed
 SMB concepts reviewed
 Kerberos concepts reviewed
 Secrets were not committed to GitHub