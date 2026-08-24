@'
# Portal Steps — Azure Monitor & Log Analytics

## 1. Open Azure Portal

Open the Azure Portal and verify the active subscription:

`patel-platform-service-template`

## 2. Create the Resource Group

Create:

`rg-az104-monitoring-01`

Region:

`East US`

## 3. Create the Log Analytics Workspace

Create:

`lawaz104mon01`

Place it in:

`rg-az104-monitoring-01`

Verify that the workspace provisioning state is `Succeeded`.

## 4. Create the Storage Account

Create:

`staz104mon01`

Configuration used:

- Performance: Standard
- Replication: LRS
- Kind: StorageV2
- Region: East US

## 5. Create the Storage Queue

Inside the storage account, create:

`az104-monitoring-queue`

Generate test activity by adding a test message.

## 6. Configure Diagnostic Settings

Configure diagnostic settings for the Storage Queue service.

Send the data to:

`lawaz104mon01`

Enable:

### Logs

- StorageRead
- StorageWrite
- StorageDelete

### Metrics

- Capacity
- Transaction

The diagnostic setting created during the lab was:

`diag-staz104mon01-queue`

## 7. Generate Monitoring Activity

Add a test message to the queue.

The lab generated real queue activity that produced monitoring records.

## 8. Open Log Analytics

Open:

`lawaz104mon01`

Select:

**Logs**

Use the query editor to query the workspace.

## 9. Query Storage Queue Logs

Run:

```kusto
StorageQueueLogs
| project TimeGenerated, OperationName, StatusCode
| order by TimeGenerated desc



Verify that queue activity is returned.

10. Analyze Queue Activity

Run:

StorageQueueLogs
| summarize Count=count() by OperationName, StatusCode
| order by Count desc

This provides an operational summary grouped by operation and status code.

11. Evidence Captured

The following screenshots document the lab:

01-log-analytics-workspace-created.png
02-diagnostic-settings-log-analytics.png
03-azure-monitor-metrics-transactions.png
04-diagnostic-setting-to-log-analytics.png
05-log-analytics-kql-query-results.png
06-diagnostic-setting-verification.png
07-storage-queue-log-query-verification.png
08-storage-queue-log-summary.png
Lab Result

The portal workflow successfully demonstrated: