# Azure Storage Monitoring

## Overview

This lab demonstrates how to implement production-oriented monitoring for an Azure Storage Account using Azure Monitor, Diagnostic Settings, Log Analytics, KQL, metrics, resource logs, alerts, and Action Groups.

The lab uses the following Azure resources:

- Storage Account: `stppstlab001`
- Resource Group: `rg-ppst-storage-lab`
- Log Analytics Workspace: `law-ppst-storage-lab`
- Subscription: `patel-platform-service-template`

---

## Objectives

- Create and configure an Azure Log Analytics Workspace.
- Configure Storage Account diagnostic settings.
- Send Storage metrics to Log Analytics.
- Validate telemetry using KQL.
- Configure Blob service resource logs.
- Capture Storage Read, Write, and Delete operations.
- Query Blob resource logs using KQL.
- Understand the difference between metrics and logs.
- Configure Azure Monitor alerts and Action Groups.
- Troubleshoot telemetry ingestion using evidence.

---

## Architecture

```text
                    Azure Storage Account
                         stppstlab001
                              |
                    Diagnostic Settings
                              |
              +---------------+---------------+
              |                               |
              v                               v
          Metrics                          Blob Logs
              |                               |
       Transaction                    Read / Write / Delete
              |                               |
              v                               v
        AzureMetrics                  StorageBlobLogs
              |                               |
              +---------------+---------------+
                              |
                              v
                  Log Analytics Workspace
                    law-ppst-storage-lab
                              |
                              v
                             KQL
                              |
                    +---------+---------+
                    |                   |
                    v                   v
                Analysis             Alerts
                                        |
                                        v
                                  Action Group
                                        |
                                        v
                                    Notification





Resources Created
Resource	Name
Resource Group	rg-ppst-storage-lab
Storage Account	stppstlab001
Log Analytics Workspace	law-ppst-storage-lab
Storage Diagnostic Setting	storage-monitoring-diagnostics
Blob Diagnostic Setting	blob-monitoring-diagnostics
Monitoring Components
1. Azure Metrics

Storage metrics provide numerical measurements about resource behavior and performance.

Examples include:

Transactions
Used Capacity
Latency
Availability
Other platform metrics

Metrics are useful for answering:

How is the resource performing?

Metrics were routed to the Log Analytics workspace and validated through the AzureMetrics table.

2. Storage Blob Resource Logs

Blob diagnostic logging was configured for:

Storage Read
Storage Write
Storage Delete

These logs are stored in the:

StorageBlobLogs

table in Log Analytics.

Resource logs answer:

What exactly happened?

3. Log Analytics

The workspace:

law-ppst-storage-lab

provides centralized storage and querying of monitoring telemetry.

Kusto Query Language (KQL) was used to inspect and analyze the collected telemetry.

KQL Validation
Discover available tables
search *
| summarize Count = count() by $table
| order by Count desc

This was used to determine which tables contained telemetry.

The lab confirmed that AzureMetrics contained data.

Query Azure Metrics
AzureMetrics
| order by TimeGenerated desc
| take 20
Summarize metrics
AzureMetrics
| summarize Count = count() by MetricName
| order by Count desc
Analyze metric values
AzureMetrics
| summarize
    Count = count(),
    AvgValue = avg(Average),
    MaxValue = max(Maximum)
    by MetricName
| order by MetricName asc
Query Blob Logs
StorageBlobLogs
| where TimeGenerated > ago(30m)
| summarize Count = count()

Blob activity was generated and successfully appeared in the StorageBlobLogs table.

Inspect Blob operations
StorageBlobLogs
| where TimeGenerated > ago(30m)
| project TimeGenerated, OperationName, StatusText, StatusCode, Uri
| order by TimeGenerated desc
Metrics vs Logs

One of the primary lessons from this lab was understanding the difference between metrics and resource logs.

Metrics
AzureMetrics
    |
    +-- Average
    +-- Maximum
    +-- Total

Metrics provide numerical measurements used to understand resource health and performance.

Logs
StorageBlobLogs
    |
    +-- Operation
    +-- Status
    +-- Request details
    +-- URI
    +-- Time

Logs provide detailed information about individual operations and events.

Mental Model

Metrics tell you how the system is behaving.

Logs tell you what happened.

Troubleshooting Exercise

During the lab, an initial KQL query returned:

No results found from the specified time range

Instead of assuming that telemetry ingestion was broken, the investigation was broadened.

The following query was used:

search *
| summarize Count = count() by $table
| order by Count desc

The workspace showed records in AzureMetrics.

This demonstrated an important troubleshooting principle:

No results from a query does not necessarily mean that no telemetry exists.

The original query contained an overly restrictive filter.

The investigation then moved from:

Assumption
    |
    v
No data

to:

Broad query
    |
    v
Inspect tables
    |
    v
Inspect schema/data
    |
    v
Understand telemetry
    |
    v
Build narrower query
Blob Log Troubleshooting

The StorageBlobLogs table existed but initially contained zero records.

The diagnostic configuration was then verified.

Blob diagnostic settings were configured with:

Storage Read
Storage Write
Storage Delete
Transaction
Log Analytics destination

Actual Blob operations were then generated.

After the activity occurred, StorageBlobLogs contained records.

This demonstrated another important monitoring principle:

A table existing does not mean that telemetry is being ingested into that table.

Alerting

Azure Monitor alerts were configured as part of the monitoring lab.

The alert architecture is:

Metric
   |
   v
Threshold
   |
   v
Alert Rule
   |
   v
Action Group
   |
   v
Notification

This allows Azure to automatically notify an administrator when a monitored condition crosses a defined threshold.

Production Monitoring Mental Model

A production workload should be monitored across multiple dimensions:

Compute
Storage
Networking
Identity
Application
Security
Performance
Availability
Cost

Monitoring provides the telemetry necessary to understand the health of these components.

Key AZ-104 Concepts Demonstrated
Azure Monitor
Azure Storage monitoring
Storage metrics
Diagnostic Settings
Log Analytics
KQL
Resource logs
Blob logging
AzureMetrics
StorageBlobLogs
Alerts
Action Groups
Telemetry troubleshooting
Monitoring architecture
Key Engineering Lessons
1. Don't assume no data means no telemetry

Always validate with a broad query first.

2. Understand the telemetry pipeline
Resource
   |
   v
Diagnostic Settings
   |
   v
Destination
   |
   v
Log Analytics
   |
   v
Table
   |
   v
KQL
3. Understand the difference between metrics and logs

Metrics provide numerical measurements.

Logs provide detailed events and operations.

4. Monitoring is an engineering feedback loop
Observe
   |
   v
Measure
   |
   v
Analyze
   |
   v
Detect
   |
   v
Alert
   |
   v
Respond
Lab Outcome

The Azure Storage monitoring environment was successfully configured and validated.

The lab demonstrated:

Storage metrics flowing to Log Analytics.
AzureMetrics containing telemetry.
Blob diagnostic logging configured.
Storage Blob operations appearing in StorageBlobLogs.
KQL used to inspect and analyze telemetry.
Azure Monitor alerting concepts.
Troubleshooting of telemetry ingestion and query behavior.