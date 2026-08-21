# Compute Module 04 — VM Management, Monitoring & Operations

## Objective

Build and operate an Azure VM monitoring environment and practice a complete incident-response workflow.

This lab focused on:

- Azure Virtual Networks
- Subnets
- Network Security Groups
- Virtual Machines
- Azure Monitor metrics
- CPU monitoring
- Network monitoring
- Disk monitoring
- VM health
- Metric alerts
- Alert state
- Run Command
- Incident investigation
- Remediation
- Recovery verification
- Activity Log
- Resource cleanup

The central operational model was:

```text
Baseline
   ↓
Monitor
   ↓
Detect
   ↓
Alert
   ↓
Investigate
   ↓
Remediate
   ↓
Verify Recovery


1. Incident Scenario

The lab used the following customer scenario:

The VM is running, but users report intermittent performance problems. Determine whether the issue is compute, network, disk, VM health, or application-related.

The investigation approach was:

User reports slowness
        ↓
Do not guess
        ↓
Check baseline
        ↓
Compare current metrics
        ↓
Correlate CPU / Network / Disk / VM health
        ↓
Identify abnormal layer
        ↓
Investigate
        ↓
Remediate
        ↓
Verify recovery
2. Baseline Concept

A baseline is the starting reference for normal system behavior.

It answers:

What does healthy or normal behavior look like?

Baseline is not necessarily one number.

A useful baseline is better represented as:

Normal range
+
Normal pattern
+
Time context
+
Multiple observations

Example:

Bad baseline:
CPU = 4.8%


Better baseline:
CPU normally remains near idle during quiet periods

The lab therefore collected several measurements before introducing a controlled incident.

3. Network Architecture

The monitoring VM environment used:

Resource Group
      |
      +-- VNet
      |    10.30.0.0/16
      |
      +-- Subnet
           10.30.1.0/24
                |
                +-- NSG
                     |
                     +-- VM
4. Virtual Network

Created:

vnet-az104-monitoring-01

Address space:

10.30.0.0/16
5. Subnet

Created:

snet-monitoring-01

Address range:

10.30.1.0/24

The subnet hosted the monitoring VM.

6. Network Security Group

Created:

nsg-monitoring-01

The NSG was associated with:

snet-monitoring-01
7. SSH Rule

The temporary lab used:

Name:
Allow-SSH


Priority:
100


Direction:
Inbound


Protocol:
TCP


Destination Port:
22


Access:
Allow

The purpose was administrative access to the VM during the lab.

8. Virtual Machine

Created:

vm-az104-monitoring-01

Region:

East US

OS:

Ubuntu 24.04 LTS

VM size:

Standard_D2ads_v7

Authentication:

SSH public key

Username:

azureuser
9. IP Configuration

Public IP:

20.127.48.107

Private IP:

10.30.1.4

The resulting path was:

Internet
   |
Public IP
   |
NIC
   |
Private IP
   |
Subnet
   |
VM
10. VM Health Baseline

The VM was verified with:

ProvisioningState/succeeded
Provisioning succeeded


PowerState/running
VM running

This established that the infrastructure itself was healthy before the performance experiment.

11. Monitoring Layers

The lab monitored several dimensions of VM behavior:

Compute
CPU


Network
Network In
Network Out


Storage
Disk Read
Disk Write


Infrastructure
VM health/state

This prevents troubleshooting from becoming CPU-only.

12. CPU Baseline

Recent useful CPU observations during the quiet period included values around:

4.815%
0.08%
0.065%
0.05%
0.055%

The overall interpretation was:

Quiet VM
   ↓
Very low CPU utilization

The important lesson was that one observation should not automatically define the baseline.

13. Network In Baseline

Recent Network In measurements included:

1,855,117
44,167
44,922
43,558

The measurements showed that normal traffic can fluctuate.

The interpretation was:

Typical low/moderate traffic
+
Occasional bursts

A single traffic spike should not automatically be treated as a problem.

14. Network Out Baseline

Recent Network Out measurements included:

200,602
85,734
58,397
53,263
58,802
144,121

Again, the traffic pattern showed variability.

The lesson:

Baseline is a pattern, not one fixed number.

15. Disk Read Baseline

Disk reads were mostly low or zero with intermittent bursts.

Observed examples included:

0
127,469,778.95
69,631.62
802,842.7
50,504,961.94

The interpretation was:

Mostly quiet disk reads
+
Occasional bursts

A single large disk-read value does not automatically indicate a storage problem.

16. Disk Write Baseline

Observed disk-write values included:

0
915,371,918.19
413,734.69
311,293.69
102,376.8
618,492.64
200,710.67
27,228,690.86

The pattern again demonstrated:

Low/moderate normal activity
+
Occasional bursts

The key lesson is to use trends and patterns rather than one isolated data point.

17. Baseline vs Alert Threshold

These are different concepts.

Baseline

Answers:

What normally happens?

Alert Threshold

Answers:

When should someone investigate?

Example from this lab:

Baseline:
CPU near idle


Alert:
Average CPU > 80%
for 5 minutes

The alert threshold was intentionally far above the observed quiet baseline.

18. Monitoring vs Alerting

Monitoring:

What is happening?

Alerting:

When should someone be notified or investigate?

Monitoring collects evidence.

Alerting turns abnormal behavior into an operational signal.

19. CPU Alert

Created:

alert-vm-high-cpu-01

Description:

Alert when VM CPU remains above 80 percent for 5 minutes

Configuration:

Metric:
Percentage CPU


Operator:
Greater Than


Threshold:
80


Aggregation:
Average


Evaluation Frequency:
1 minute


Window:
5 minutes


Severity:
2

The alert was enabled.

20. Controlled Incident

A controlled CPU workload was introduced using Azure VM Run Command.

The workload was:

for i in 1 2; do yes > /dev/null & done

This created CPU-consuming processes.

The running processes were later verified using:

ps -eo pid,comm,args

The VM showed processes similar to:

1552 yes yes
1553 yes yes

This established the source of the artificial CPU load.

21. CPU Incident

CPU transitioned from the quiet baseline to high utilization.

Observed progression included:

0.06%
   ↓
49.74%
   ↓
99.485%
   ↓
99.5%

The high CPU condition remained sustained for many minutes.

Examples included:

17:27 → 99.485%
17:28 → 99.500%
17:29 → 99.485%
...
17:43 → 99.495%

This clearly exceeded the alert threshold.

22. Alert Fired

Azure Portal showed:

alert-vm-high-cpu-01
Severity: 2 - Warning
Affected Resource:
vm-az104-monitoring-01


Alert Condition:
Fired

This provided direct evidence that the monitoring system detected the sustained CPU condition.

23. Investigation

The investigation used Azure Run Command to inspect running processes.

The high CPU condition was traced to the artificial:

yes

processes.

This demonstrated a simple incident investigation chain:

Metric anomaly
     ↓
Alert
     ↓
Inspect VM
     ↓
Inspect processes
     ↓
Identify source
24. Remediation

The runaway processes were stopped using:

pkill yes || true

This was performed using Azure VM Run Command.

The remediation was deliberately targeted at the identified cause.

25. CPU Recovery

After remediation, CPU fell dramatically:

17:45 → 99.475%
17:46 → 9.295%
17:47 → 0.245%

This returned the VM close to its previous quiet baseline.

This provided evidence that the remediation worked.

26. Alert Lifecycle

The incident lifecycle was:

Healthy
   ↓
CPU anomaly
   ↓
CPU > 80%
   ↓
Sustained for 5 minutes
   ↓
Alert Fired
   ↓
Investigate
   ↓
Identify runaway process
   ↓
Stop process
   ↓
CPU returns to baseline
   ↓
Alert Resolves

This demonstrates a complete monitoring and operations workflow.

27. Activity Log

The Azure Activity Log was also inspected.

This represents a different monitoring dimension from performance metrics.

Metrics

What is the resource doing?

Examples:

CPU
Network
Disk
Activity Log

What happened to the Azure resource?

Examples:

Create
Update
Restart
Stop
Delete
Configuration change

The Activity Log provides management-plane history.

28. Monitoring vs Operations

The lab demonstrated that monitoring alone is not enough.

Monitoring
    ↓
Observe


Alerting
    ↓
Detect


Investigation
    ↓
Explain


Remediation
    ↓
Fix


Verification
    ↓
Prove recovery

This is the operational mindset expected in production cloud environments.

29. Troubleshooting Model

When users report application slowness:

User report
    ↓
Latency
    ↓
CPU
    ↓
Network
    ↓
Disk
    ↓
VM health
    ↓
Application

The goal is to identify the first abnormal layer.

Examples:

CPU problem
CPU high
Network normal
Disk normal

Possible direction:

Compute saturation
Network problem
CPU normal
Disk normal
Network latency abnormal

Possible direction:

Network path / connectivity
Disk problem
CPU normal
Network normal
Disk activity / latency abnormal

Possible direction:

Storage bottleneck
VM health problem
Performance metrics normal
VM health abnormal

Possible direction:

Platform / VM state issue
30. Baseline Principles

A useful baseline should consider:

Multiple measurements
Typical range
Normal variability
Time of day
Workload patterns

Baseline is not:

One number

Baseline is:

Normal behavior over time
31. Important Lessons
A baseline provides a reference for healthy behavior.
Monitoring should use multiple signals.
CPU alone does not explain every performance problem.
Network and disk activity naturally fluctuate.
One spike should not automatically become an incident.
Alert thresholds should be meaningfully above normal behavior.
Time windows help prevent alerts from reacting to short-lived spikes.
Alerts should lead to investigation.
Run Command can be useful during VM troubleshooting.
Root cause should be demonstrated rather than guessed.
Recovery should be measured after remediation.
Activity Log and performance metrics answer different questions.
The full operations cycle is:
Monitor
→ Detect
→ Investigate
→ Remediate
→ Verify
32. Final Cleanup

The entire temporary monitoring environment was deleted:

rg-az104-vm-monitoring-01

Final verification:

az group exists --name rg-az104-vm-monitoring-01

Result:

false

This confirmed that the temporary VM, networking resources, NSG, public IP, alert, and supporting resources were removed.