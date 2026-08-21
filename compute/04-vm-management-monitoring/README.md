# Compute Module 04 — VM Management, Monitoring & Operations

## Overview

This lab demonstrates a complete Azure VM monitoring and incident-response workflow.

The environment was built manually with Azure CLI and then monitored using Azure Monitor.

The lab covers:

- Virtual Networks
- Subnets
- Network Security Groups
- Virtual Machines
- Azure Monitor Metrics
- Monitoring baselines
- CPU monitoring
- Network monitoring
- Disk monitoring
- VM health
- Metric alerts
- Alert instances
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



Architecture
                         Internet
                            |
                        Public IP
                            |
                           NIC
                            |
                     Monitoring VM
                            |
                    Ubuntu 24.04 LTS
                            |
                 +----------+----------+
                 |          |          |
                 ↓          ↓          ↓
               CPU       Network      Disk
                 |          |          |
                 +----------+----------+
                            |
                      Azure Monitor
                            |
                       Metric Alert
                            |
                      Alert Instance
                            |
                       Investigation
                            |
                      Remediation
                            |
                      Recovery Check
Resource Configuration
Component	Configuration
Resource Group	rg-az104-vm-monitoring-01
Region	East US
VNet	vnet-az104-monitoring-01
VNet Address Space	10.30.0.0/16
Subnet	snet-monitoring-01
Subnet Range	10.30.1.0/24
NSG	nsg-monitoring-01
VM	vm-az104-monitoring-01
Public IP	20.127.48.107
Private IP	10.30.1.4
OS	Ubuntu 24.04 LTS
VM Size	Standard_D2ads_v7
SSH Port	TCP 22
Alert	alert-vm-high-cpu-01
Alert Severity	2
CPU Threshold	> 80%
Evaluation Frequency	1 minute
Alert Window	5 minutes
Baseline-Driven Monitoring

A baseline is a reference for normal system behavior.

It is not necessarily one fixed number.

A useful baseline considers:

Normal range
+
Normal variability
+
Multiple observations
+
Workload patterns
+
Time context

The lab established baselines before intentionally introducing a performance problem.

CPU Baseline

Quiet-period CPU readings were approximately:

4.815%
0.08%
0.065%
0.05%
0.055%

The interpretation was:

Quiet VM
   ↓
Very low CPU utilization

The important lesson is that one data point should not define the baseline.

Network Baseline

Network In and Network Out were monitored separately.

Example Network In observations:

1,855,117
44,167
44,922
43,558

Example Network Out observations:

200,602
85,734
58,397
53,263
58,802
144,121

The traffic naturally fluctuated.

Therefore:

A baseline is a pattern, not one fixed number.

Disk Baseline

Disk Read and Disk Write were also observed before the incident.

Disk reads were mostly low with intermittent bursts.

Disk writes showed ongoing low/moderate activity with occasional larger bursts.

The key lesson:

A single disk spike does not automatically mean the VM has a storage problem.

VM Health Baseline

The VM was verified as:

ProvisioningState/succeeded
PowerState/running

This established a healthy infrastructure starting point.

Monitoring vs Alerting

Monitoring answers:

What is happening?

Examples:

CPU
Network
Disk
VM state

Alerting answers:

When should someone investigate?

For this lab:

Average CPU > 80%
for a 5-minute window

was considered an actionable abnormal condition.

CPU Alert

The metric alert was:

Name:
alert-vm-high-cpu-01


Metric:
Percentage CPU


Operator:
Greater Than


Threshold:
80%


Aggregation:
Average


Evaluation Frequency:
1 minute


Window:
5 minutes


Severity:
2

The alert was created without a notification action group because the purpose of the lab was to demonstrate the alert lifecycle itself.

Controlled Incident

A deliberate CPU workload was introduced using VM Run Command.

The workload created two yes processes:

yes > /dev/null

The processes were then verified from the guest OS.

This created a controlled incident rather than waiting for a random failure.

Incident Timeline

The VM started from a healthy baseline:

~0–5% CPU

The workload then increased CPU utilization:

0.05%
   ↓
49.74%
   ↓
99.485%
   ↓
~99.5%

The CPU remained near 100% for an extended period.

This was far outside the established quiet-period baseline.

Alert Fired

Azure Monitor detected the sustained abnormal condition.

The Azure Portal showed:

