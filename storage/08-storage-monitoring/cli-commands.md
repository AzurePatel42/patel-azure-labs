# Azure Storage Monitoring — CLI & KQL Reference

## Overview

This file contains Azure CLI commands and Kusto Query Language (KQL) queries used or relevant to the Storage Monitoring lab.

The lab primarily used the Azure Portal and Log Analytics for configuration and validation.

---

# 1. Azure CLI — Login

```bash
az login

List subscriptions:

az account list --output table

Select the lab subscription:

az account set --subscription "patel-platform-service-template"

Verify the current subscription:

az account show --output table
2. Resource Group

Show the resource group:

az group show \
  --name rg-ppst-storage-lab \
  --output table

List resources:

az resource list \
  --resource-group rg-ppst-storage-lab \
  --output table
3. Storage Account

Show the Storage Account:

az storage account show \
  --name stppstlab001 \
  --resource-group rg-ppst-storage-lab \
  --output table

List Storage Accounts:

az storage account list \
  --resource-group rg-ppst-storage-lab \
  --output table
4. Log Analytics Workspace

Show the workspace:

az monitor log-analytics workspace show \
  --resource-group rg-ppst-storage-lab \
  --workspace-name law-ppst-storage-lab \
  --output table

List Log Analytics workspaces:

az monitor log-analytics workspace list \
  --resource-group rg-ppst-storage-lab \
  --output table
5. Diagnostic Settings

List Storage Account diagnostic settings:

az monitor diagnostic-settings list \
  --resource "$(az storage account show \
    --name stppstlab001 \
    --resource-group rg-ppst-storage-lab \
    --query id \
    --output tsv)" \
  --output table

Show a specific diagnostic setting:

az monitor diagnostic-settings show \
  --name storage-monitoring-diagnostics \
  --resource "$(az storage account show \
    --name stppstlab001 \
    --resource-group rg-ppst-storage-lab \
    --query id \
    --output tsv)"
6. KQL — Discover Tables

Use this query in Log Analytics to discover tables containing data:

search *
| summarize Count = count() by $table
| order by Count desc

This is useful when the expected table is unknown.

7. KQL — Inspect Azure Metrics

Query the latest Azure metric records:

AzureMetrics
| order by TimeGenerated desc
| take 20
8. KQL — Count Metrics by Name
AzureMetrics
| summarize Count = count() by MetricName
| order by Count desc

This helps identify which metrics are being ingested.

9. KQL — Analyze Metric Values
AzureMetrics
| summarize
    Count = count(),
    AvgValue = avg(Average),
    MaxValue = max(Maximum)
    by MetricName
| order by MetricName asc

This converts raw metric samples into a summarized view.

10. KQL — Inspect Metric Records
AzureMetrics
| project
    TimeGenerated,
    MetricName,
    Average,
    Maximum,
    Total
| order by TimeGenerated desc
11. KQL — Check Blob Log Count
StorageBlobLogs
| summarize Count = count()

This determines whether Blob resource logs have been ingested.

12. KQL — Check Recent Blob Logs
StorageBlobLogs
| where TimeGenerated > ago(30m)
| summarize Count = count()

This focuses on recent Blob telemetry.

13. KQL — Inspect Blob Operations
StorageBlobLogs
| where TimeGenerated > ago(30m)
| project
    TimeGenerated,
    OperationName,
    StatusText,
    StatusCode,
    Uri
| order by TimeGenerated desc

This exposes details about recent Blob operations.

14. KQL — Summarize Blob Operations
StorageBlobLogs
| where TimeGenerated > ago(30m)
| summarize Count = count() by OperationName
| order by Count desc

This helps determine which operations occurred.

Examples may include operations corresponding to:

Read
Write
Delete
15. KQL — Search for Storage Telemetry

A broad search can be useful when troubleshooting:

search "stppstlab001"
| order by TimeGenerated desc

Use broad searches carefully in large production workspaces because they can scan significant amounts of data.

16. KQL Time Syntax

KQL uses compact duration notation.

Correct:

ago(1h)

Examples:

1m  = 1 minute
1h  = 1 hour
1d  = 1 day
7d  = 7 days

Incorrect:

ago(1 hour)
17. Useful KQL Operators
where

Filter records:

AzureMetrics
| where TimeGenerated > ago(1h)
project

Select columns:

AzureMetrics
| project TimeGenerated, MetricName, Average
summarize

Aggregate data:

AzureMetrics
| summarize Count = count() by MetricName
order by

Sort results:

AzureMetrics
| order by TimeGenerated desc
take

Limit the number of records:

AzureMetrics
| take 20
18. Troubleshooting Query Strategy

When a query returns no results, do not immediately conclude that telemetry is missing.

Start broadly:

search *
| summarize Count = count() by $table
| order by Count desc

Then identify the relevant table.

Next inspect the table:

AzureMetrics
| take 20

Then inspect the schema and available values.

Finally add filters.

General strategy:

Broad Query
    |
    v
Identify Table
    |
    v
Inspect Records
    |
    v
Understand Schema
    |
    v
Add Filters
    |
    v
Production Query
19. Metrics vs Resource Logs
Metrics
AzureMetrics

Used for numerical measurements such as:

Average
Maximum
Total
Transaction counts
Capacity
Performance measurements
Resource Logs
StorageBlobLogs

Used for detailed operations and events.

20. Azure CLI — Useful Discovery Commands

List resources:

az resource list \
  --resource-group rg-ppst-storage-lab \
  --output table

List storage accounts:

az storage account list \
  --output table

List Log Analytics workspaces:

az monitor log-analytics workspace list \
  --output table
21. Azure CLI — General Monitoring Workflow
az login
    |
    v
az account set
    |
    v
Identify Resource
    |
    v
Configure Diagnostic Settings
    |
    v
Send Telemetry
    |
    v
Log Analytics
    |
    v
KQL
22. Important Engineering Notes
No results does not always mean no data

A query can fail to return results because:

The time range is wrong.
The filter is too restrictive.
The resource ID format is different than expected.
The table is not the expected table.
Telemetry has not arrived yet.
Diagnostic settings are not configured.
The resource has not generated the expected activity.

Always investigate systematically.

Table exists does not mean data exists

Example:

StorageBlobLogs
     |
     +-- Table exists
     |
     +-- 0 records

After generating activity:

StorageBlobLogs
     |
     +-- Records available
23. Final Monitoring Query Set
Discover data
search *
| summarize Count = count() by $table
| order by Count desc
Metrics
AzureMetrics
| order by TimeGenerated desc
| take 20
Metric summary
AzureMetrics
| summarize Count = count() by MetricName
| order by Count desc
Blob log count
StorageBlobLogs
| where TimeGenerated > ago(30m)
| summarize Count = count()
Blob operations
StorageBlobLogs
| where TimeGenerated > ago(30m)
| summarize Count = count() by OperationName
| order by Count desc
Blob details
StorageBlobLogs
| where TimeGenerated > ago(30m)
| project
    TimeGenerated,
    OperationName,
    StatusText,
    StatusCode,
    Uri
| order by TimeGenerated desc
Final Principle

Use Azure CLI to automate and inspect infrastructure.

Use KQL to investigate telemetry.

Use Azure Monitor to observe health.

Use Diagnostic Settings to route telemetry.

Use Alerts and Action Groups to turn telemetry into operational action.

The complete workflow is:

Azure Resource
      |
      v
Diagnostic Settings
      |
      v
Metrics / Resource Logs
      |
      v
Log Analytics
      |
      v
KQL
      |
      v
Analysis
      |
      v
Alert
      |
      v
Action