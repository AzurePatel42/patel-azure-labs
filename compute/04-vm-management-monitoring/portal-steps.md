# Compute Module 04 — VM Management, Monitoring & Operations

## Objective

Build and operate an Azure VM monitoring environment through the Azure Portal.

The lab demonstrates:

- Virtual Networks
- Subnets
- Network Security Groups
- Virtual Machines
- Azure Monitor
- Metrics
- Baselines
- Metric Alerts
- Alert Instances
- Incident Investigation
- Run Command
- Activity Log
- Recovery Verification
- Cleanup

---

# 1. Resource Group

Navigate to:

**Azure Portal → Resource groups**

Create:

```text
rg-az104-vm-monitoring-01



2. Virtual Network

Navigate to:

Virtual Networks → Create

Configure:

Name:
vnet-az104-monitoring-01


Address space:
10.30.0.0/16
3. Subnet

Create:

Name:
snet-monitoring-01


Address range:
10.30.1.0/24

Result:

VNet
10.30.0.0/16
   |
   └── Subnet
       snet-monitoring-01
       10.30.1.0/24
4. Network Security Group

Navigate to:

Network Security Groups → Create

Create:

nsg-monitoring-01

Region:

East US
5. SSH Inbound Rule

Open:

nsg-monitoring-01 → Inbound security rules

Create:

Name:
Allow-SSH


Priority:
100


Source:
Any


Destination:
Any


Protocol:
TCP


Destination port:
22


Action:
Allow

This was temporary administrative access for the lab.

6. Associate NSG with Subnet

Navigate to:

Virtual Networks → vnet-az104-monitoring-01 → Subnets

Open:

snet-monitoring-01

Associate:

Network Security Group:
nsg-monitoring-01

Verify the subnet shows the NSG association.

7. Public IP

Navigate to:

Public IP addresses → Create

Configure:

Name:
pip-vm-monitoring-01


SKU:
Standard


Assignment:
Static


Region:
East US
8. Network Interface

Create or inspect:

nic-vm-monitoring-01

Verify:

VNet:
vnet-az104-monitoring-01


Subnet:
snet-monitoring-01


Public IP:
pip-vm-monitoring-01
9. Virtual Machine

Navigate to:

Virtual Machines → Create → Azure virtual machine

Configure:

Name:
vm-az104-monitoring-01


Region:
East US


Image:
Ubuntu 24.04 LTS


Size:
Standard_D2ads_v7

Authentication:

SSH public key


Username:
azureuser

The VM was connected to the previously created NIC.

10. Verify VM

Open:

Virtual Machine → Overview

Verify:

Power state:
Running


Public IP:
20.127.48.107


Private IP:
10.30.1.4

The VM was successfully running before the monitoring experiment began.

11. Monitoring Baseline

Open:

Azure Portal → Monitor → Metrics

Select:

vm-az104-monitoring-01

The lab established baseline observations for:

Percentage CPU
Network In Total
Network Out Total
Disk Read Bytes
Disk Write Bytes

The VM health baseline was also verified.

The purpose of the baseline is to answer:

What does normal behavior look like?

12. CPU Baseline

The quiet CPU baseline was very low.

Observed values included approximately:

4.815%
0.08%
0.065%
0.05%
0.055%

Interpretation:

Normal quiet-period CPU
≈ very low utilization

A single value should not be treated as the complete baseline.

13. Network Baseline

Monitor:

Network In Total
Network Out Total

The lab showed that network traffic naturally fluctuates.

Examples included:

Network In:
1,855,117
44,167
44,922
43,558

and:

Network Out:
200,602
85,734
58,397
53,263
58,802
144,121

The lesson was:

Baseline should describe normal behavior and variability, not one fixed number.

14. Disk Baseline

Monitor:

Disk Read Bytes
Disk Write Bytes

Disk reads were mostly low/idle with intermittent bursts.

Disk writes showed ongoing low/moderate activity with occasional larger bursts.

The purpose was to establish the normal storage behavior before introducing the controlled incident.

15. VM Health Baseline

Open:

Virtual Machine → Overview / Instance View

Verify:

Provisioning:
Succeeded


Power:
Running

The lab's final healthy state also showed:

ProvisioningState/succeeded
PowerState/running
16. Azure Monitor Alert

Navigate to:

Monitor → Alerts → Create → Alert rule

Select the monitoring VM as the resource.

Configure the condition:

Signal:
Percentage CPU


Operator:
Greater than


Threshold:
80%


Aggregation:
Average


Evaluation frequency:
1 minute


Lookback window:
5 minutes


Severity:
2

Alert name:

alert-vm-high-cpu-01

Description:

Alert when VM CPU remains above 80 percent for 5 minutes

The alert was created without an action group for this lab.

17. Understand the Alert

The alert definition answers:

When should Azure consider the VM's CPU condition abnormal?

The lab used:

Average CPU > 80%
for a 5-minute window

This was intentionally much higher than the quiet baseline.

18. Generate Controlled CPU Load

The lab deliberately introduced CPU load using Azure VM Run Command.

The workload created two CPU-consuming yes processes.

The goal was to simulate:

Normal VM
   ↓
Unexpected CPU pressure
   ↓
High CPU
   ↓
Monitoring alert
19. Monitor the Incident

Return to:

Monitor → Metrics

Observe:

Percentage CPU

The CPU increased through approximately:

Normal baseline
   ↓
49.74%
   ↓
~99.5%

The CPU then remained near 99.5% for an extended period.

20. Alert Instance

Navigate to:

Monitor → Alerts → Alert instances

Locate:

alert-vm-high-cpu-01

The lab observed:

Severity:
2 - Warning


Affected resource:
vm-az104-monitoring-01


Condition:
Fired

This demonstrates the distinction between:

Alert Rule

and:

Alert Instance

The rule defines the condition.

The alert instance represents the actual detected incident.

21. Investigate the VM

Use:

Virtual Machine → Run Command

Run a process inspection command.

The investigation found:

yes

processes consuming CPU.

The lab verified processes similar to:

1552 yes yes
1553 yes yes

This established the source of the controlled CPU incident.

22. Remediation

Use:

Virtual Machine → Run Command

Stop the artificial workload.

The remediation command terminated the yes processes.

This was intentionally targeted at the identified root cause.

23. Verify CPU Recovery

Return to:

Monitor → Metrics

Monitor:

Percentage CPU

Observed recovery:

~99.5%
   ↓
9.295%
   ↓
0.245%

The VM returned close to its previous quiet-period baseline.

24. Verify Alert Resolution

Return to:

Monitor → Alerts → Alert instances

Review:

alert-vm-high-cpu-01

Verify that the incident transitions from:

Fired

to:

Resolved

This completes the alert lifecycle.

25. Activity Log

Navigate to:

Monitor → Activity log

or:

Resource → Activity log

Review management-plane events.

Examples of events that Activity Log can capture include:

Create
Update
Restart
Stop
Delete
Configuration changes

Important distinction:

Metrics
"What is the resource doing?"


Activity Log
"What happened to the Azure resource?"
26. Troubleshooting Model

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

The objective is to identify the first abnormal layer.

Avoid assuming:

High CPU = root cause

Instead:

Observe
   ↓
Correlate
   ↓
Isolate
   ↓
Prove
27. Baseline vs Alert
Baseline

What does normal behavior look like?

Alert

When should someone investigate?

Example:

Baseline:
CPU normally near idle


Alert:
CPU > 80%
for 5 minutes

These are separate concepts.

28. Monitoring vs Operations

The lab followed this workflow:

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

This is the core operational pattern practiced in the module.

29. Final VM Health Check

Before cleanup:

Virtual Machine → Overview

Confirm:

Power state:
Running

Confirm that the performance condition has been remediated.

30. Cleanup

Navigate to:

Resource groups

Select:

rg-az104-vm-monitoring-01

Choose:

Delete resource group

Confirm deletion.

CLI verification:

az group exists --name rg-az104-vm-monitoring-01

Expected:

false

This confirms cleanup of the temporary monitoring environment.

Screenshot Evidence

Recommended evidence:

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