
---

# 4. `notes.md`

```markdown
# Azure Storage Monitoring - Engineering Notes

## 1. Monitoring Mental Model

Production systems require continuous visibility into:

- Availability
- Performance
- Capacity
- Errors
- Security
- Resource activity
- Cost

Azure Monitor provides the monitoring foundation for Azure resources.

A useful monitoring flow is:

```text
Resource
   |
   v
Telemetry
   |
   v
Collection
   |
   +---- Metrics
   |
   +---- Resource Logs
   |
   v
Analysis
   |
   v
Alert
   |
   v
Response


The important lesson is:

Monitoring is a system, not a single configuration switch.

2. Lab Environment
Subscription:
patel-platform-service-template

Resource Group:
rg-az104-storage-01

Storage Account:
staz104az01

Storage Account Type:
StorageV2

SKU:
Standard_LRS

Region:
eastus

Log Analytics Workspace:
lawaz104mon01

Monitoring Resource Group:
rg-az104-monitoring-01
3. Evidence-Based Monitoring

The central lesson of this lab is:

Good monitoring is based on evidence, not assumptions.

A monitoring implementation should be tested at several levels.

Configuration
     |
     v
Telemetry availability
     |
     v
Actual datapoints
     |
     v
Alert configuration
     |
     v
Validation

A diagnostic setting existing in Azure does not automatically prove that useful telemetry is being collected.

4. Diagnostic Settings

Diagnostic Settings determine which telemetry categories are collected and where telemetry is sent.

The lab created:

diag-staz104az01

for:

staz104az01

Destination:

lawaz104mon01

Enabled metric categories:

Capacity
Transaction
5. Diagnostic Settings as a Routing Mechanism

Conceptually:

Azure Resource
      |
      v
Diagnostic Setting
      |
      +---- Metrics
      |
      +---- Resource Logs
      |
      v
Destination

Possible destinations can include:

Log Analytics
Storage
Event Hub
Partner solutions

The exact available destinations and categories depend on the Azure resource.

6. Metrics

Metrics are numerical measurements.

Storage Account metrics can include:

UsedCapacity
Transactions
Ingress
Egress
SuccessServerLatency
SuccessE2ELatency
Availability
ReplicationLagSeconds
MigrationProgress

Metrics answer questions such as:

How much activity is occurring?
How much storage is being used?
How is the resource performing?
Is availability changing?
7. Transactions Metric

The lab queried:

Transactions

using a one-minute interval:

PT1M

Example result:

2026-08-25T02:42:00Z
Transactions
0.0

Multiple one-minute datapoints returned:

0.0

This is valid telemetry.

It means that no Storage Account transactions occurred during those observed periods.

8. Used Capacity Metric

The actual Azure Monitor metric name is:

UsedCapacity

The Storage Account did not support:

PT1M

for this metric.

Azure returned supported common grains:

01:00:00
06:00:00
12:00:00
1.00:00:00

The lab therefore used:

PT1H

The query successfully returned:

Used capacity
1447.0
9. Important Metric Lesson

Diagnostic categories and Azure Monitor metric names are not necessarily identical.

The diagnostic category was:

Capacity

But the actual Azure Monitor metric was:

UsedCapacity

This distinction is important when troubleshooting metric queries.

10. Metric Time Grains

Different metrics can support different resolutions.

Example:

Transactions
    |
    +---- PT1M supported

while:

UsedCapacity
    |
    +---- PT1M not supported
    |
    +---- PT1H supported

Therefore:

Always check the supported time grain for the metric being queried.

Do not assume all metrics support one-minute resolution.

11. Metrics vs Resource Logs

This distinction is fundamental.

Metrics

Metrics are numerical measurements.

Examples:

Transactions
UsedCapacity
Latency
Availability
Ingress
Egress

Metrics are useful for:

Dashboards
Thresholds
Alerts
Capacity planning
Performance monitoring

Metrics answer:

How is the resource performing?

Resource Logs

Resource logs provide detailed operational information.

They can describe events and operations such as:

Read
Write
Delete
Authentication
Service events

Resource logs answer:

What exactly happened?

12. Important Current-Lab Limitation

The current Storage Account diagnostic setting contains:

logs: []

Therefore Storage resource logs were not enabled in this implementation.

This means the lab should not claim:

StorageBlobLogs
Blob Read logs
Blob Write logs
Blob Delete logs

as completed monitoring evidence.

This is intentional.

The current lab validates:

Azure Monitor metrics
Diagnostic Settings
Metric alerts

rather than claiming unverified resource-log telemetry.

13. Log Analytics Workspace

The existing workspace is:

lawaz104mon01

Resource Group:

rg-az104-monitoring-01

Region:

eastus

Retention:

30 days

The workspace already existed.

The lab reused the existing workspace rather than creating another one.

14. Metric Alert

The lab created:

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

Evaluation:

Every 1 minute

Severity:

2

Enabled:

True

Action Group:

None
15. Why the Alert Threshold Is Simple

The purpose of the alert in this lab is to demonstrate the mechanics of Azure Monitor metric alerts.

It is not intended to represent a production threshold.

A production threshold should be based on:

Workload behavior
Historical baselines
Business requirements
Performance characteristics
Expected traffic
Operational objectives

The lab threshold:

Transactions > 10

is intentionally simple.

16. Alert Evaluation

The alert uses:

Evaluation frequency:
1 minute

and:

Window:
5 minutes

Conceptually:

Current time
     |
     v
