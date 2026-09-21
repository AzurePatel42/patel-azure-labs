---
# AZ-104 Monitoring - Foundation Notes

## Azure Monitor Mental Model

Azure Resource
      |
      v
Metrics / Logs
      |
      v
Azure Monitor
      |
      +---- Metrics
      |
      +---- Log Analytics
      |
      +---- Alerts
      |
      +---- Action Groups
      |
      +---- Workbooks
      |
      +---- Application Insights

---

# Metrics vs Logs

## Metrics

Metrics are numerical measurements collected over time.

Examples:

- VM CPU percentage
- Network bytes
- Disk IOPS
- Request count
- Response time

Use metrics when the question is:

"What is happening?"

Example:

A VM CPU graph shows CPU increasing from 40% to 95%.

That immediately shows a resource utilization problem and allows us to identify when the spike occurred.

## Logs

Logs contain detailed records and events.

Logs are commonly sent to Log Analytics and queried using KQL.

Use logs when the question is:

"What happened?"

Logs can provide detailed information about:

- Errors
- Events
- Requests
- Application activity
- Resource activity
- Security-related activity

---

# Azure Monitor

Azure Monitor is the central Azure monitoring platform.

It brings together monitoring information such as:

- Metrics
- Logs
- Alerts
- Application Insights
- Workbooks

Azure Monitor allows us to observe resources, investigate problems, configure alerts, and analyze application behavior.

---

# Log Analytics

Log Analytics is used to store and query log data.

KQL is used to query the data.

Mental model:

Logs
  |
  v
Log Analytics
  |
  v
KQL
  |
  v
Analysis

Use Log Analytics when detailed investigation is required.

---

# Alerts

An Azure Monitor alert evaluates a condition and can trigger an alert when the condition is met.

Example:

VM CPU > 90% for 5 minutes

The alert rule defines:

- What resource is monitored
- What condition is evaluated
- What threshold is used
- How long the condition must exist
- What action should occur

Important distinction:

Alert Rule = detects the condition

Action Group = defines the response

---

# Action Groups

Action Groups define what happens after an alert is triggered.

Examples:

- Email
- SMS
- Push notification
- Voice notification
- Automation
- Webhook

Mental model:

Alert Rule
    |
    v
Condition detected
    |
    v
Action Group
    |
    v
Notification / Response

If an alert fires but the expected email is not received, investigate the Action Group configuration and notification settings.

---

# Workbooks

Azure Workbooks provide interactive visualization and analysis.

They can combine information from multiple Azure monitoring sources.

Example:

A workbook can present:

- CPU
- Memory
- Disk
- Network
- Logs
- Application information

Use Workbooks when the requirement is to create an interactive monitoring or operational dashboard.

---

# Application Insights

Application Insights provides application performance monitoring.

It helps investigate:

- Requests
- Response times
- Failed requests
- Exceptions
- Dependencies
- Application availability
- Application performance

Mental model:

Application
    |
    +---- Requests
    |
    +---- Dependencies
    |
    +---- Exceptions
    |
    +---- Response Time
    |
    +---- Availability

If the VM is healthy but the application is slow, move the investigation toward the application layer and its dependencies.

---

# Monitoring Troubleshooting Model

Resource
   |
   v
Metrics
   |
   v
Logs
   |
   v
Query / Analysis
   |
   v
Alert
   |
   v
Action Group
   |
   v
Response

Use evidence from each layer instead of immediately jumping to a conclusion.

---

# Monitoring Question Model

What is happening?
    -> Metrics

What happened?
    -> Logs / Log Analytics

Why is it happening?
    -> KQL / Analysis

Should Azure notify someone?
    -> Alert

What should happen after the alert?
    -> Action Group

How is the application performing?
    -> Application Insights

How should monitoring information be visualized?
    -> Workbooks

---

# Monitoring Troubleshooting Principles

## CPU Spike

If VM CPU increases significantly:

1. Check Azure Monitor metrics.
2. Identify the timestamp of the spike.
3. Check logs around that timestamp.
4. Investigate scheduled workloads, background processes, automation, or application activity.
5. Correlate the evidence before determining the cause.

---

## Recurring CPU Spike

If CPU spikes repeatedly at approximately the same time every day:

Investigate:

- Scheduled workloads
- Background jobs
- Automation
- Batch processing
- Application tasks

A recurring pattern is evidence that the workload may be scheduled or periodic.

---

# Alert Duration

A threshold alone does not always mean an alert should fire immediately.

Example:

CPU > 90% for 5 minutes

A brief 30-second CPU spike should not satisfy a five-minute evaluation duration.

Important lesson:

Threshold + evaluation duration

must both be considered when troubleshooting alert behavior.

