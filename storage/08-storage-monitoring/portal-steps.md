
---

# 3. `portal-steps.md`

```markdown
# Azure Storage Monitoring - Azure Portal Steps

## Objective

Configure and validate Azure Storage monitoring using the Azure Portal.

This lab uses the existing AZ-104 environment.

---

# Lab Environment

| Setting | Value |
|---|---|
| Subscription | `patel-platform-service-template` |
| Resource Group | `rg-az104-storage-01` |
| Storage Account | `staz104az01` |
| Region | `eastus` |
| Log Analytics Workspace | `lawaz104mon01` |
| Monitoring Resource Group | `rg-az104-monitoring-01` |

---

# Part 1 - Verify Storage Account

## Step 1 - Open Azure Portal

Open:

```text
https://portal.azure.com


Step 2 - Open Storage Accounts

Search for:

Storage accounts
Step 3 - Open the Lab Storage Account

Select:

staz104az01

Verify:

Resource Group:
rg-az104-storage-01

Region:
eastus
Part 2 - Review Storage Monitoring
Step 1 - Open Monitoring

From the Storage Account navigation menu, locate:

Monitoring

Review:

Metrics
Alerts
Diagnostic settings
Part 3 - Diagnostic Settings
Step 1 - Open Diagnostic Settings

Navigate to:

Monitoring
    ->
Diagnostic settings
Step 2 - Verify Existing Diagnostic Setting

Look for:

diag-staz104az01
Step 3 - Review Destination

The diagnostic setting sends telemetry to:

lawaz104mon01

The workspace is located in:

rg-az104-monitoring-01
Step 4 - Review Metrics

The diagnostic setting contains:

Capacity
Transaction

Both are enabled.

Step 5 - Review Resource Logs

The current implementation does not enable Storage resource logs.

The CLI validation showed:

logs: []

Therefore do not document Blob resource logging as configured for this lab.

Part 4 - Azure Monitor Metrics
Step 1 - Open Metrics

Navigate to:

Monitoring
    ->
Metrics
Step 2 - Select Scope

The selected resource should be:

staz104az01
Step 3 - Review Transactions

Select the metric:

Transactions

Review the graph.

The metric can be observed at fine-grained intervals.

The CLI validation used:

PT1M
Step 4 - Review Used Capacity

Select:

Used capacity

The Storage Account exposes this metric as:

UsedCapacity

Important:

UsedCapacity does not support the same one-minute time grain as Transactions.

This demonstrates that metric resolution depends on the individual metric.

Part 5 - Azure Monitor Alerts
Step 1 - Open Alerts

Navigate to:

Monitoring
    ->
Alerts
Step 2 - Review Metric Alert

Find:

alert-staz104az01-transactions
Step 3 - Review Alert Condition

The alert monitors:

Transactions

Condition:

Total Transactions > 10
Step 4 - Review Evaluation Settings

Window:

5 minutes

Evaluation frequency:

1 minute

Severity:

2

Enabled:

Yes
Step 5 - Review Actions

The current lab alert has:

No Action Group

This lab focuses on metric alert configuration and validation.

Notification routing is not required for the current implementation.

Part 6 - Log Analytics Workspace
Step 1 - Open Log Analytics Workspaces

Search:

Log Analytics workspaces
Step 2 - Open Workspace

Open:

lawaz104mon01

Verify:

Resource Group:
rg-az104-monitoring-01

Region:
eastus

Retention:
30 days
Part 7 - Important Metrics vs Logs Concept

Azure monitoring contains different telemetry types.

Metrics

Metrics are numerical measurements.

Examples:

Transactions
UsedCapacity
Ingress
Egress
Latency
Availability

Metrics are useful for:

Performance
Capacity
Dashboards
Thresholds
Alerts
Resource Logs

Resource logs contain detailed operational information.

Examples can include:

Read
Write
Delete
Service events
Authentication events

Resource logs require the appropriate diagnostic categories to be enabled.

For this lab:

Storage resource logs:
Not enabled

Do not confuse metric monitoring with resource-log collection.

Part 8 - Evidence Collection

The lab evidence is stored under:

screenshots/

Expected screenshots:

01-diagnostic-settings-configured.png
02-storage-alert-created.png
03-storage-metrics-validation.png
04-final-storage-monitoring-validation.png
Part 9 - Evidence-Based Validation

A monitoring configuration should be validated in this order:

Resource exists
       |
       v
Diagnostic setting exists
       |
       v
Categories enabled
       |
       v
Metric exists
       |
       v
Metric returns datapoints
       |
       v
Alert exists
       |
       v
Alert configuration verified

Do not assume monitoring works merely because a configuration exists.

Part 10 - Final Validation

Verify the Storage Account:

staz104az01

Verify diagnostic setting:

diag-staz104az01

Verify workspace:

lawaz104mon01

Verify metrics:

Transactions
UsedCapacity

Verify alert:

alert-staz104az01-transactions
Portal Validation Checklist
 Storage Account opened
 Monitoring section reviewed
 Diagnostic Settings reviewed
 Diagnostic setting verified
 Capacity metric category enabled
 Transaction metric category enabled
 Azure Monitor Metrics reviewed
 Transactions metric validated
 Used Capacity metric validated
 Metric alert reviewed
 Log Analytics workspace verified
 Monitoring evidence captured
Important Troubleshooting Lessons
Metric Name

Do not assume:

Capacity

is the direct metric name.

Azure exposed:

UsedCapacity

as the Storage Account metric.

Metric Time Grain

Do not assume every metric supports:

1 minute

Transactions supported fine-grained monitoring.

UsedCapacity required a larger time grain.

Zero Metrics

A metric value of:

0

does not mean telemetry is broken.

It can simply mean:

No activity occurred during the period.
Final Architecture
Storage Account
staz104az01
      |
      v
Diagnostic Settings
diag-staz104az01
      |
      +---- Capacity
      |
      +---- Transaction
      |
      v
Azure Monitor
      |
      +---- Transactions
      |
      +---- UsedCapacity
      |
      v
Metric Alert
alert-staz104az01-transactions
      |
      v
Monitoring Evidence
Lab Complete

The Storage Monitoring lab is complete when:

Diagnostic Settings       Verified
Metrics                    Verified
Used Capacity              Verified
Transactions               Verified
Metric Alert               Verified
Workspace                  Verified
Evidence                   Captured
Documentation              Updated