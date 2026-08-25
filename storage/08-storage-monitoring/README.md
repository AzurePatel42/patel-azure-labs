# Lab 08 - Azure Storage Monitoring

## Objective

Create, configure, and validate monitoring for an Azure Storage Account using Azure Monitor, Diagnostic Settings, Storage metrics, and metric alerts.

This lab uses the existing AZ-104 storage environment and focuses on evidence-based monitoring rather than assumptions.

The lab demonstrates:

- Azure Storage metrics
- Diagnostic Settings
- Azure Monitor
- Metric alerts
- Capacity monitoring
- Transaction monitoring
- Metric time grains
- Monitoring validation
- Evidence-based troubleshooting
- Metrics vs. resource logs

---

## Lab Environment

| Resource | Value |
|---|---|
| Subscription | `patel-platform-service-template` |
| Resource Group | `rg-az104-storage-01` |
| Storage Account | `staz104az01` |
| Storage Account Type | `StorageV2` |
| SKU | `Standard_LRS` |
| Region | `eastus` |
| Log Analytics Workspace | `lawaz104mon01` |
| Monitoring Resource Group | `rg-az104-monitoring-01` |
| Workspace Retention | `30 days` |

---

## Important Monitoring Principle

> Good monitoring is based on evidence, not assumptions.

A monitoring configuration should be validated at multiple levels:

1. Resource exists
2. Diagnostic settings exist
3. Telemetry categories are enabled
4. Azure Monitor exposes actual metrics
5. Metric data contains datapoints
6. Alerts are configured correctly
7. Monitoring evidence is captured

A configured monitoring system is not automatically a validated monitoring system.

---

# Architecture

