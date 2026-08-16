# Azure Storage Monitoring — Azure Portal Steps

## Lab Environment

### Subscription

`patel-platform-service-template`

### Resource Group

`rg-ppst-storage-lab`

### Storage Account

`stppstlab001`

### Log Analytics Workspace

`law-ppst-storage-lab`

Region:

`Central US`

---

# Part 1 — Create the Log Analytics Workspace

## Step 1 — Open Azure Portal

Open the Azure Portal and search for:

`Log Analytics workspaces`

---

## Step 2 — Create Workspace

Select:

`Create`

Configure:

| Setting | Value |
|---|---|
| Subscription | `patel-platform-service-template` |
| Resource Group | `rg-ppst-storage-lab` |
| Name | `law-ppst-storage-lab` |
| Region | `Central US` |
| Pricing Tier | Pay-as-you-go |

Select:

`Review + Create`

Then:

`Create`

---

## Step 3 — Verify Deployment

Confirm that the deployment succeeds.

Open:

`law-ppst-storage-lab`

Verify:

- Status: Active
- Location: Central US
- Pricing tier: Pay-as-you-go

---

# Part 2 — Configure Storage Account Metrics

## Step 1 — Open Storage Account

Open:

`stppstlab001`

Navigate to:

`Monitoring → Diagnostic settings`

---

## Step 2 — Add Diagnostic Setting

Select:

`Add diagnostic setting`

Diagnostic setting name:

`storage-monitoring-diagnostics`

---

## Step 3 — Configure Metrics

Select:

`Transaction`

---

## Step 4 — Configure Destination

Enable:

`Send to Log Analytics workspace`

Configure:

| Setting | Value |
|---|---|
| Subscription | `patel-platform-service-template` |
| Log Analytics Workspace | `law-ppst-storage-lab` |

Save the diagnostic setting.

---

# Part 3 — Verify Storage Metrics

## Step 1 — Open Log Analytics

Open:

`law-ppst-storage-lab`

Navigate to:

`Logs`

---

## Step 2 — Discover Tables

Run:

