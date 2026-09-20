---
# AZ-104 Monitoring - Scenarios

# Scenario 1 - VM CPU Spike

## Situation

A production VM shows CPU utilization increasing significantly during the day.

## Evidence

Azure Monitor Metrics shows CPU increasing from normal utilization to approximately 95%.

## Investigation

1. Review the CPU metric.
2. Identify the exact timestamp of the spike.
3. Check logs around the same timestamp.
4. Investigate scheduled workloads, background processes, automation, or application activity.
5. Correlate the evidence before identifying the root cause.

## Correct Monitoring Tools

- Azure Monitor Metrics
- Log Analytics
- Logs

## Key Lesson

Metrics show when and how much CPU increased.

Logs help investigate what happened around that time.

---

# Scenario 2 - Recurring CPU Spike

## Situation

A VM experiences a CPU spike every day at approximately 2 PM.

## Evidence

The CPU pattern repeats at approximately the same time each day.

## Investigation

Investigate:

- Scheduled tasks
- Background jobs
- Automation
- Batch processing
- Recurring application activity

## Key Lesson

A recurring time pattern is evidence that the workload may be scheduled or periodic.

---

# Scenario 3 - CPU Alert

## Situation

The operations team wants an alert when VM CPU remains above 90% for five minutes.

## Requirement

Azure should notify an administrator when the condition is satisfied.

## Solution

Configure:

1. Azure Monitor Alert Rule
2. CPU threshold = 90%
3. Evaluation duration = 5 minutes
4. Action Group for notification

## Mental Model

Metric
    |
    v
Alert Rule
    |
    v
Condition satisfied
    |
    v
Action Group
    |
    v
Administrator notification

## Key Lesson

The Alert Rule detects the condition.

The Action Group defines the response.

---

# Scenario 4 - Alert Fires but No Email

## Situation

An Azure Monitor alert fires, but the administrator does not receive the expected email.

## Investigation

Check:

- Action Group configuration
- Email recipient
- Notification configuration
- Alert-to-Action Group association

## Key Lesson

Do not assume that the alert condition is the problem.

If the alert has fired, investigate the response path.

---

# Scenario 5 - CPU Spike Too Short

## Situation

An alert is configured for CPU greater than 90% for five minutes.

The VM CPU exceeds 90% for only 30 seconds.

## Result

The five-minute evaluation duration is not satisfied.

## Key Lesson

Alert troubleshooting must consider both:

- Threshold
- Evaluation duration

A brief spike does not necessarily satisfy a longer-duration alert condition.

---

# Scenario 6 - Application Response Time

## Situation

An application is responding slowly.

Application request duration is four seconds.

A database dependency is taking 3.8 seconds.

VM CPU is only 25%.

## Investigation

The database dependency should be investigated first.

## Reasoning

The dependency is consuming most of the request duration while VM CPU is low.

## Key Lesson

Follow the evidence to the slowest component instead of assuming the VM is the problem.

---

# Scenario 7 - VM Healthy but Application Unavailable

## Situation

A VM reports healthy infrastructure metrics, but users intermittently cannot access the application.

## Investigation

Move the investigation toward:

- Application availability
- Application health
- Application logs
- Application dependencies

## Key Lesson

A healthy VM does not automatically mean the application running on the VM is healthy.

Troubleshoot the layer where the evidence indicates the problem exists.

---

# Scenario 8 - Application Gateway Backend Unhealthy

## Situation

A VM is behind Application Gateway.

Users experience intermittent request failures.

Application Gateway reports the backend as unhealthy.

## Investigation Order

Start at the network / ingress layer.

Investigate:

1. Application Gateway
2. Backend health
3. Health probe
4. Backend port
5. Backend protocol
6. NSG
7. Firewall
8. Connectivity

## Key Lesson

Do not immediately jump to the health probe without first identifying the failing layer.

The health probe is one component inside the network / ingress troubleshooting path.

---

# Scenario 9 - Monitoring Dashboard

## Situation

An operations team wants an interactive dashboard that combines:

- CPU
- Memory
- Disk
- Network
- Logs
- Application information

## Solution

Use Azure Workbooks.

## Key Lesson

Workbooks provide interactive visualization and analysis of monitoring information.

---

# Scenario 10 - Detailed Incident Investigation

## Situation

A resource experienced an incident at 2 PM.

The operations team needs detailed records to determine what happened.

## Solution

Use Logs / Log Analytics and query the relevant data with KQL.

## Investigation

1. Identify the incident timestamp.
2. Review relevant metrics.
3. Query logs around the timestamp.
4. Correlate events with resource behavior.
5. Identify the evidence supporting the root cause.

## Key Lesson

Metrics identify abnormal behavior and timing.

Logs provide detailed event information.

---

# Scenario 11 - Application Dependency Failure

## Situation

Application requests are slow because an external API is taking 4-5 seconds to respond.

## Investigation

Focus on the application dependency layer.

Review:

- Request duration
- Dependency duration
- Dependency failures
- Application telemetry
- Relevant logs

## Key Lesson

When dependency latency dominates the request duration, investigate the dependency before focusing on unrelated infrastructure metrics.

---

# Scenario 12 - Normal Infrastructure, Slow Application

## Situation

VM CPU, disk, and network metrics are normal.

Application response time is eight seconds.

There are no slow dependencies or application exceptions.

## Investigation

Move toward the application layer.

Investigate:

- Application logs
- Application processing
- Application behavior
- Application-specific telemetry

## Key Lesson

Normal infrastructure metrics do not prove that the application itself is healthy.

---

# Scenario 13 - Monitoring Tool Selection

## Situation

Different monitoring questions are presented.

## Question

What is happening?

## Answer

Metrics.

---

## Question

What happened?

## Answer

Logs / Log Analytics.

---

## Question

Why is it happening?

## Answer

KQL / Analysis.

---

## Question

Should Azure notify someone?

## Answer

Alert Rule.

---

## Question

What should happen after an alert?

## Answer

Action Group.

---

## Question

How is the application performing?

## Answer

Application Insights.

---

## Question

How should monitoring information be visualized?

## Answer

Workbooks.

---

# Scenario 14 - Cross-Domain Troubleshooting

## Situation

A monitored Azure application is experiencing a problem.

## Troubleshooting Model

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

## Key Lesson

Use evidence to identify the failing layer before moving deeper into troubleshooting.

---

# Scenario 15 - Evidence-Driven Monitoring

## Situation

A monitoring signal identifies abnormal behavior.

## Correct Approach

Do not immediately assume the root cause.

Instead:

1. Identify the affected resource.
2. Review metrics.
3. Identify the timestamp.
4. Review logs.
5. Query relevant data.
6. Investigate dependencies.
7. Check network / ingress when applicable.
8. Review application health.
9. Correlate the evidence.
10. Determine the next troubleshooting step.

## Key Lesson

Do not troubleshoot a lower layer after evidence has already proven that layer is working.

---

# Monitoring Scenario Mental Model

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

For application incidents:

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

---

# Monitoring Scenario Status

Foundation scenarios:

COMPLETE

Application troubleshooting:

COMPLETE

Alert troubleshooting:

COMPLETE

Application Gateway / ingress troubleshooting:

COMPLETE

Weak-area scenario:

IDENTIFIED

Hands-on labs:

NEXT

---