```text
                         Azure Storage Account
                              staz104az01
                                   |
                                   |
                         Diagnostic Setting
                         diag-staz104az01
                                   |
                         +---------+---------+
                         |                   |
                         v                   v
                    Capacity            Transaction
                         |                   |
                         +---------+---------+
                                   |
                                   v
                            Azure Monitor
                                   |
                    +--------------+--------------+
                    |                             |
                    v                             v
             UsedCapacity                  Transactions
                    |                             |
                    |                             v
                    |                    Metric Alert
                    |              alert-staz104az01-transactions
                    |                             |
                    |                    Transactions > 10
                    |
                    v
              Monitoring Evidence



Monitoring Components
1. Diagnostic Settings

Diagnostic setting:

diag-staz104az01

Storage Account:

staz104az01

Configured metric categories:

Capacity
Transaction

Destination:

lawaz104mon01

The diagnostic setting was verified using Azure CLI.

2. Log Analytics Workspace

Existing workspace:

lawaz104mon01

Resource Group:

rg-az104-monitoring-01

Region:

eastus

Retention:

30 days

The workspace already existed before this lab.

No additional workspace was created.

3. Azure Monitor Metrics

The Storage Account exposes multiple platform metrics.

The environment reported:

UsedCapacity
Transactions
Ingress
Egress
SuccessServerLatency
SuccessE2ELatency
Availability
ReplicationLagSeconds
MigrationProgress

Two metrics were specifically validated during this lab:

Transactions
UsedCapacity
4. Transactions Metric

The Transactions metric supports fine-grained monitoring.

The lab queried:

Transactions

using:

PT1M

one-minute intervals.

The resulting datapoints showed:

Transactions = 0.0

during the observed periods.

A zero value is still valid telemetry.

It means the Storage Account had no transactions during those periods.

5. Used Capacity Metric

The actual Storage Account metric name is:

UsedCapacity

It does not support a one-minute time grain.

Azure returned the supported common grains:

01:00:00
06:00:00
12:00:00
1.00:00:00

The metric was therefore queried using:

PT1H

The lab successfully returned:

Used capacity = 1447.0

This demonstrates an important monitoring concept:

Different metrics can support different time grains.

Do not assume that every Azure metric supports one-minute resolution.

Metric Alert

The lab created the following Azure Monitor metric alert:

Name:
alert-staz104az01-transactions

Scope:

staz104az01

Metric:

Transactions

Aggregation:

Total

Condition:

Transactions > 10

Window:

5 minutes

Evaluation frequency:

1 minute

Severity:

2

Enabled:

True

Action Groups:

None

The alert was successfully created and verified.

Metrics vs Resource Logs

Metrics and resource logs are different monitoring mechanisms.

Metrics

Metrics are numerical measurements.

Examples:

Transactions
UsedCapacity
Ingress
Egress
Latency
Availability

Metrics answer questions such as:

How much activity is occurring?
How much storage is being used?
How is the resource performing?
Is availability changing?

Metrics are particularly useful for:

Dashboards
Alerts
Threshold monitoring
Capacity planning
Performance monitoring
Resource Logs

Resource logs provide more detailed information about operations and events.

Examples can include:

Read
Write
Delete
Authentication events
Service events

Resource logs require appropriate diagnostic categories to be enabled.

Important Lab Result

For this implementation, the Storage Account diagnostic setting contains:

logs: []

Therefore this lab does not claim that Storage Blob resource logs were collected.

This distinction is intentional.

The lab validates:

Storage metrics
Azure Monitor metrics
Metric alerts

rather than claiming telemetry that was not actually enabled.

Evidence-Based Troubleshooting

Several useful monitoring lessons were discovered during the lab.

Lesson 1 - Diagnostic Settings May Not Already Exist

Initial verification returned:

[]

for Storage Account diagnostic settings.

Therefore the diagnostic setting had to be created.

Lesson 2 - Discover Categories Before Configuring

Azure exposed these diagnostic metric categories:

Capacity
Transaction

The configuration was created using the categories actually reported by Azure.

Lesson 3 - Category Names and Metric Names Are Not Always Identical

The diagnostic category:

Capacity

does not mean the Azure Monitor metric is named:

Capacity

When queried directly, Azure reported the valid metric:

UsedCapacity

This is an important troubleshooting distinction.

Lesson 4 - Metrics Have Different Time Grains

Transactions supported:

PT1M

while UsedCapacity required a larger time grain.

Attempting:

UsedCapacity + PT1M

returned a BadRequest.

The corrected query used:

PT1H
Lesson 5 - Empty Activity Is Still Evidence

The Transactions metric returned:

0.0

for many periods.

This does not mean monitoring failed.

It means:

The metric exists
+
Azure is returning datapoints
+
No transactions occurred during those periods
Lab Evidence

Screenshots collected during the lab are stored under:

screenshots/

Expected evidence:

01-diagnostic-settings-configured.png
02-storage-alert-created.png
03-storage-metrics-validation.png
04-final-storage-monitoring-validation.png

These screenshots represent the current staz104az01 environment.

Old screenshots from previous monitoring environments were removed so that the evidence remains consistent with the current lab environment.

Validation Checklist

Before considering the lab complete:

 Storage Account verified
 Resource Group verified
 Log Analytics workspace verified
 Diagnostic categories discovered
 Diagnostic Setting created
 Capacity metric category enabled
 Transaction metric category enabled
 Transactions metric queried
 UsedCapacity metric queried
 Metric time-grain behavior validated
 Storage metric alert created
 Metric alert verified
 Final monitoring evidence captured
 Old environment screenshots removed
 Documentation updated
Final Monitoring State
Storage Account
    staz104az01
        |
        +-- Diagnostic Setting
        |      diag-staz104az01
        |
        +-- Metrics
        |      +-- Capacity
        |      +-- Transaction
        |
        +-- Azure Monitor
        |      +-- Transactions
        |      +-- UsedCapacity
        |
        +-- Metric Alert
               alert-staz104az01-transactions
               Transactions > 10
Key Takeaways
Azure Monitor provides platform metrics for Azure resources.
Diagnostic Settings control telemetry routing.
Metrics and resource logs are different telemetry types.
Metric names must be discovered rather than assumed.
Different metrics support different time grains.
A configured diagnostic setting should be validated with actual telemetry.
Zero-valued datapoints are still valid monitoring evidence.
Alerts can monitor metric thresholds.
Monitoring should be based on observed evidence.
Avoid documenting telemetry that was not actually enabled or verified.