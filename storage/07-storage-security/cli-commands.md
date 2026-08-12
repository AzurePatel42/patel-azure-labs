# Lab 07 — Azure Storage Security — CLI Commands

## 1. Purpose

This document contains Azure CLI commands relevant to Azure Storage security.

The commands demonstrate:

- Storage Account inspection
- Network configuration
- Firewall rules
- IP restrictions
- RBAC
- Storage encryption
- Access keys
- SAS concepts
- Secure configuration
- Security validation

> **Security warning:** Never commit Storage Account access keys, connection strings, passwords, or generated SAS tokens to GitHub.

---

# 2. Prerequisites

Azure CLI must be installed and authenticated.

Verify Azure CLI:

```powershell
az version
```

Sign in:

```powershell
az login
```

Verify the active account:

```powershell
az account show
```

List available subscriptions:

```powershell
az account list --output table
```

Select the required subscription:

```powershell
az account set --subscription "<SUBSCRIPTION_ID_OR_NAME>"
```

Verify:

```powershell
az account show --output table
```

---

# 3. Define Lab Variables

PowerShell variables can be used to make commands easier to reuse.

```powershell
$resourceGroup = "<RESOURCE_GROUP_NAME>"
$storageAccount = "<STORAGE_ACCOUNT_NAME>"
```

Example:

```powershell
$resourceGroup = "rg-storage-labs"
$storageAccount = "patelstorage001"
```

Do not commit real environment-specific secrets to the repository.

---

# 4. List Storage Accounts

List Storage Accounts:

```powershell
az storage account list --output table
```

List Storage Accounts in a resource group:

```powershell
az storage account list `
  --resource-group $resourceGroup `
  --output table
```

---

# 5. Show Storage Account

Display Storage Account properties:

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount
```

Display selected properties:

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query "{name:name,location:location,kind:kind,sku:sku.name,httpsOnly:enableHttpsTrafficOnly}" `
  --output table
```

---

# 6. Check HTTPS Requirement

Check whether secure transfer is enabled:

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query "enableHttpsTrafficOnly"
```

A secure configuration should normally return:

```text
true
```

---

# 7. Check Minimum TLS Version

Query the minimum TLS version:

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query "minimumTlsVersion"
```

A modern secure configuration should use an appropriate current TLS version.

---

# 8. Configure Secure Transfer

Enable secure transfer:

```powershell
az storage account update `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --https-only true
```

Verify:

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query "enableHttpsTrafficOnly"
```

Expected:

```text
true
```

---

# 9. Review Public Network Access

Display the Storage Account network configuration:

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query "{publicNetworkAccess:publicNetworkAccess,defaultAction:networkRuleSet.defaultAction,bypass:networkRuleSet.bypass}" `
  --output table
```

The important concepts are:

- Public network access
- Default network action
- Network bypass settings

---

# 10. Review Network Rule Set

Display network rules:

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query "networkRuleSet"
```

For easier reading:

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query "networkRuleSet.{defaultAction:defaultAction,bypass:bypass,ipRules:ipRules,virtualNetworkRules:virtualNetworkRules}" `
  --output json
```

---

# 11. Set Default Network Action

To restrict access by default:

```powershell
az storage account update `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --default-action Deny
```

Verify:

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query "networkRuleSet.defaultAction"
```

Expected:

```text
Deny
```

> Use this only when you understand the impact. Changing the default action can block legitimate access.

---

# 12. Allow an IP Address

Add an approved public IP address:

```powershell
az storage account network-rule add `
  --resource-group $resourceGroup `
  --account-name $storageAccount `
  --ip-address "<PUBLIC_IP_ADDRESS>"
```

Example:

```powershell
az storage account network-rule add `
  --resource-group $resourceGroup `
  --account-name $storageAccount `
  --ip-address "203.0.113.10"
```

The example IP above is documentation-only.

Use your actual authorized IP when performing the lab.

---

# 13. List IP Firewall Rules

```powershell
az storage account network-rule list `
  --resource-group $resourceGroup `
  --account-name $storageAccount
```

Display only IP rules:

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query "networkRuleSet.ipRules" `
  --output table
```