Look at previous 5 minutes
     |
     v
Calculate total Transactions
     |
     v
Compare with 10
     |
     v
Generate alert state if threshold is exceeded
17. Monitoring Validation Layers

A strong monitoring validation process includes:

Layer 1 - Resource

Does the resource exist?

staz104az01
Layer 2 - Configuration

Does the diagnostic setting exist?

diag-staz104az01
Layer 3 - Categories

Are the expected metric categories enabled?

Capacity
Transaction
Layer 4 - Telemetry

Does Azure return actual metric datapoints?

Transactions
UsedCapacity
Layer 5 - Alert

Does the alert exist and contain the expected condition?

alert-staz104az01-transactions
Layer 6 - Evidence

Are the results documented and captured?

screenshots/
18. Troubleshooting Lesson - Empty Diagnostic Settings

Initial command:

az monitor diagnostic-settings list

returned:

[]

Interpretation:

No diagnostic setting was configured.

The correct response was not to assume monitoring was already working.

Instead:

Discover categories
       |
       v
Configure diagnostic setting
       |
       v
Verify configuration
       |
       v
Query metrics
19. Troubleshooting Lesson - Invalid Metric

The lab initially attempted:

Capacity

as a direct metric name.

Azure returned an error and listed valid metrics.

Among them:

UsedCapacity

The query was corrected.

Lesson:

When Azure rejects a metric name, use the service's reported valid metrics rather than guessing.

20. Troubleshooting Lesson - Invalid Time Grain

The lab attempted:

UsedCapacity
PT1M

Azure rejected the request.

The service reported supported grains including:

PT1H

The corrected query succeeded.

Lesson:

Metric availability and metric resolution are separate concepts.

A metric can exist while not supporting the requested resolution.

21. Troubleshooting Lesson - Zero Is Still Data

The Transactions metric returned:

0.0

for many periods.

That does not mean the monitoring pipeline is broken.

It means:

Metric exists
+
Datapoints exist
+
No activity occurred

This is an important distinction when validating monitoring systems.

22. Production Monitoring Mental Model

A production monitoring architecture should answer:

Is the resource available?
        |
        v
Is it performing correctly?
        |
        v
Is capacity sufficient?
        |
        v
Are errors increasing?
        |
        v
Is unexpected activity occurring?
        |
        v
Should an operator be notified?

Azure Monitor provides the foundation for these capabilities.

23. Metrics for Capacity

Capacity metrics help answer:

How much storage is being used?
Is usage increasing?
When will capacity become a concern?

The current lab validated:

UsedCapacity
24. Metrics for Activity

Transaction metrics help answer:

How much activity is occurring?
Is workload activity increasing?
Is the workload unexpectedly idle?

The current lab validated:

Transactions
25. Metrics for Performance

Other available metrics include:

SuccessServerLatency
SuccessE2ELatency
Availability

These can be useful for deeper monitoring.

They were discovered during the metric validation process but were not required for this lab's final configuration.

26. Security and Monitoring

Monitoring should also consider:

Authentication activity
Authorization failures
Unexpected access
Resource configuration changes
Network behavior
Operational anomalies

However, those signals may require resource logs, activity logs, or other Azure monitoring sources.

Do not assume that a Storage metric alone provides detailed security-event information.

27. Evidence Files

Current screenshots:

01-diagnostic-settings-configured.png
02-storage-alert-created.png
03-storage-metrics-validation.png
04-final-storage-monitoring-validation.png

Each screenshot represents the current AZ-104 environment.

Old screenshots from the previous monitoring environment were removed.

28. Final Lab State
Subscription
    |
    v
rg-az104-storage-01
    |
    v
staz104az01
    |
    +-----------------------------+
    |                             |
    v                             v
Diagnostic Setting            Metric Alert
diag-staz104az01              alert-staz104az01-transactions
    |                             |
    +-- Capacity                  +-- Transactions > 10
    |
    +-- Transaction
    |
    v
Azure Monitor
    |
    +-- Transactions
    |
    +-- UsedCapacity
    |
    v
Monitoring Evidence
29. Key Engineering Lessons
Monitoring should be evidence-based.
Configuration does not equal validation.
Diagnostic Settings control telemetry routing.
Metrics and logs serve different purposes.
Metric names should be discovered rather than assumed.
Metric time grains vary by metric.
Zero-valued metrics can still represent valid telemetry.
Alerts should be validated after creation.
Reusing an existing monitoring workspace can avoid unnecessary resources.
Documentation should reflect the actual deployed environment.
Never document telemetry that was not actually enabled.
Screenshots should correspond to the current environment.
30. Final Checklist
Storage Account verified                    [x]
Resource Group verified                    [x]
Log Analytics workspace verified           [x]
Diagnostic categories discovered           [x]
Diagnostic setting created                 [x]
Capacity category enabled                  [x]
Transaction category enabled               [x]
Transactions metric validated              [x]
UsedCapacity metric validated              [x]
Metric time grain behavior validated       [x]
Metric alert created                       [x]
Metric alert verified                      [x]
Final monitoring validation captured       [x]
Documentation updated                      [x]
Old environment evidence removed           [x]
Final Takeaway

The strongest lesson from this lab is:

Don't assume monitoring works.

Configure it.
Verify it.
Generate or observe telemetry.
Query the telemetry.
Validate the alert.
Capture the evidence.
Document the actual environment.

That is the difference between simply configuring Azure Monitor and actually understanding monitoring as an engineering discipline.