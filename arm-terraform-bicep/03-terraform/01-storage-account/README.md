# Terraform Storage Account Lab

## Objective

Build and deploy an Azure Storage Account using Terraform and the AzureRM provider.

This lab follows the complete Infrastructure as Code lifecycle:

**Theory → Build → Validate → Plan → Deploy → Verify → Intentional Failure → Debug → Fix → Document**

The goal is to understand how Terraform configuration, Terraform state, Azure infrastructure, and the AzureRM provider work together.

---

## Resource Created

### Azure Resource

* **Resource Type:** Azure Storage Account
* **Resource Group:** `rg-az104-terraform-01`
* **Storage Account:** `patelterraformstorage001`
* **Location:** `East US`
* **Kind:** `StorageV2`
* **Account Tier:** `Standard`
* **Replication:** `LRS`

### Terraform Resource

```hcl
resource "azurerm_storage_account" "az104" {
  name                     = "patelterraformstorage001"
  resource_group_name      = azurerm_resource_group.az104.name
  location                 = "eastus"
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```

---

## Terraform Provider

The lab uses the AzureRM provider.

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```

The installed provider version during this lab was:

`4.81.0`

---

## Resource Group Dependency

The Storage Account uses the Terraform-managed Resource Group:

```hcl
resource "azurerm_resource_group" "az104" {
  name     = "rg-az104-terraform-01"
  location = "East US"
}
```

The Storage Account references the Resource Group dynamically:

```hcl
resource_group_name = azurerm_resource_group.az104.name
```

This demonstrates a Terraform resource dependency.

---

# Terraform Lifecycle

## 1. Build

Created the Terraform configuration in:

```text
C:\patel-azure-labs\arm-terraform-bicep\terraform
```

Files include:

```text
provider.tf
main.tf
terraform.tfstate
.terraform.lock.hcl
```

---

## 2. Initialize

Terraform was initialized with the AzureRM provider.

The AzureRM provider was installed successfully.

---

## 3. Validate

Command:

```powershell
terraform validate
```

Result:

```text
Success! The configuration is valid.
```

This confirmed that Terraform could parse the configuration and that the provider recognized the resource arguments.

---

## 4. Plan

Command:

```powershell
terraform plan
```

Terraform determined:

```text
Plan: 1 to add, 0 to change, 0 to destroy.
```

The Resource Group already existed in Terraform state.

The Storage Account was identified as the resource that needed to be created.

---

## 5. Apply

Command:

```powershell
terraform apply
```

Terraform created:

```text
patelterraformstorage001
```

Result:

```text
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

---

# State Verification

Command:

```powershell
terraform state list
```

Result included:

```text
azurerm_resource_group.az104
azurerm_storage_account.az104
```

The Storage Account was then inspected with:

```powershell
terraform state show azurerm_storage_account.az104
```

Terraform state confirmed:

```text
name                     = "patelterraformstorage001"
location                 = "eastus"
account_kind             = "StorageV2"
account_tier             = "Standard"
account_replication_type = "LRS"
```

Azure-generated endpoints were also recorded in state.

Sensitive values such as access keys and connection strings were displayed as:

```text
(sensitive value)
```

---

# Configuration Synchronization Test

After deployment, Terraform was run again:

```powershell
terraform plan
```

Result:

```text
No changes. Your infrastructure matches the configuration.
```

This demonstrated that the Terraform configuration, Terraform state, and real Azure infrastructure were synchronized.

---

# Intentional Failure Lab

The configuration was deliberately changed from:

```hcl
account_replication_type = "LRS"
```

to:

```hcl
account_replication_type = "INVALID"
```

Then:

```powershell
terraform plan
```

was executed.

Terraform returned:

```text
Error: expected account_replication_type to be one of
["LRS" "ZRS" "GRS" "RAGRS" "GZRS" "RAGZRS"], got INVALID
```

Terraform also identified the exact configuration location:

```text
main.tf line 11
```

### What happened?

Terraform did not modify Azure.

The AzureRM provider rejected the invalid configuration value during planning.

This demonstrated that:

**`terraform plan` can fail before Terraform generates an executable infrastructure change.**

---