---

# Application Dependency Troubleshooting

If application response time is high and dependency calls are also slow:

Investigate the dependency layer.

Example:

Application response time = 4 seconds

Database/API dependency time = 3.8 seconds

VM CPU = 25%

The evidence points toward the application dependency rather than VM CPU saturation.

---

# Application Gateway Health

When a VM is behind Application Gateway and backend health is unhealthy:

Start with the network / ingress layer.

Investigate:

- Application Gateway
- Backend health
- Health probe
- Backend port
- Backend protocol
- NSG
- Firewall
- Connectivity

Important lesson:

Do not immediately assume the application itself is the problem.

First identify the layer where the failure is occurring.

---

# Monitoring Cross-Domain Troubleshooting

Authentication
      |
      v
Authorization
      |
      v
Scope
      |
      v
Network
      |
      v
Resource
      |
      v
Application
      |
      v
Health
      |
      v
Troubleshooting

Monitoring normally becomes most useful after the affected resource, application, or service has been identified.

---

# Monitoring Brainstorming Results

## Question 1

Scenario:

A VM CPU graph shows CPU increasing during the last 24 hours.

Answer:

Azure Monitor Metrics.

Reason:

CPU percentage is a numerical time-series measurement.

---

## Question 2

Scenario:

We need to determine why CPU spiked at 2 PM.

Answer:

Start with the CPU metric and identify the timestamp, then investigate logs around that time.

Reason:

Metrics identify when the problem occurred. Logs help investigate what happened.

---

## Question 3

Scenario:

We need to identify the specific process or activity associated with the CPU spike.

Answer:

Investigate application or process-related logs around the timestamp.

---

## Question 4

Scenario:

CPU spikes repeatedly every day at approximately 2 PM.

Answer:

Investigate scheduled workloads, background processes, automation, or other recurring activity.

---

## Question 5

Scenario:

We need notification when CPU exceeds 90% for five minutes.

Answer:

Create an Azure Monitor Alert Rule.

The Action Group defines the response or notification.

---

## Question 6

Scenario:

An alert fires but no email is received.

Answer:

Investigate the Action Group configuration and notification settings.

---

## Question 7

Scenario:

We need one interactive dashboard containing CPU, memory, disk, and network information.

Answer:

Azure Workbooks.

---

## Question 8

Scenario:

We need detailed records to investigate what happened during an incident.

Answer:

Logs / Log Analytics.

---

## Question 9

Scenario:

Application response time is high and database dependency calls are slow.

Answer:

Investigate the database dependency and application dependency layer.

---

## Question 10

Scenario:

An alert condition is detected and Azure must notify an administrator.

Answer:

The Alert Rule detects the condition and the Action Group performs the notification.

---

# Formal Assessment - Q1-Q10

Score:

10 / 10

Percentage:

100%

Key concepts demonstrated:

- Metrics
- Logs
- Log Analytics
- Alert Rules
- Action Groups
- Workbooks
- Application Insights
- Dependency troubleshooting

---

# Formal Assessment - Q11-Q20

## Q11

Scenario:

Application requests are slow because external API calls take 4-5 seconds.

Correct reasoning:

Investigate the application dependency layer.

---

## Q12

Scenario:

CPU spikes every day at approximately 2 PM while application telemetry remains normal.

Correct reasoning:

Investigate scheduled workloads, background processes, or automation.

---

## Q13

Scenario:

The VM is healthy but the application is intermittently unavailable.

Correct reasoning:

Investigate application availability, application health, and application logs.

---

## Q14

Scenario:

CPU exceeds 90% for only 30 seconds while the alert requires five minutes.

Correct reasoning:

Investigate the evaluation duration.

The 30-second spike does not satisfy the five-minute condition.

---

## Q15

Scenario:

Repeated notifications are received for the same incident.

Correct reasoning:

Investigate alert notification behavior and Action Group configuration.

---

## Q16

Scenario:

Application request duration is four seconds, dependency duration is 3.8 seconds, and VM CPU is 25%.

Correct reasoning:

Investigate the application dependency.

---

## Q17

Scenario:

VM CPU, disk, and network metrics are normal. Application response time is eight seconds and there are no slow dependencies or exceptions.

Correct reasoning:

Investigate application logs and the application layer.

---

## Q18

Scenario:

A VM is behind Application Gateway. Requests intermittently fail and backend health is unhealthy.

Correct reasoning:

Start at the network / ingress layer and investigate:

- Application Gateway
- Backend health
- Health probe
- Backend ports
- Protocol
- NSG / firewall
- Connectivity

---

## Q19

Scenario:

We want to avoid alerts for very brief CPU spikes.

Correct reasoning:

Use an appropriate threshold together with an evaluation duration.

