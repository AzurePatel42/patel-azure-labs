@'
# Notes — Azure Monitor & Log Analytics

## Module

**AZ-104 Monitoring Module 01 — Azure Monitor & Log Analytics**

## What I Learned

### Azure Monitor

Azure Monitor provides centralized monitoring for Azure resources through metrics, logs, diagnostic settings, alerts, and related monitoring capabilities.

### Log Analytics

A Log Analytics workspace provides a centralized destination for monitoring data and supports querying with Kusto Query Language (KQL).

Lab workspace:

`lawaz104mon01`

### Diagnostic Settings

Diagnostic settings control which resource logs and metrics are sent to a monitoring destination.

For this lab, the Storage Queue diagnostic setting was configured with:

**Logs**
- StorageRead
- StorageWrite
- StorageDelete

**Metrics**
- Capacity
- Transaction

Destination:

`lawaz104mon01`

## Important Troubleshooting Lesson

The initial query attempts did not immediately return the expected Storage Queue log records.

A broad query was used to identify which tables were receiving data:

```kusto
search *
| summarize Count=count() by $table
| order by Count desc

The workspace showed:

AzureMetrics
StorageQueueLogs
Usage

StorageQueueLogs contained the Storage Queue diagnostic records.

This demonstrated an important troubleshooting technique:

When a KQL query returns no results, first identify which tables are actually receiving data.

Metrics vs Logs

The lab demonstrated the difference between metrics and logs.

AzureMetrics contained metric records.

StorageQueueLogs contained detailed Storage Queue diagnostic log records.

Metrics are useful for numerical measurements such as transactions.

Logs provide more detailed operational information that can be analyzed using KQL.

KQL

Kusto Query Language was used to query Storage Queue logs.

Example:

StorageQueueLogs
| project TimeGenerated, OperationName, StatusCode
| order by TimeGenerated desc

A summary query was also used:

StorageQueueLogs
| summarize Count=count() by OperationName, StatusCode
| order by Count desc
HTTP Status Codes Observed

The lab produced records containing:

200
201
403

The important lesson is that monitoring data can contain both successful and unsuccessful operations.

A 403 record is useful monitoring evidence because it can indicate an authorization-related operation that should be investigated.

Diagnostic Pipeline

The completed monitoring flow was:

Storage Queue
      |
      v
Diagnostic Settings
      |
      v
Log Analytics Workspace
      |
      v
StorageQueueLogs
      |
      v
KQL
      |
      v
Operational Analysis
Azure CLI Lesson

PowerShell variables such as $queueServiceId exist only in the current PowerShell session.

After changing sessions or losing the variable, commands using:

--resource $queueServiceId

can fail with:

argument --resource: expected one argument

The solution is to recreate the variable:

$storageId = az storage account show `
  --name staz104mon01 `
  --resource-group rg-az104-monitoring-01 `
  --query id `
  --output tsv


$queueServiceId = "$storageId/queueServices/default"
Azure CLI Extension Lesson

The az monitor log-analytics query command required the Azure CLI log-analytics extension.

The environment reported that the installed extension was a preview version.

The command ultimately worked after the extension was installed.

Storage Queue CLI Lesson

The Azure CLI Storage Queue commands used in this lab are currently marked as preview/development commands.

Examples:

az storage queue create
az storage message put
az storage message get
az storage message delete
PowerShell Placeholder Lesson

Do not literally type placeholders such as:

<MESSAGE_ID>
<POP_RECEIPT>

into PowerShell.

PowerShell interprets < as syntax.

Instead, substitute the actual values returned by the queue message command.

Key Takeaway

The most important concept from this lab is not simply creating a Log Analytics workspace.

The important operational workflow is:

Configure → Generate Activity → Collect → Query → Analyze

Azure monitoring becomes useful when real resource activity is connected to diagnostic settings and then analyzed through logs and metrics.

Lab Status

Hands-on implementation: Complete

Evidence screenshots: 8 / 8 complete
