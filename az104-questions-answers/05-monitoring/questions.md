---
# AZ-104 Monitoring - Questions and Answers

# Q1-Q10 - Foundation

## Q1

Question:

A VM CPU graph shows CPU increasing during the last 24 hours. Which Azure Monitor capability should be used to observe this behavior?

Answer:

Metrics.

Reason:

CPU percentage is a numerical time-series measurement.

---

## Q2

Question:

You need to determine why CPU spiked at 2 PM. What should you investigate?

Answer:

Start with the CPU metric and identify the timestamp, then investigate logs around that time.

Reason:

Metrics identify when the problem occurred. Logs provide detailed information about what happened.

---

## Q3

Question:

You need to identify the specific process or activity associated with a CPU spike. What should you investigate?

Answer:

Application or process-related logs around the timestamp of the CPU spike.

Reason:

The metric identifies the abnormal behavior and timestamp. Logs provide additional detail for investigation.

---

## Q4

Question:

A VM CPU spike occurs repeatedly every day at approximately 2 PM. What should you investigate?

Answer:

Scheduled workloads, background processes, automation, batch processing, or recurring application tasks.

Reason:

A recurring time pattern can indicate a scheduled or periodic workload.

---

## Q5

Question:

You need Azure to notify an administrator when CPU exceeds 90% for five minutes. What should you configure?

Answer:

An Azure Monitor Alert Rule.

Reason:

The Alert Rule evaluates the CPU threshold and evaluation duration.

The Action Group defines what happens after the alert condition is detected.

---

## Q6

Question:

An Azure Monitor alert fires, but the administrator does not receive the expected email. What should you investigate?

Answer:

The Action Group configuration and notification settings.

Reason:

The Alert Rule detects the condition. The Action Group handles the notification.

---

## Q7

Question:

You need one interactive dashboard containing CPU, memory, disk, and network information. Which Azure monitoring capability should you use?

Answer:

Azure Workbooks.

Reason:

Workbooks provide interactive visualization and analysis of monitoring information.

---

## Q8

Question:

You need detailed records to investigate what happened during an incident. Which Azure monitoring capability should you use?

Answer:

Logs / Log Analytics.

Reason:

Logs provide detailed event and activity information and can be queried with KQL in Log Analytics.

---

## Q9

Question:

Application response time is high and database dependency calls are also slow. Where should you investigate?

Answer:

The database dependency and application dependency layer.

Reason:

The dependency is consuming most of the request time, while the VM itself may not be the bottleneck.

---

## Q10

Question:

An alert condition is detected and Azure must notify an administrator. Which components are involved?

Answer:

The Alert Rule detects the condition and the Action Group performs the notification.

Reason:

Alert Rule = detection.

Action Group = response.

---

# Q1-Q10 Assessment Result

Score:

10 / 10

Percentage:

100%

Status:

FOUNDATION COMPLETE

---

# Q11-Q20 - Intermediate / Weakness Detection

## Q11

Question:

Application requests are slow because external API calls take 4-5 seconds. Which layer should be investigated?

Answer:

The application dependency layer.

Reason:

The external API dependency is consuming significant request time.

---

## Q12

Question:

CPU spikes every day at approximately 2 PM while application telemetry remains normal. What should you investigate?

Answer:

Scheduled workloads, background processes, automation, batch processing, or other recurring activity.

Reason:

The repeated timing pattern suggests a scheduled or periodic workload.

---

## Q13

Question:

The VM is healthy but the application is intermittently unavailable. What should you investigate?

Answer:

Application availability, application health, and application logs.

Reason:

The VM health evidence does not explain the application-level availability problem.

---

## Q14

Question:

An alert requires CPU to remain above 90% for five minutes, but the actual CPU spike lasts only 30 seconds. Why might the alert not fire?

Answer:

The evaluation duration was not satisfied.

Reason:

The condition requires CPU to remain above the threshold for five minutes. A 30-second spike does not satisfy the five-minute duration.

---

## Q15

Question:

An administrator receives repeated notifications for the same incident. What should be investigated?

Answer:

Alert notification behavior and Action Group configuration.

Reason:

The investigation should determine why notifications are being repeatedly generated or delivered.

---

## Q16

Question:

Application request duration is four seconds, dependency duration is 3.8 seconds, and VM CPU is 25%. What should be investigated?

Answer:

The application dependency.

Reason:

Most of the request duration is being consumed by the dependency while VM CPU utilization is low.

---

## Q17

Question:

VM CPU, disk, and network metrics are normal. Application response time is eight seconds, and there are no slow dependencies or exceptions. What should be investigated?

Answer:

Application logs and the application layer.

Reason:

The infrastructure metrics and known dependency signals do not explain the slow response.

---

## Q18

Question:

A VM is behind Application Gateway. Requests intermittently fail and backend health is unhealthy. Where should troubleshooting begin?

Answer:

The network / ingress layer.

Investigate:

- Application Gateway
- Backend health
- Health probe
- Backend port
- Backend protocol
- NSG
- Firewall
- Connectivity

Reason:

The first step is to identify the failing layer before focusing on a specific component such as the health probe.

---

## Q19

Question:

You want to avoid alerts for very brief CPU spikes. What should you configure?

Answer:

An appropriate threshold together with an evaluation duration.

Reason:

The evaluation duration prevents short-lived spikes from satisfying the alert condition.

---

## Q20

Question:

A VM behind Application Gateway has unhealthy backend health. What should you investigate?

Answer:

The health probe and its related configuration.

Investigate:

- Probe configuration
- Backend port
- Protocol
- Connectivity

Reason:

The health probe determines whether the backend is considered healthy.

---

# Q11-Q20 Assessment Result

Score:

9 / 10 fully correct

1 / 10 partial

Percentage:

90%

Status:

INTERMEDIATE COMPLETE

---

# Monitoring Weak Area

## Application Gateway / Network Ingress Troubleshooting

Key improvement:

When backend health is unhealthy, identify the network / ingress layer first before immediately jumping to the health probe.

Troubleshooting sequence:

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

---

# Monitoring Core Distinctions

Metrics:

"What is happening?"

Logs:

"What happened?"

KQL / Analysis:

"Why is it happening?"

Alert Rule:

"Should Azure notify someone?"

Action Group:

"What should happen after the alert?"

Application Insights:

"How is the application performing?"

Workbooks:

"How should monitoring information be visualized?"

---

# Monitoring Status

Q1-Q10:

COMPLETE - 100%

Q11-Q20:

COMPLETE - 90%

Weak-area identification:

COMPLETE

Hands-on labs:

NEXT

---