---

## Q20

Scenario:

A VM behind Application Gateway has unhealthy backend health.

Correct reasoning:

Investigate the health probe, including:

- Probe configuration
- Backend port
- Protocol
- Connectivity

---

# Formal Assessment Result

Q1-Q10:

10 / 10 = 100%

Q11-Q20:

9 / 10 fully correct

1 / 10 partial

Overall Q11-Q20:

90%

Main weakness identified:

Application Gateway / network ingress troubleshooting should be identified before jumping directly to the health probe.

---

# Monitoring Strengths

The following concepts are strong:

- Metrics vs Logs
- Azure Monitor
- Log Analytics
- KQL investigation
- Alert conditions
- Alert evaluation duration
- Action Groups
- Workbooks
- Application Insights
- Application dependency troubleshooting
- Timestamp correlation
- Health probe reasoning
- Evidence-driven troubleshooting

---

# Monitoring Weak Area

## Application Gateway Ingress Layer

When backend health is unhealthy, do not immediately jump directly to the health probe.

First identify the layer:

Application
    |
    v
Application Gateway / Ingress
    |
    v
Backend Health
    |
    v
Health Probe
    |
    v
Port / Protocol
    |
    v
NSG / Firewall
    |
    v
Connectivity

The key reasoning improvement is:

Identify the failing layer first, then investigate the specific component inside that layer.

---

# Monitoring Core Mental Model

Metrics tell us:

"What is happening?"

Logs tell us:

"What happened?"

KQL helps determine:

"Why?"

Alert Rules determine:

"Should Azure notify someone?"

Action Groups determine:

"What should happen?"

Application Insights determines:

"How is the application performing?"

Workbooks determine:

"How should monitoring information be visualized?"

---

# Monitoring Status

Foundation:

COMPLETE

Formal Q1-Q10:

COMPLETE

Formal Q11-Q20:

COMPLETE

Weak-area identification:

COMPLETE

Hands-on labs:

NEXT

GitHub documentation:

NEXT

---

# Monitoring Hands-On Lab

## Lab Objective

Validate Azure Monitor monitoring end-to-end using the storage account `staz104az01` and Log Analytics workspace `lawaz104mon01`.

## Resources

- Storage Account: `staz104az01`
- Log Analytics Workspace: `lawaz104mon01`
- Diagnostic Setting: `diag-staz104az01`
- Alert Rule: `alert-staz104az01-transactions`

## Diagnostic Settings

The storage account diagnostic setting sends:

- Capacity
- Transaction

data to the `lawaz104mon01` Log Analytics workspace.

Mental model:

staz104az01
    |
    | Diagnostic setting
    v
lawaz104mon01
    |
    v
Log Analytics / AzureMetrics

## Metric Investigation

The Storage Account Metrics blade was used to inspect the `Transactions` metric.

The displayed 24-hour metric chart showed:

- Metric: Transactions
- Aggregation: Sum
- Total displayed: 14

## Alert Investigation

Alert rule:

`alert-staz104az01-transactions`

Configuration observed:

- Signal: Transactions
- Condition: Transactions > 10
- Severity: Warning
- Status: Enabled
- Time series monitored: 1
- Action Group: None configured

The Alerts blade showed zero alert instances during the investigation.

Important lesson:

A metric value above a configured threshold does not by itself prove that an alert instance fired. Alert history/state must be verified separately.

## KQL Validation

Query used:

AzureMetrics
| where Resource == "STAZ104AZ01"
| summarize Records = count(), TotalTransactions = sum(Total) by MetricName
| order by MetricName asc

Observed Transactions result:

- MetricName: Transactions
- Records: 9
- TotalTransactions: 14

The Log Analytics result matched the 14 transactions observed in the Storage Account Metrics chart.

## Monitoring Evidence Chain

staz104az01
    |
    | Diagnostic setting
    | Capacity + Transaction
    v
lawaz104mon01
    |
    v
AzureMetrics
    |
    v
KQL investigation
    |
    v
Transactions = 14
    |
    v
Alert Rule: Transactions > 10
    |
    +---- Enabled
    +---- Warning
    +---- No Action Group
    +---- No alert instances observed

## Key AZ-104 Lessons

- Metrics show what is happening.
- Logs show what happened.
- KQL is used for investigation and analysis.
- Alert Rules evaluate conditions.
- Alert instances provide evidence that an alert actually fired.
- Action Groups define the notification or response after an alert fires.
- Diagnostic settings determine what resource data is sent to monitoring destinations.
- Metric charts and Log Analytics can be correlated to validate monitoring data.

## Hands-On Lab Status

COMPLETE

## GitHub Documentation Status

READY FOR COMMIT
