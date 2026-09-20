---
# AZ-104 Monitoring - Troubleshooting

# Monitoring Troubleshooting Framework

Use the following evidence-driven sequence:

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

Do not immediately assume the root cause.

Identify the failing layer first.

---

# 1. VM CPU Spike

## Symptom

VM CPU utilization suddenly increases.

## First Check

Azure Monitor Metrics.

## Investigation

1. Review CPU percentage.
2. Identify the exact timestamp.
3. Determine whether the spike is isolated or recurring.
4. Review logs around the timestamp.
5. Investigate scheduled workloads or background processes.
6. Investigate application activity if relevant.
7. Correlate the evidence.

## Key Principle

Metrics show the abnormal behavior and timing.

Logs help explain what happened.

---

# 2. Recurring CPU Spikes

## Symptom

CPU increases at approximately the same time every day.

## Investigation

Look for:

- Scheduled tasks
- Background jobs
- Automation
- Batch processing
- Recurring application activity

## Reasoning

A repeated time pattern is evidence of a recurring or scheduled workload.

---

# 3. Alert Does Not Fire

## Symptom

CPU briefly exceeds the configured threshold, but no alert is generated.

## Example

Alert:

CPU > 90%

Evaluation duration:

5 minutes

Observed spike:

30 seconds

## Investigation

Check:

- Threshold
- Evaluation duration
- Metric being evaluated
- Alert rule configuration

## Key Principle

The threshold and evaluation duration must both be satisfied.

---

# 4. Alert Fires but No Email

## Symptom

The Azure Monitor alert fires, but the administrator receives no email.

## Investigation

Check:

1. Action Group configuration.
2. Email recipient.
3. Notification configuration.
4. Alert-to-Action Group association.

## Key Principle

If the alert has fired, investigate the response path.

Alert Rule:

Detection

Action Group:

Response

---

# 5. Repeated Alert Notifications

## Symptom

An administrator receives repeated notifications for the same incident.

## Investigation

Review:

- Alert notification behavior
- Action Group configuration
- Notification settings
- Alert configuration

## Key Principle

Separate the detection mechanism from the notification mechanism.

---

# 6. Application Is Slow

## Symptom

Application response time is high.

## Investigation

Review:

- Request duration
- Dependency duration
- Exceptions
- Application logs
- Application telemetry
- VM metrics

## Example

Request duration:

4 seconds

Dependency duration:

3.8 seconds

VM CPU:

25%

## Conclusion

Investigate the application dependency.

## Key Principle

Follow the evidence to the component consuming the request time.

---

# 7. VM Healthy but Application Unavailable

## Symptom

VM infrastructure appears healthy but users intermittently cannot access the application.

## Investigation

Move toward the application layer.

Check:

- Application availability
- Application health
- Application logs
- Application telemetry
- Application dependencies

## Key Principle

A healthy VM does not automatically mean the application is healthy.

---

# 8. Application Gateway Backend Unhealthy

## Symptom

A VM is behind Application Gateway.

Requests intermittently fail.

Backend health is unhealthy.

## Troubleshooting Order

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

## Key Principle

Identify the failing layer before focusing on a specific component.

Do not immediately jump directly to the health probe.

---

# 9. Health Probe Troubleshooting

## Symptom

Application Gateway reports a backend as unhealthy.

## Investigation

Review:

- Health probe configuration
- Probe protocol
- Probe port
- Probe path when applicable
- Backend availability
- Connectivity
- NSG / firewall rules

## Key Principle

A health probe is part of the backend health evaluation process.

---

# 10. Workbooks vs Metrics vs Logs

## Requirement

The operations team needs an interactive dashboard combining multiple monitoring signals.

## Solution

Azure Workbooks.

## If the requirement is:

Numerical time-series measurements:

Use Metrics.

Detailed event records:

Use Logs / Log Analytics.

Interactive visualization and analysis:

Use Workbooks.

Application performance:

Use Application Insights.

---

# 11. Metrics vs Logs Troubleshooting

## Question

What is happening?

## Answer

Metrics.

## Question

What happened?

## Answer

Logs.

## Question

Why did it happen?

## Answer

KQL / analysis of logs and correlated monitoring data.

## Key Principle

Metrics and logs answer different questions and should be used together when investigating incidents.

---

# 12. Log Analytics Troubleshooting

## Symptom

Detailed event information is required for an incident.

## Investigation

1. Identify the affected resource.
2. Identify the incident timestamp.
3. Open the relevant Log Analytics data.
4. Query the relevant logs using KQL.
5. Filter by resource, time, or other relevant fields.
6. Correlate results with metrics.

## Key Principle

