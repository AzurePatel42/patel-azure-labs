# Compute Module 03 — VM Availability & Scaling

## Overview

This lab demonstrates how to design, build, monitor, and troubleshoot a highly available Azure compute architecture using:

- Azure Virtual Networks
- Subnets
- Network Security Groups
- Standard Load Balancer
- Health Probes
- VM Scale Sets
- Availability Zones
- Azure Monitor metrics
- Autoscaling
- Scale-out and scale-in behavior
- Capacity guardrails
- Resource cleanup

The environment was built manually with Azure CLI so that the relationship between the individual Azure resources was visible.

---

## Architecture

```text
                         Internet
                            |
                       Public IP
                            |
                     Standard Load
                       Balancer
                            |
                      Backend Pool
                            |
             +--------------+--------------+
             |                             |
             v                             v
         Zone 1                         Zone 2
      VMSS Instance 0               VMSS Instance 1
             |                             |
             +--------------+--------------+
                            |
                      Stateless API



As workload increased, the VM Scale Set dynamically added additional instances.

Resource Configuration
Component	Configuration
Resource Group	rg-az104-vm-scaling-01
Region	East US
VNet	vnet-az104-scaling-01
VNet Address Space	10.20.0.0/16
Subnet	snet-vmss-01
Subnet Range	10.20.1.0/24
NSG	nsg-vmss-01
Application Port	TCP 80
Load Balancer	lb-vmss-01
Backend Pool	vmss-backend-pool
Health Probe	http-health-probe
VM Scale Set	vmss-az104-01
VM Image	Ubuntu 24.04 LTS
VM Size	Standard_D2ads_v7
Availability Zones	1 and 2
Minimum Instances	2
Default Instances	2
Maximum Instances	4
Availability Design

The customer scenario required the application to remain available if one availability zone failed.

The baseline design therefore uses two active instances:

Zone 1
    |
Instance 0


Zone 2
    |
Instance 1

These are active redundant instances, not a traditional backup.

If one zone experiences a failure, the remaining zone can continue providing application capacity.

Load Balancer

The Standard Load Balancer provides the traffic-distribution layer.

Internet
   |
Public IP
   |
Load Balancer
   |
Backend Pool
   |
VMSS Instances

The load-balancing rule uses:

Frontend Port: 80
Backend Port: 80
Protocol: TCP

The backend pool is:

vmss-backend-pool
Health Probe

The Load Balancer uses an HTTP health probe:

Protocol: HTTP
Port: 80
Path: /
Interval: 15 seconds

The probe determines whether an instance is healthy enough to receive traffic.

Conceptually:

Healthy instance
      |
      +---- Receive traffic


Unhealthy instance
      |
      +---- Removed from traffic path
Network Security

The VMSS subnet is associated with:

nsg-vmss-01

The application rule allows:

Priority: 100
Direction: Inbound
Protocol: TCP
Destination Port: 80
Access: Allow

The application path therefore becomes:

Internet
   |
Load Balancer
   |
HTTP 80
   |
NSG
   |
VMSS
VM Scale Set

The VM Scale Set was created with:

Orchestration:
Uniform


Initial Capacity:
2


Zones:
1, 2


Upgrade Policy:
Automatic

Initial placement:

Instance 0 → Zone 1
Instance 1 → Zone 2

Both instances reached:

ProvisioningState: Succeeded
Autoscale Policy

The autoscale configuration was intentionally designed with availability and cost in mind.

Minimum: 2
Default: 2
Maximum: 4

This means:

Minimum
   ↓
Protect baseline availability


Maximum
   ↓
Control cost and runaway scaling
Scale-Out Rule

The scale-out condition was:

Metric:
Percentage CPU


Condition:
CPU > 70%


Evaluation Window:
5 minutes


Action:
Increase instance count by 1


Cooldown:
5 minutes

Conceptually:

Sustained CPU > 70%
        |
        v
   Scale OUT
        |
        v
   +1 instance
Scale-In Rule

The scale-in condition was:

Metric:
Percentage CPU


Condition:
CPU < 30%


Evaluation Window:
5 minutes


Action:
Decrease instance count by 1


Cooldown:
5 minutes

Because the minimum capacity is 2:

4 → 3 → 2

is allowed, while:

2 → 1

is not.

Autoscaling Experiment
Baseline

The VMSS initially operated at:

2 instances

CPU utilization was approximately:

0.1% – 0.3%

This established a low-load baseline.

Controlled Load

A controlled CPU workload was introduced using VMSS Run Command.

CPU utilization increased through stages including approximately:

0.1%
   ↓
14.9%
   ↓
49.9%
   ↓
~99.6%

This provided a real workload signal for Azure Monitor.

Scale-Out

After the high CPU condition remained above the configured threshold, autoscaling increased capacity:

2 → 3

The CPU condition remained elevated, and the VMSS subsequently reached:

3 → 4

The maximum capacity of four instances was enforced.

Four-Instance Distribution

At maximum capacity, the VMSS was distributed as:

Zone 1
├── Instance 0
└── Instance 2


Zone 2
├── Instance 1
└── Instance 3

This demonstrated multi-zone capacity while scaling.

Scale-In

After the artificial CPU workload was stopped, CPU utilization decreased.

Autoscaling then reduced capacity:

4 → 3

and eventually:

3 → 2

The VMSS returned to the configured minimum capacity.

Final state:

Instance 0 → Zone 1
Instance 1 → Zone 2
What This Demonstrates

This lab demonstrates the difference between several architectural responsibilities.

Availability Zones

Protect against zone-level infrastructure failure.

VM Scale Set

Manages a group of VM instances as a single compute resource.

Load Balancer

Distributes incoming traffic across healthy backend instances.

Health Probe

Determines whether a backend instance should receive traffic.

Autoscaling

Adjusts compute capacity in response to workload.

Minimum Capacity

Protects the baseline availability requirement.

Maximum Capacity

Controls infrastructure cost and limits unbounded scaling.

Scaling Design Principle

A thoughtful autoscaling policy should consider:

Metric
+
Threshold
+
Sustained Duration
+
Cooldown
+
Minimum Capacity
+
Maximum Capacity

The lab deliberately used a five-minute evaluation window rather than reacting to an instantaneous spike.

This reduces unnecessary scaling reactions and helps prevent rapid oscillation.

Production Consideration

CPU utilization was used for the hands-on lab because it was straightforward to generate and observe.

For a production stateless backend API, CPU is not automatically the best scaling signal.

Potential production signals include:

Requests per instance
Request latency
Queue depth
CPU utilization
Application-specific metrics

The best signal is the one most closely correlated with actual workload pressure and customer experience.

Troubleshooting Model

For a load-balanced VMSS application, troubleshoot from the outside inward:

Client
  |
DNS / Public Endpoint
  |
Load Balancer
  |
Frontend
  |
Load-Balancing Rule
  |
Health Probe
  |
Backend Pool
  |
VM Scale Set
  |
NSG
  |
Application

The goal is to identify the first broken layer instead of changing multiple resources at once.

Key Lessons
Availability and scalability solve different problems.
Availability Zones provide failure-domain separation.
VMSS provides compute grouping and instance management.
Load Balancers distribute traffic.
Health probes determine backend health.
Autoscaling responds to changing workload.
Minimum capacity protects baseline availability.
Maximum capacity controls cost.
Thresholds should be combined with time windows when appropriate.
Cooldowns help prevent rapid scale oscillation.
The correct scaling metric depends on the application workload.
Real scale-out and scale-in experiments provide much stronger understanding than configuration alone.
Screenshot Evidence

The lab includes evidence for:

01-resource-group.png
02-vnet.png
03-subnet.png
04-nsg.png
05-nsg-http-rule.png
06-subnet-nsg-association.png
07-load-balancer-public-ip.png
08-load-balancer.png
09-load-balancer-health-probe.png
10-load-balancing-rule.png
11-vmss-created.png
12-vmss-instances.png
13-vmss-zone-placement.png
14-backend-pool.png
15-health-probe.png
16-vmss-capacity-baseline.png
17-vmss-cpu-baseline.png
18-autoscale-profile.png
19-autoscale-rules.png
20-autoscale-policy.png
22-vmss-scale-out.png
23-vmss-scale-out-event.png
24-vmss-three-instances.png
25-vmss-max-capacity-reached.png
26-vmss-sclae-in-event.png
27-vmss-final-two-zone-state.png
28-load-balancer-final-verification.png
29-cleanup-resource-group.png

Cleanup

The complete temporary resource group was deleted after the lab:

rg-az104-vm-scaling-01

Final verification:

az group exists --name rg-az104-vm-scaling-01

Result:

false

This confirmed that the temporary VMSS, Load Balancer, networking resources, autoscale configuration, and supporting resources were removed.