---

# 14. Remove an IP Rule

Remove an IP address from the firewall:

```powershell
az storage account network-rule remove `
  --resource-group $resourceGroup `
  --account-name $storageAccount `
  --ip-address "<PUBLIC_IP_ADDRESS>"
```

Verify:

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query "networkRuleSet.ipRules"
```

---

# 15. Virtual Network Rules

List virtual network rules:

```powershell
az storage account network-rule list `
  --resource-group $resourceGroup `
  --account-name $storageAccount `
  --query "virtualNetworkRules"
```

A virtual network rule can be added using:

```powershell
az storage account network-rule add `
  --resource-group $resourceGroup `
  --account-name $storageAccount `
  --vnet-name "<VNET_NAME>" `
  --subnet "<SUBNET_NAME>"
```

Example:

```powershell
az storage account network-rule add `
  --resource-group $resourceGroup `
  --account-name $storageAccount `
  --vnet-name "vnet-storage-lab" `
  --subnet "snet-storage"
```

Only use an existing authorized VNet/subnet.

---

# 16. Remove a Virtual Network Rule

```powershell
az storage account network-rule remove `
  --resource-group $resourceGroup `
  --account-name $storageAccount `
  --vnet-name "<VNET_NAME>" `
  --subnet "<SUBNET_NAME>"
```

---

# 17. Check Storage Account Encryption

Display encryption settings:

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query "encryption"
```

Display selected encryption properties:

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query "encryption.{keySource:keySource,services:services,infrastructureEncryption:requireInfrastructureEncryption}" `
  --output json
```

---

# 18. Check Encryption Key Source

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query "encryption.keySource"
```

For Microsoft-managed keys, the result should indicate the Microsoft-managed key source.

---

# 19. Check Infrastructure Encryption

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query "encryption.requireInfrastructureEncryption"
```

Possible result:

```text
false
```

or:

```text
true
```

The lab configuration was reviewed without enabling infrastructure encryption.

---

# 20. Check Blob Encryption

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query "encryption.services.blob"
```

---

# 21. Check File Encryption

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query "encryption.services.file"
```

---

# 22. Access Keys

Storage Account keys are sensitive.

To retrieve them through Azure CLI:

```powershell
az storage account keys list `
  --resource-group $resourceGroup `
  --account-name $storageAccount
```

### WARNING

Do not copy the output into:

- README files
- Notes
- GitHub
- Screenshots
- Chat
- Source code

If you only need to verify that keys exist, use:

```powershell
az storage account keys list `
  --resource-group $resourceGroup `
  --account-name $storageAccount `
  --query "[].{key:keyName}" `
  --output table
```

Expected output should identify:

```text
key1
key2
```

without exposing the actual values.

---

# 23. Rotate an Access Key

Rotate key1:

```powershell
az storage account keys renew `
  --resource-group $resourceGroup `
  --account-name $storageAccount `
  --key key1
```

Rotate key2:

```powershell
az storage account keys renew `
  --resource-group $resourceGroup `
  --account-name $storageAccount `
  --key key2
```

### Important

Do not rotate production keys unless you understand which applications depend on them.

The normal rotation pattern is:

```text
Application uses key1
        |
Rotate key2
        |
Update application to key2
        |
Rotate key1
```

---

# 24. Azure RBAC

List role assignments for the Storage Account:

```powershell
$storageId = az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query id `
  --output tsv
```

Then:

```powershell
az role assignment list `
  --scope $storageId `
  --output table
```

---

# 25. List Storage Data Roles

Search for Storage Blob Data Reader:

```powershell
az role definition list `
  --name "Storage Blob Data Reader" `
  --output table
```

Storage Blob Data Contributor:

```powershell
az role definition list `
  --name "Storage Blob Data Contributor" `
  --output table
```

Storage Blob Data Owner:

```powershell
az role definition list `
  --name "Storage Blob Data Owner" `
  --output table
```

---

# 26. View Role Definition

View the complete Storage Blob Data Reader role:

```powershell
az role definition list `
  --name "Storage Blob Data Reader"
```

