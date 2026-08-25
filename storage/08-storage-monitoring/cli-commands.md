# Azure Storage Monitoring - CLI Commands

## Overview

This document contains the Azure CLI commands used to configure and validate monitoring for the Azure Storage Account used in Lab 08.

---

## Lab Environment

```text
Subscription:
patel-platform-service-template

Resource Group:
rg-az104-storage-01

Storage Account:
staz104az01

Log Analytics Workspace:
lawaz104mon01

Monitoring Resource Group:
rg-az104-monitoring-01


1. Verify Azure CLI
az version
2. Verify Azure Subscription
az account show `
  --query "{User:user.name,Subscription:id,SubscriptionName:name}" `
  --output table
3. Set Lab Variables
$resourceGroup = "rg-az104-storage-01"
$storageAccount = "staz104az01"
4. Verify Resource Group
az group show `
  --name $resourceGroup `
  --query "{Name:name,Location:location,ProvisioningState:properties.provisioningState}" `
  --output table

Expected:

Name                 Location    ProvisioningState
-------------------  ----------  -------------------
rg-az104-storage-01  eastus      Succeeded
5. Verify Storage Account
az storage account show `
  --name $storageAccount `
  --resource-group $resourceGroup `
  --query "{Name:name,Location:location,Kind:kind,SKU:sku.name}" `
  --output table

Expected:

Name         Location    Kind       SKU
-----------  ----------  ---------  ------------
staz104az01  eastus      StorageV2  Standard_LRS
6. Get Storage Account Resource ID
$storageId = az storage account show `
  --name $storageAccount `
  --resource-group $resourceGroup `
  --query id `
  --output tsv

Verify:

$storageId

Expected format:

/subscriptions/<subscription-id>/resourceGroups/rg-az104-storage-01/providers/Microsoft.Storage/storageAccounts/staz104az01
7. Verify Log Analytics Workspace
az monitor log-analytics workspace show `
  --resource-group rg-az104-monitoring-01 `
  --workspace-name lawaz104mon01 `
  --query "{Name:name,Location:location,Retention:retentionInDays,State:provisioningState}" `
  --output table

Expected:

Name           Location    Retention    State
-------------  ----------  -----------  ---------
lawaz104mon01  eastus      30           Succeeded
8. Get Workspace Resource ID
$workspaceId = az monitor log-analytics workspace show `
  --resource-group rg-az104-monitoring-01 `
  --workspace-name lawaz104mon01 `
  --query id `
  --output tsv

Verify:

$workspaceId
9. Check Existing Diagnostic Settings
az monitor diagnostic-settings list `
  --resource $storageId `
  --output json

If no settings are configured, the result is:

[]
10. Discover Diagnostic Categories
az monitor diagnostic-settings categories list `
  --resource $storageId `
  --output json

The lab environment returned:

Capacity
Transaction

Both categories were reported as metrics.

11. Create Diagnostic Setting
az monitor diagnostic-settings create `
  --name "diag-staz104az01" `
  --resource $storageId `
  --workspace $workspaceId `
  --metrics '[{"category":"Capacity","enabled":true},{"category":"Transaction","enabled":true}]'

The diagnostic setting sends the selected metrics to:

lawaz104mon01
12. Verify Diagnostic Setting
az monitor diagnostic-settings list `
  --resource $storageId `
  --output table

Expected:

Name
-----------------
diag-staz104az01
13. Show Diagnostic Setting
az monitor diagnostic-settings show `
  --resource $storageId `
  --name "diag-staz104az01" `
  --output json

Expected metric categories:

Capacity
Transaction

Important:

logs: []

The current lab configuration enables Storage metrics but does not enable Storage resource logs.

14. Query Transactions Metric
az monitor metrics list `
  --resource $storageId `
  --metric Transactions `
  --interval PT1M `
  --aggregation Total `
  --output table

Example:

Timestamp             Name          Total
--------------------  ------------  -------
2026-08-25T02:42:00Z  Transactions  0.0

A value of 0.0 is valid telemetry and indicates no transactions occurred during that period.

15. Discover Valid Storage Metrics

If a metric query fails, Azure can report the available metrics.

The lab environment reported:

UsedCapacity
Transactions
Ingress
Egress
SuccessServerLatency
SuccessE2ELatency
Availability
ReplicationLagSeconds
MigrationProgress
16. Query Used Capacity