Use the incident timestamp to correlate metrics and logs.

---

# 13. Application Dependency Troubleshooting

## Symptom

Application requests are slow because an external API is taking 4-5 seconds.

## Investigation

Focus on the dependency layer.

Review:

- Request duration
- Dependency duration
- Dependency failures
- Application telemetry
- Logs

## Key Principle

When a dependency is consuming most of the request duration, investigate the dependency before unrelated infrastructure signals.

---

# 14. Normal Infrastructure but Slow Application

## Symptom

VM CPU, disk, and network metrics are normal.

Application response time is eight seconds.

No slow dependencies or exceptions are identified.

## Investigation

Move toward the application layer.

Review:

- Application logs
- Application processing
- Application telemetry
- Application behavior

## Key Principle

Normal infrastructure metrics do not prove that application processing is healthy.

---

# 15. Evidence-Driven Troubleshooting

## Correct Sequence

1. Identify the affected resource.
2. Determine what is abnormal.
3. Review metrics.
4. Identify the timestamp.
5. Review logs.
6. Query relevant data.
7. Investigate dependencies.
8. Investigate network / ingress when applicable.
9. Check application health.
10. Correlate evidence.
11. Determine the next troubleshooting step.

## Key Principle

Do not troubleshoot a lower layer after evidence has already proven that layer is working.

---

# 16. Monitoring Cross-Domain Troubleshooting

Use the cross-domain sequence:

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

Monitoring evidence helps identify which layer requires investigation.

---

# 17. Monitoring Decision Tree

## CPU Problem

CPU abnormal?

    |
    +-- No --> Investigate another signal.
    |
    +-- Yes
          |
          v
    Identify timestamp
          |
          v
    Check logs
          |
          v
    Recurring pattern?
          |
       +--+--+
       |     |
      Yes    No
       |     |
       v     v
 Scheduled  Investigate
 workload   relevant activity
 automation
 background
 process

---

# 18. Application Slow Decision Tree

Application slow?

      |
      v
Check request duration
      |
      v
Check dependencies
      |
      +---- Dependency slow
      |          |
      |          v
      |     Investigate dependency
      |
      +---- Dependency normal
                 |
                 v
          Check exceptions
                 |
                 v
          Check application logs
                 |
                 v
          Investigate application

---

# 19. Application Gateway Decision Tree

Requests failing?

      |
      v
Application Gateway involved?
      |
      v
Check backend health
      |
      v
Backend unhealthy?
      |
      v
Check health probe
      |
      v
Check port / protocol
      |
      v
Check NSG / firewall
      |
      v
Check connectivity

## Key Principle

Follow the network / ingress path before assuming the application is the root cause.

---

# 20. Monitoring Incident Checklist

When troubleshooting an Azure monitoring incident:

- Identify the affected resource.
- Determine the symptom.
- Check Metrics.
- Identify the timestamp.
- Check Logs.
- Query Log Analytics when detailed evidence is needed.
- Check application telemetry.
- Check dependencies.
- Check network / ingress when applicable.
- Check alerts.
- Check Action Groups when notification behavior is involved.
- Correlate evidence.
- Identify the failing layer.
- Continue troubleshooting from the evidence.

---

# Monitoring Weak Area Retest

## Weak Area

Application Gateway / network ingress troubleshooting.

## Previous Weakness

Jumping directly to the health probe when backend health was unhealthy.

## Corrected Reasoning

Start with the network / ingress layer.

Then investigate:

Application Gateway
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

## Retest Result

Correct reasoning established.

Status:

REINFORCED

---

# Monitoring Core Troubleshooting Rules

Rule 1:

Metrics show what is happening.

Rule 2:

Logs show what happened.

Rule 3:

KQL helps analyze detailed log evidence.

Rule 4:

Alert Rules detect conditions.

Rule 5:

Action Groups define responses.

Rule 6:

Application Insights provides application performance telemetry.

Rule 7:

Workbooks provide interactive visualization and analysis.

Rule 8:

Follow evidence instead of assumptions.

Rule 9:

Identify the failing layer before troubleshooting individual components.

Rule 10:

Do not troubleshoot a lower layer after evidence has already proven that layer is working.

---

# Monitoring Troubleshooting Status

Metrics troubleshooting:

COMPLETE

Logs / Log Analytics troubleshooting:

COMPLETE

Alert troubleshooting:

COMPLETE

Action Group troubleshooting:

COMPLETE

Application troubleshooting:

COMPLETE

Dependency troubleshooting:

COMPLETE

Application Gateway / ingress troubleshooting:

REINFORCED

Evidence-driven troubleshooting:

COMPLETE

Hands-on labs:

NEXT

---