```kusto
search *
| summarize Count = count() by $table
| order by Count desc


Step 3 — Inspect Azure Metrics

Run:

AzureMetrics
| order by TimeGenerated desc
| take 20
Step 4 — Summarize Metrics

Run:

AzureMetrics
| summarize Count = count() by MetricName
| order by Count desc
Step 5 — Analyze Metric Values

Run:

AzureMetrics
| summarize
    Count = count(),
    AvgValue = avg(Average),
    MaxValue = max(Maximum)
    by MetricName
| order by MetricName asc

This confirms that metric values can be analyzed in Log Analytics.

Part 4 — Configure Blob Resource Logs
Step 1 — Open Blob Service Diagnostic Settings

From:

stppstlab001

Navigate to the Blob service diagnostic settings.

The diagnostic setting applies to:

microsoft.storage/storageaccounts/blobservices

Step 2 — Create Diagnostic Setting

Diagnostic setting name:

blob-monitoring-diagnostics

Step 3 — Enable Blob Logs

Select the following categories:

Storage Read
Storage Write
Storage Delete
Step 4 — Enable Blob Metrics

Select:

Transaction

Step 5 — Configure Destination

Enable:

Send to Log Analytics workspace

Select:

law-ppst-storage-lab

Save the diagnostic setting.

Part 5 — Verify StorageBlobLogs
Step 1 — Check the Table

Open:

law-ppst-storage-lab → Tables

Verify that:

StorageBlobLogs

is available.

Step 2 — Check for Existing Records

Run:

StorageBlobLogs
| summarize Count = count()

Initially, the table contained:

0 records

This demonstrated that table existence does not necessarily mean that telemetry is being ingested.

Part 6 — Generate Blob Activity

Open:

stppstlab001 → Containers

Perform actual Blob operations.

Operation 1 — Write

Upload a small test file.

Expected diagnostic event:

Storage Write

Operation 2 — Read

Open or download the Blob.

Expected diagnostic event:

Storage Read

Operation 3 — Delete

Delete the test Blob.

Expected diagnostic event:

Storage Delete

Part 7 — Validate Blob Logs

Wait several minutes for telemetry ingestion.

Open:

law-ppst-storage-lab → Logs

Run:

StorageBlobLogs
| where TimeGenerated > ago(30m)
| summarize Count = count()

A record was successfully returned during the lab.

This confirmed that Blob resource logging was working.

Inspect Blob Operations

Run:

StorageBlobLogs
| where TimeGenerated > ago(30m)
| project TimeGenerated, OperationName, StatusText, StatusCode, Uri
| order by TimeGenerated desc

This exposes details about the recorded Blob operation.

Part 8 — Understand the Telemetry Pipeline
Storage Metrics
Storage Account
      |
      v
Diagnostic Setting
      |
      v
Transaction Metric
      |
      v
Log Analytics
      |
      v
AzureMetrics
      |
      v
KQL
Blob Resource Logs
Blob Operation
      |
      v
Diagnostic Setting
      |
      v
Storage Read / Write / Delete
      |
      v
Log Analytics
      |
      v
StorageBlobLogs
      |
      v
KQL
Part 9 — Monitoring and Alerting

The monitoring architecture extends beyond telemetry collection.

Resource
   |
   v
Metrics / Logs
   |
   v
Azure Monitor
   |
   v
Condition
   |
   v
Alert Rule
   |
   v
Action Group
   |
   v
Notification

An alert rule detects a condition.

An Action Group defines what happens when the alert fires.

Part 10 — Troubleshooting Exercise
Initial Problem

An initial query returned:

No results found from the specified time range

The first query was:

AzureMetrics
| where TimeGenerated > ago(1h)
| where ResourceId contains "stppstlab001"
| order by TimeGenerated desc

The query returned no records.

Troubleshooting Approach

Instead of assuming that telemetry ingestion was broken, the query was broadened:

search *
| summarize Count = count() by $table
| order by Count desc

The results showed that:

AzureMetrics

contained telemetry.

This demonstrated that the problem was related to the query/filter assumptions rather than the Log Analytics ingestion pipeline.

Part 11 — Blob Log Troubleshooting

The StorageBlobLogs table existed but initially returned:

0 records

The Blob diagnostic configuration was then verified.

The following categories were enabled:

Storage Read
Storage Write
Storage Delete

Blob activity was generated manually.

After ingestion, the query:

StorageBlobLogs
| where TimeGenerated > ago(30m)
| summarize Count = count()

returned a record.

This proved that the resource log pipeline was operational.

Part 12 — Key Portal Locations
Storage Account

stppstlab001

Important sections:

Monitoring
Metrics
Alerts
Diagnostic settings
Logs
Containers
Log Analytics Workspace

law-ppst-storage-lab

Important sections:

Logs
Tables
Alerts
Metrics
Usage and estimated costs
Diagnostic settings
Part 13 — Final Validation Checklist
Log Analytics
 Workspace created
 Workspace active
 Central US region
 Pay-as-you-go pricing
Storage Metrics
 Diagnostic setting created
 Transaction metric enabled
 Log Analytics destination configured
 AzureMetrics table contains data
 KQL queries validated
Blob Logs
 Blob diagnostic setting created
 Storage Read enabled
 Storage Write enabled
 Storage Delete enabled
 Log Analytics destination configured
 StorageBlobLogs table available
 Blob activity generated
 StorageBlobLogs records validated
Monitoring
 Metrics understood
 Resource logs understood
 Diagnostic Settings understood
 Log Analytics understood
 KQL understood
 Alerting architecture understood
 Action Groups understood
 Telemetry troubleshooting completed
Final Result

The Azure Storage monitoring environment was successfully configured and validated.

The lab demonstrated an end-to-end monitoring workflow:

Azure Resource
      |
      v
Telemetry
      |
      v
Diagnostic Settings
      |
      v
Log Analytics
      |
      v
KQL
      |
      v
Monitoring
      |
      v
Alert
      |
      v
Action