This helps identify the permissions included in the role.

---

# 27. Assign Storage Blob Data Reader

If a lab or workload specifically requires assigning the role:

```powershell
az role assignment create `
  --assignee "<USER_OR_SERVICE_PRINCIPAL_ID>" `
  --role "Storage Blob Data Reader" `
  --scope $storageId
```

Do not execute this command unless the identity and scope are intentional.

Least privilege should always be applied.

---

# 28. Remove a Role Assignment

```powershell
az role assignment delete `
  --assignee "<USER_OR_SERVICE_PRINCIPAL_ID>" `
  --role "Storage Blob Data Reader" `
  --scope $storageId
```

Use this only for assignments that were intentionally created for the lab.

---

# 29. Check Current User

Show the signed-in Azure account:

```powershell
az account show --output table
```

Retrieve the current user's information:

```powershell
az ad signed-in-user show
```

Depending on the Azure CLI environment and permissions, this command may not be available or may require additional Microsoft Entra permissions.

---

# 30. Storage Account SAS — Concept

SAS tokens provide delegated access.

A SAS can restrict:

- Service
- Resource type
- Permissions
- Start time
- Expiry time
- IP address
- Protocol

The generated SAS token is a secret.

Never commit it to Git.

---

# 31. Generate Account SAS — Example

Azure CLI can generate an Account SAS.

Example:

```powershell
az storage account generate-sas `
  --account-name $storageAccount `
  --services b `
  --resource-types sco `
  --permissions rwl `
  --expiry "2026-12-31T23:59:59Z" `
  --https-only `
  --output tsv
```

The generated value is sensitive.

Do not paste the resulting token into:

- README
- Notes
- GitHub
- Screenshots
- Chat

If this command is used during experimentation, treat the SAS as compromised if it is accidentally exposed and revoke/replace access as appropriate.

---

# 32. SAS with IP Restriction

A SAS can include an IP restriction.

Conceptually:

```powershell
az storage account generate-sas `
  --account-name $storageAccount `
  --services b `
  --resource-types sco `
  --permissions rwl `
  --expiry "2026-12-31T23:59:59Z" `
  --https-only `
  --ip "<AUTHORIZED_PUBLIC_IP>"
```

Use only an IP address that you control and intend to authorize.

---

# 33. SAS Security Principles

When creating SAS:

```text
Minimum scope
      +
Minimum permissions
      +
Minimum lifetime
      +
HTTPS
      +
Optional IP restriction
      =
Better delegated security
```

SAS should be used carefully because possession of a valid token can grant the encoded permissions.

---

# 34. Anonymous Blob Access

Check whether anonymous blob access is allowed at the Storage Account level:

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query "allowBlobPublicAccess"
```

For secure environments, anonymous access should normally be disabled unless there is an explicit requirement.

---

# 35. Disable Anonymous Blob Access

If the workload does not require anonymous access:

```powershell
az storage account update `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --allow-blob-public-access false
```

Verify:

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query "allowBlobPublicAccess"
```

Expected:

```text
false
```

Only make this change if it will not break an existing workload.

---

# 36. Storage Account Properties for Security Review

A useful security inspection command:

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query "{name:name,httpsOnly:enableHttpsTrafficOnly,tls:minimumTlsVersion,publicNetworkAccess:publicNetworkAccess,anonymousBlobAccess:allowBlobPublicAccess,defaultNetworkAction:networkRuleSet.defaultAction}" `
  --output table
```

This provides a quick security overview.

---

# 37. Network Security Review

Display the major network settings:

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query "{publicNetworkAccess:publicNetworkAccess,defaultAction:networkRuleSet.defaultAction,ipRules:networkRuleSet.ipRules,virtualNetworkRules:networkRuleSet.virtualNetworkRules}" `
  --output json
```

---

# 38. Encryption Security Review

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query "{keySource:encryption.keySource,infrastructureEncryption:encryption.requireInfrastructureEncryption,blobEncryption:encryption.services.blob,fileEncryption:encryption.services.file}" `
  --output json
```

---

# 39. Secure Configuration Review

Run:

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query "{httpsOnly:enableHttpsTrafficOnly,tls:minimumTlsVersion,publicAccess:allowBlobPublicAccess,networkAccess:publicNetworkAccess}" `
  --output table
```

Review the results against the lab's security objectives.

---

# 40. Storage Account Diagnostic Commands

Get the resource ID:

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query id `
  --output tsv
```

Get the location:

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query location `
  --output tsv
```

Get the SKU:

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query sku.name `
  --output tsv
```

---

# 41. Useful Output Formats

Table:

```powershell
--output table
```

JSON:

```powershell
--output json
```

TSV:

```powershell
--output tsv
```

Example:

```powershell
az storage account list --output table
```

---

# 42. Security Validation Checklist

Use these commands to validate the Storage Account.

### HTTPS

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query "enableHttpsTrafficOnly"
```

### TLS

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query "minimumTlsVersion"
```

### Network

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query "networkRuleSet"
```

### Encryption

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query "encryption"
```

### Anonymous access

```powershell
az storage account show `
  --resource-group $resourceGroup `
  --name $storageAccount `
  --query "allowBlobPublicAccess"
```

### RBAC

```powershell
az role assignment list `
  --scope $storageId `
  --output table
```

---

# 43. Security Command Summary

| Security Area | Azure CLI |
|---|---|
| Storage Account | `az storage account show` |
| HTTPS | `az storage account update --https-only true` |
| TLS | `az storage account show --query minimumTlsVersion` |
| Network Rules | `az storage account network-rule list` |
| Add IP | `az storage account network-rule add` |
| Remove IP | `az storage account network-rule remove` |
| Access Keys | `az storage account keys list` |
| Key Rotation | `az storage account keys renew` |
| RBAC | `az role assignment list` |
| Data Roles | `az role definition list` |
| Encryption | `az storage account show --query encryption` |
| Anonymous Access | `az storage account show --query allowBlobPublicAccess` |
| SAS | `az storage account generate-sas` |

---

# 44. Important Security Warning

Never commit these values to GitHub:

```text
Storage Account access keys
Connection strings
SAS tokens
Passwords
Client secrets
Private keys
Certificates containing private material
```

If a secret is accidentally committed:

1. Treat it as compromised.
2. Rotate or revoke it.
3. Remove it from active configuration.
4. Review repository history if necessary.
5. Replace it with secure secret management.

---

# 45. Solution Architect CLI Perspective

Azure CLI is useful for automation and repeatable infrastructure operations.

A solution architect should understand not only the command syntax but also what the command changes.

For example:

```powershell
az storage account update --https-only true
```

is not merely a CLI command.

It represents the architectural security decision:

> Require secure transport for Storage Account requests.

Similarly:

```powershell
az storage account network-rule add
```

represents:

> Restrict network access to an explicitly approved source.

And:

```powershell
az role assignment create
```

represents:

> Grant a specific identity a specific authorization scope.

The command is the implementation.

The security decision is the architecture.

---

# 46. Final Lab Command Review

Before completing Lab 07, understand these command groups:

```text
Azure Account
     |
     +---- az login
     +---- az account show
     +---- az account set

Storage Account
     |
     +---- az storage account show
     +---- az storage account update

Network Security
     |
     +---- az storage account network-rule list
     +---- az storage account network-rule add
     +---- az storage account network-rule remove

Identity / RBAC
     |
     +---- az role assignment list
     +---- az role assignment create
     +---- az role assignment delete
     +---- az role definition list

Encryption
     |
     +---- az storage account show --query encryption

Access Keys
     |
     +---- az storage account keys list
     +---- az storage account keys renew

SAS
     |
     +---- az storage account generate-sas
```

---

# 47. Lab Completion

Lab 07 CLI work demonstrates that Azure Storage security can be inspected and managed programmatically.

The major security principles demonstrated are:

- Network restriction
- Secure transport
- Encryption at rest
- Identity-based authorization
- Least privilege
- Credential rotation
- Delegated access
- Defense in depth

The most important lesson is:

> **CLI commands implement security architecture decisions; they do not replace the need to understand those decisions.**