The UsedCapacity metric does not support a one-minute time grain.

Use:

az monitor metrics list `
  --resource $storageId `
  --metric UsedCapacity `
  --interval PT1H `
  --aggregation Average `
  --output table

Successful validation returned:

Timestamp             Name           Average
--------------------  -------------  ---------
2026-08-25T01:45:00Z  Used capacity  1447.0
17. Check Existing Metric Alerts
az monitor metrics alert list `
  --resource-group $resourceGroup `
  --output table
18. Create Transaction Metric Alert
az monitor metrics alert create `
  --name "alert-staz104az01-transactions" `
  --resource-group $resourceGroup `
  --scopes $storageId `
  --condition "total Transactions > 10" `
  --window-size 5m `
  --evaluation-frequency 1m `
  --severity 2 `
  --description "Monitor storage transaction activity on staz104az01"

Configuration:

Metric:
Transactions

Aggregation:
Total

Condition:
Transactions > 10

Window:
5 minutes

Evaluation Frequency:
1 minute

Severity:
2
19. Verify Metric Alert
az monitor metrics alert list `
  --resource-group $resourceGroup `
  --output table

Expected:

Name
------------------------------
alert-staz104az01-transactions
20. Show Metric Alert
az monitor metrics alert show `
  --resource-group $resourceGroup `
  --name "alert-staz104az01-transactions" `
  --output json
21. Concise Alert Validation
az monitor metrics alert show `
  --resource-group $resourceGroup `
  --name "alert-staz104az01-transactions" `
  --query "{Name:name,Enabled:enabled,Metric:criteria.allOf[0].metricName,Operator:criteria.allOf[0].operator,Threshold:criteria.allOf[0].threshold,Window:windowSize,Frequency:evaluationFrequency,Severity:severity}" `
  --output table

Expected values:

Metric:
Transactions

Operator:
GreaterThan

Threshold:
10

Window:
PT5M

Frequency:
PT1M

Severity:
2
22. Validate Storage Metrics in Log Analytics

The metric data was successfully found in:

AzureMetrics

This confirms that metric telemetry is available in the monitoring workspace.

The current diagnostic configuration is metric-based.

23. Validate Transactions
az monitor metrics list `
  --resource $storageId `
  --metric Transactions `
  --interval PT1M `
  --aggregation Total `
  --output table

Review the returned timestamps and values.

24. Validate Used Capacity
az monitor metrics list `
  --resource $storageId `
  --metric UsedCapacity `
  --interval PT1H `
  --aggregation Average `
  --output table
25. Final Diagnostic Validation
az monitor diagnostic-settings show `
  --resource $storageId `
  --name "diag-staz104az01" `
  --output json

Confirm:

Capacity       enabled
Transaction    enabled
26. Final Alert Validation
az monitor metrics alert show `
  --resource-group $resourceGroup `
  --name "alert-staz104az01-transactions" `
  --query "{Name:name,Enabled:enabled,Metric:criteria.allOf[0].metricName,Operator:criteria.allOf[0].operator,Threshold:criteria.allOf[0].threshold,Window:windowSize,Frequency:evaluationFrequency,Severity:severity}" `
  --output table
27. Screenshot Validation
Get-ChildItem .\screenshots -File |
    Sort-Object Name |
    Select-Object Name,Length

Expected:

01-diagnostic-settings-configured.png
02-storage-alert-created.png
03-storage-metrics-validation.png
04-final-storage-monitoring-validation.png
28. Documentation Validation

Check for encoding corruption:

Select-String `
  -Path .\README.md,.\cli-commands.md,.\portal-steps.md,.\notes.md `

Expected result:

No output
29. Git Validation

From the Storage repository root:

git diff --check

Review Module 08 changes:

git diff --stat

Check working tree:

git status --short
30. Stage Module 08

From:

C:\patel-azure-labs\storage

run:

git add 08-storage-monitoring

Review:

git status

Review staged statistics:

git diff --cached --stat

Check staged whitespace:

git diff --cached --check
Key CLI Lessons
Verify the resource before configuring monitoring.
Discover diagnostic categories before creating Diagnostic Settings.
Discover valid metric names instead of guessing.
Metric category names and metric names may differ.
Different metrics can support different time grains.
Validate actual metric datapoints.
Validate alerts after creation.
Metrics and resource logs are different telemetry types.
Document only telemetry that was actually configured and verified.
Use Git validation before committing the completed lab.