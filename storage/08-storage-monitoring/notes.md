# Storage Monitoring — Engineering Notes

## 1. Monitoring Mental Model

A production workload needs continuous visibility into:

- Availability
- Performance
- Capacity
- Errors
- Security
- Resource activity
- Cost

Azure Monitor provides the monitoring foundation for Azure resources.

The basic monitoring flow is:

Resource
→ Telemetry
→ Collection
→ Log Analytics / Metrics
→ Query
→ Alert
→ Response

---

## 2. Metrics vs Logs

This was one of the most important concepts in this lab.

### Metrics

Metrics are numerical measurements collected from a resource.

Examples:

- Transactions
- Capacity
- Latency
- Availability
- Throughput

Metrics answer:

> How is the resource performing?

Example:

```text
Azure Storage
     |
     v
Transaction metric
     |
     v
AzureMetrics




Metrics are useful for:

Dashboards
Thresholds
Alerts
Capacity planning
Performance analysis
Logs

Logs provide detailed information about events and operations.

For Blob Storage:

StorageBlobLogs

can contain information about operations such as:

Read
Write
Delete

Logs answer:

What exactly happened?

Example:

Blob operation
     |
     v
Diagnostic Setting
     |
     v
StorageBlobLogs
3. Diagnostic Settings

Diagnostic Settings control which platform logs and metrics are collected and where they are sent.

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

Possible destinations include:

Log Analytics Workspace
Storage Account
Event Hub
Partner solutions

Diagnostic Settings are therefore a telemetry routing mechanism.

4. Storage Account-Level Monitoring

The Storage Account diagnostic setting used in this lab was:

storage-monitoring-diagnostics

Destination:

law-ppst-storage-lab

Metric:

Transaction

The metric data was successfully found in:

AzureMetrics
5. Blob Service Monitoring

Blob service logging was configured separately.

Diagnostic setting:

blob-monitoring-diagnostics

Categories:

Storage Read
Storage Write
Storage Delete

Metric:

Transaction

Destination:

law-ppst-storage-lab

The Blob resource logs were stored in:

StorageBlobLogs
6. Resource Hierarchy Matters

Azure Storage has a parent Storage Account and child services.

Storage Account
      |
      +-- Blob Service
      |
      +-- Queue Service
      |
      +-- Table Service
      |
      +-- File Service

Diagnostic configuration can therefore exist at different resource scopes.

This is important when troubleshooting why one type of telemetry exists while another does not.

7. Log Analytics Workspace

The workspace used in this lab was:

law-ppst-storage-lab

Resource group:

rg-ppst-storage-lab

Region:

Central US

The workspace acts as a centralized destination for monitoring telemetry.

8. Log Analytics Tables

Important tables encountered during this lab:

AzureMetrics
StorageBlobLogs
Usage

A table represents a schema/location for a particular category of telemetry.

Important troubleshooting principle:

A table existing does not mean that it contains data.

For example:

StorageBlobLogs
     |
     +-- Table exists
     |
     +-- 0 records

After enabling the appropriate diagnostic logging and generating Blob activity:

StorageBlobLogs
     |
     +-- Records available
9. KQL

Kusto Query Language (KQL) is used to query and analyze Log Analytics data.

Example:

AzureMetrics
| order by TimeGenerated desc
| take 20

KQL follows a pipeline model.

Table
  |
  v
Filter
  |
  v
Project
  |
  v
Summarize
  |
  v
Sort
10. KQL Time Syntax

An important syntax lesson from this lab:

Correct:

ago(1h)

Incorrect:

ago(1 hour)

Common duration notation:

1m = 1 minute
1h = 1 hour
1d = 1 day
7d = 7 days
11. Broad Query Before Narrow Query

One of the best troubleshooting lessons came from a query that initially returned no results.

Instead of assuming that telemetry ingestion was broken, a broad query was used:

search *
| summarize Count = count() by $table
| order by Count desc

This showed:

AzureMetrics
Usage

and confirmed that telemetry existed.

The lesson:

Do not immediately assume that no query results means no data.

The query itself may be wrong, too restrictive, or based on an incorrect assumption about the schema.

12. Troubleshooting Method

The troubleshooting process was:

Query returns no results
          |
          v
Don't assume telemetry is broken
          |
          v
Run broad query
          |
          v
Identify tables
          |
          v
Inspect schema/data
          |
          v
Understand resource scope
          |
          v
Build narrower query

This approach is applicable to production systems as well.

13. Table Exists vs Data Exists

This distinction is important.

Table exists
     ≠
Telemetry exists

Example:

StorageBlobLogs
     |
     +-- Schema exists
     |
     +-- 0 records

After generating Blob activity:

StorageBlobLogs
     |
     +-- Schema exists
     |
     +-- Records exist

Always verify both.

14. Metrics Analysis

The lab used:

AzureMetrics
| summarize Count = count() by MetricName
| order by Count desc

Metrics were also analyzed using:

AzureMetrics
| summarize
    Count = count(),
    AvgValue = avg(Average),
    MaxValue = max(Maximum)
    by MetricName
| order by MetricName asc

This demonstrates how raw telemetry can be converted into useful information.

15. Blob Log Validation

After configuring Blob diagnostic logging and generating activity:

StorageBlobLogs
| where TimeGenerated > ago(30m)
| summarize Count = count()

The table returned records.

This proved the end-to-end resource-log pipeline.

16. Monitoring vs Alerting

Monitoring and alerting are related but different.

Monitoring

Monitoring answers:

What is happening?

Alerting

Alerting answers:

Does this condition require attention?

Architecture:

Telemetry
   |
   v
Monitor
   |
   v
Condition / Threshold
   |
   v
Alert Rule
   |
   v
Action Group
   |
   v
Notification
17. Action Groups

An Action Group defines what Azure should do when an alert fires.

Examples:

Email
SMS
Push notification
Webhook
Automation
Other supported actions

This separates the detection condition from the response mechanism.

18. Production Monitoring

Production monitoring should not focus on only one resource.

A healthy production environment should monitor:

Compute
Storage
Networking
Identity
Application
Security
Performance
Availability
Capacity
Cost

Monitoring creates the feedback loop required to operate production systems reliably.

19. Monitoring Feedback Loop

A useful engineering model is:

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
   |
   v
Improve

This is more useful than thinking of monitoring as simply "looking at dashboards."

20. Connection to Distributed Systems

The same monitoring principles will become even more important when working with distributed systems.

For example:

Service A
    |
    v
Service B
    |
    v
Database

If a request fails, monitoring helps determine:

Did Service A receive the request?
Did Service A call Service B?
Did Service B respond?
Did the database respond?
Was the network available?
Was authorization successful?
Where did latency increase?

Monitoring provides the evidence required to answer these questions.

21. Key Engineering Principle

A production engineer should not rely on assumptions.

Instead:

Hypothesis
    |
    v
Evidence
    |
    v
Telemetry
    |
    v
Query
    |
    v
Diagnosis
    |
    v
Fix
    |
    v
Validation

This Storage Monitoring lab reinforced that principle.

22. Final Takeaway

The most important lessons from this lab are:

Metrics and logs serve different purposes.
Diagnostic Settings route telemetry.
Log Analytics provides centralized telemetry analysis.
KQL turns telemetry into useful information.
A table existing does not mean that data exists.
No query results do not automatically mean telemetry is broken.
Start troubleshooting broadly and narrow the query after understanding the data.
Alerts convert monitoring information into operational action.
Monitoring is a continuous production feedback loop.
Good monitoring is based on evidence, not assumptions.