alert-vm-high-cpu-01


Severity:
2 - Warning


Affected Resource:
vm-az104-monitoring-01


Condition:
Fired

This provided direct evidence that Azure Monitor converted the metric anomaly into an operational alert.

Investigation

The investigation followed:

Metric anomaly
      ↓
Alert
      ↓
Inspect VM
      ↓
Inspect running processes
      ↓
Identify workload

The runaway CPU condition was traced to the deliberately created:

yes

processes.

This demonstrated an important troubleshooting principle:

Do not guess the root cause. Prove it.

Remediation

The identified CPU-consuming processes were stopped using Azure VM Run Command.

The remediation was targeted directly at the identified cause.

Recovery

After the CPU workload was stopped, CPU utilization rapidly returned toward the original baseline.

Observed recovery:

17:45 → 99.475%
17:46 → 9.295%
17:47 → 0.245%

This demonstrated successful remediation.

The VM then returned to its normal healthy state.

Alert Lifecycle

The complete operational lifecycle was:

Healthy Baseline
      ↓
CPU Anomaly
      ↓
Sustained >80%
      ↓
Alert Fired
      ↓
Investigate
      ↓
Identify Runaway Process
      ↓
Remediate
      ↓
CPU Returns Toward Baseline
      ↓
Alert Resolves
      ↓
Recovery Verified

This is the core operational workflow practiced in the module.

Activity Log

The Azure Activity Log was also reviewed.

The Activity Log answers a different question from metrics.

Azure Monitor Metrics

What is the resource doing?

Examples:

CPU
Network
Disk
Azure Activity Log

What happened to the Azure resource?

Examples:

Create
Update
Restart
Stop
Delete
Configuration changes

This distinction is important when troubleshooting Azure infrastructure.

Troubleshooting Model

When users report that an application is slow, investigate systematically:

User Report
     ↓
Latency
     ↓
CPU
     ↓
Network
     ↓
Disk
     ↓
VM Health
     ↓
Application

Do not assume:

High CPU = root cause

Instead:

Observe
   ↓
Correlate
   ↓
Isolate
   ↓
Prove
Example Diagnostic Paths
High CPU
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
Disk latency/activity abnormal

Possible direction:

Storage bottleneck
VM health problem
Performance metrics normal
VM health abnormal

Possible direction:

Platform / VM state issue
Operational Engineering Pattern

This lab demonstrates the difference between simply monitoring a system and operating one.

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

The goal is not just to know that something is wrong.

The goal is to:

Detect the abnormal condition.
Identify what layer is responsible.
Prove the cause.
Correct the cause.
Verify that the system recovered.
Key Lessons
A baseline is a reference for normal system behavior.
A baseline should be based on patterns and multiple observations.
CPU alone cannot explain every performance problem.
Network and disk metrics naturally fluctuate.
One isolated metric spike does not automatically indicate an incident.
Alert thresholds should be meaningfully above expected baseline behavior.
Time windows help prevent alerts from reacting to short-lived spikes.
Alert definitions and alert instances are different concepts.
Run Command can be useful for live VM troubleshooting.
Root cause should be demonstrated rather than assumed.
Recovery should be measured after remediation.
Activity Log provides management-plane history.
Metrics provide performance evidence.
Effective operations follows:
Monitor
→ Detect
→ Investigate
→ Remediate
→ Verify
Screenshot Evidence

The lab includes evidence for:

01-resource-group.png
02-vnet.png
03-subnet.png
04-nsg.png
05-nsg-ssh-rule.png
06-subnet-nsg-association.png
07-public-ip.png
08-nic-ip-config.png
09-vm-created.png
10-vm-verification.png
11-cpu-baseline.png
12-network-in-baseline.png
13-network-out-baseline.png
14-disk-read-baseline.png
15-disk-write-baseline.png
16-vm-health-baseline.png
17-cpu-alert-created.png
18-cpu-load-rising.png
19-cpu-alert-fired.png
20-cpu-recovery.png
21-cpu-alert-resolved.png
22-activity-log.png
23-cleanup-resource-group.png
Cleanup

The complete temporary monitoring environment was deleted after the experiment:

rg-az104-vm-monitoring-01

Final verification:

az group exists --name rg-az104-vm-monitoring-01

Result:

false

This confirmed cleanup of the VM, networking resources, NSG, public IP, alert, and supporting resources.