# Failure Recovery

The invalid value was changed back to:

```hcl
account_replication_type = "LRS"
```

Terraform was then run again:

```powershell
terraform plan
```

Result:

```text
No changes. Your infrastructure matches the configuration.
```

The configuration was successfully restored without making any changes to the Azure Storage Account.

---

# Important Terraform Concepts Learned

## Configuration

Terraform configuration describes the desired infrastructure.

Example:

```hcl
account_tier = "Standard"
```

---

## State

Terraform state records information about resources Terraform manages.

Example:

```text
azurerm_storage_account.az104
```

State allows Terraform to understand the relationship between configuration and real infrastructure.

---

## Plan

`terraform plan` compares the desired configuration with the current infrastructure/state and shows the changes Terraform intends to make.

---

## Apply

`terraform apply` executes the changes identified by Terraform.

---

## Provider

The AzureRM provider acts as the connection between Terraform and Azure.

It understands Azure resource types and their required configuration.

---

## State Locking

Terraform acquired a state lock during the intentional failure test.

State locking helps prevent multiple Terraform operations from modifying the same state simultaneously.

---

## Sensitive State

Terraform state can contain sensitive infrastructure information such as:

* Storage Account access keys
* Connection strings
* Other provider-generated credentials or values

Therefore, `terraform.tfstate` should not be casually committed to a public Git repository.

---

# Architecture

```text
                    Terraform Configuration
                           main.tf
                              │
                              ▼
                     ┌─────────────────┐
                     │    Terraform    │
                     │     Engine      │
                     └────────┬────────┘
                              │
                       AzureRM Provider
                              │
                              ▼
                     ┌─────────────────┐
                     │      Azure      │
                     │                 │
                     │ Resource Group  │
                     │       │         │
                     │       ▼         │
                     │ Storage Account │
                     └─────────────────┘
                              ▲
                              │
                     Terraform State
                       terraform.tfstate
```

---

# ARM vs Bicep vs Terraform

The same Storage Account resource was implemented using three Infrastructure as Code approaches.

| Technology | Primary Concept                                      |
| ---------- | ---------------------------------------------------- |
| ARM        | Native Azure declarative IaC using JSON              |
| Bicep      | Azure-native declarative IaC with simpler syntax     |
| Terraform  | Provider-based declarative IaC with state management |

### ARM

ARM templates directly describe Azure resource deployments using JSON.

### Bicep

Bicep provides a cleaner Azure-native language that compiles to ARM templates.

### Terraform

Terraform uses providers such as AzureRM to manage infrastructure and maintains state describing resources under Terraform management.

---

# AZ-104 Connection

This lab reinforces several AZ-104 concepts:

* Azure Storage Accounts
* Storage Account types
* StorageV2
* Standard performance tier
* LRS replication
* Resource Groups
* Azure regions
* Infrastructure as Code
* Resource dependencies
* Infrastructure validation
* Infrastructure deployment
* Troubleshooting deployment failures

---

# Troubleshooting Model

The intentional failure reinforced the following troubleshooting sequence:

```text
Configuration
      ↓
Terraform Validate
      ↓
Terraform Plan
      ↓
Provider Validation
      ↓
Terraform Apply
      ↓
Azure
```

When a configuration value is invalid, Terraform/provider validation can stop the operation before Azure is modified.

---

# Key Learning

The most important lesson from this lab:

> Terraform does not simply create Azure resources. It maintains a desired configuration, tracks managed infrastructure through state, compares that information with real infrastructure, and determines what changes are required.

The complete workflow practiced in this lab was:

```text
Build
  ↓
Validate
  ↓
Plan
  ↓
Apply
  ↓
Verify
  ↓
Intentional Failure
  ↓
Debug
  ↓
Fix
  ↓
Recovery Plan
```

---

# Lab Status

**Terraform Storage Account Lab: COMPLETE**

* Configuration: Complete
* Validation: Complete
* Planning: Complete
* Deployment: Complete
* State verification: Complete
* Synchronization verification: Complete
* Intentional failure: Complete
* Troubleshooting: Complete
* Recovery: Complete
* Documentation: Complete

Next step: Git commit and push.
