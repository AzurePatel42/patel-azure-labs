@'
# AZ-104 Monitoring Module 01 — Azure Monitor & Log Analytics

## Overview

This lab demonstrates Azure monitoring fundamentals using Azure Monitor and a Log Analytics workspace.

The lab configures diagnostic settings for an Azure Storage Queue, sends queue logs and metrics to Log Analytics, generates real storage activity, and analyzes the resulting data with Kusto Query Language (KQL).

## Objectives

- Create an Azure Log Analytics workspace
- Create an Azure Storage account
- Create an Azure Storage Queue
- Configure diagnostic settings
- Send Storage Queue logs and metrics to Log Analytics
- Generate real queue activity
- Query monitoring data with KQL
- Analyze operation and HTTP status results
- Verify the complete monitoring pipeline

## Architecture

```text
Azure Storage Account
        |
        +-- Storage Queue
        |      |
        |      +-- Queue operations
        |             |
        |             v
        |      Diagnostic Settings
        |             |
        |             v
        +------> Log Analytics
                       |
                       v
                  KQL Queries
                       |
                       v
               Monitoring Results

Azure Resources
Resource	Name
Resource Group	rg-az104-monitoring-01
Log Analytics Workspace	lawaz104mon01
Storage Account	staz104mon01
Storage Queue	az104-monitoring-queue
Diagnostic Setting	diag-staz104mon01-queue
Region	East US
Diagnostic Configuration

The Storage Queue diagnostic setting sends the following logs to Log Analytics:

StorageRead
StorageWrite
StorageDelete

The following metrics are enabled:

Capacity
Transaction
Validation

Real queue activity was generated using Azure CLI.

The Log Analytics workspace successfully received data in:

StorageQueueLogs

KQL queries were used to verify:

Queue log records
Operation names
HTTP status codes
Operational activity summaries

Observed status codes included:

200 — successful operation
201 — successful resource/message creation
403 — authorization-related operation recorded in the monitoring data
Evidence
01 — Log Analytics Workspace

02 — Diagnostic Settings

03 — Azure Monitor Transactions

04 — Diagnostic Setting to Log Analytics

05 — KQL Query Results

06 — Diagnostic Setting Verification

07 — Storage Queue Log Query

08 — Storage Queue Log Summary

Key AZ-104 Concepts Demonstrated
Azure Monitor

Azure Monitor provides metrics, logs, alerts, and monitoring capabilities across Azure resources.

Log Analytics

Log Analytics provides a centralized workspace for collecting and querying monitoring data.

Diagnostic Settings

Diagnostic settings define which resource logs and metrics are collected and where they are sent.

KQL

Kusto Query Language was used to retrieve and analyze Storage Queue monitoring records.

Example:

StorageQueueLogs
| project TimeGenerated, OperationName, StatusCode
| order by TimeGenerated desc

Summary example:

StorageQueueLogs
| summarize Count=count() by OperationName, StatusCode
| order by Count desc
Lab Outcome

The complete monitoring pipeline was successfully demonstrated:

Storage Queue → Diagnostic Settings → Log Analytics → KQL → Monitoring Results

This lab provides hands-on experience with one of the core Azure Administrator monitoring workflows.

## Screenshot Index

| Screenshot | Evidence |
|---|---|
| `01-log-analytics-workspace-created.png` | Log Analytics workspace created |
| `02-diagnostic-settings-log-analytics.png` | Diagnostic settings configuration |
| `03-azure-monitor-metrics-transactions.png` | Azure Monitor transaction metrics |
| `04-diagnostic-setting-to-log-analytics.png` | Diagnostic setting connected to Log Analytics |
| `05-log-analytics-kql-query-results.png` | KQL query results |
| `06-diagnostic-setting-verification.png` | Diagnostic setting CLI verification |
| `07-storage-queue-log-query-verification.png` | Storage Queue log query |
| `08-storage-queue-log-summary.png` | KQL operational summary |

