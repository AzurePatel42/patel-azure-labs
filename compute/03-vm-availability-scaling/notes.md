# Compute Module 03 — VM Availability & Scaling

## Objective

Build a complete Azure VM availability and scaling architecture from scratch.

The lab focused on:

- Virtual Networks
- Subnets
- Network Security Groups
- Load Balancers
- Health Probes
- VM Scale Sets
- Availability Zones
- Autoscaling
- CPU metrics
- Scale-out
- Scale-in
- Minimum and maximum capacity
- Load distribution
- Resource cleanup

The environment was intentionally built layer-by-layer rather than relying on a single VMSS wizard to hide the underlying architecture.

---

# 1. Architecture Goal

Customer scenario:

> A stateless application must remain available if an availability zone fails. Traffic can increase significantly, but the customer wants to control infrastructure cost.

The architecture therefore needed:

```text
Availability
    ↓
Availability Zones

Traffic Distribution
    ↓
Load Balancer

Capacity Management
    ↓
VM Scale Set

Elasticity
    ↓
Autoscaling



2. Target Architecture
                         Internet
                            |
                            v
                    Public IP / Frontend
                            |
                            v
                     Load Balancer
                            |
                     Backend Pool
                            |
              +-------------+-------------+
              |                           |
              v                           v
          Availability Zone 1         Availability Zone 2
              |                           |
          VMSS Instance 0             VMSS Instance 1
              |                           |
              +-------------+-------------+
                            |
                       Stateless API

The VM Scale Set was configured across:

Zone 1
Zone 2
3. Resource Group

Created:

rg-az104-vm-scaling-01

Region:

East US

The resource group contained the complete temporary scaling lab.

4. Virtual Network

Created:

vnet-az104-scaling-01

Address space:

10.20.0.0/16
5. Subnet

Created:

snet-vmss-01

Address range:

10.20.1.0/24

Network structure:

VNet
10.20.0.0/16
    |
    └── snet-vmss-01
        10.20.1.0/24
6. Network Security Group

Created:

nsg-vmss-01

The NSG was associated with:

snet-vmss-01
7. HTTP Security Rule

The application path used HTTP on TCP port 80.

Rule:

Name:
Allow-HTTP


Priority:
100


Direction:
Inbound


Access:
Allow


Protocol:
TCP


Destination Port:
80

SSH was not exposed as the primary application path for this lab.

The focus was on:

Internet
    |
Load Balancer
    |
HTTP 80
    |
VMSS
8. Load Balancer

Created:

lb-vmss-01

SKU:

Standard

Frontend:

lb-frontend

Backend pool:

vmss-backend-pool

The Load Balancer provided traffic distribution across VMSS instances.

9. Public IP

Created for the Load Balancer:

lb-vmss-public-ip

SKU:

Standard

Allocation:

Static

The public IP was attached to the Load Balancer frontend.

10. Health Probe

Created:

http-health-probe

Configuration:

Protocol:
HTTP


Port:
80


Path:
/


Interval:
15 seconds


Number of probes:
2


Probe threshold:
1

Provisioning state:

Succeeded

The health probe allows the Load Balancer to determine whether an instance is healthy enough to receive traffic.

Conceptually:

Load Balancer
      |
      +---- VM healthy? ---- YES → receive traffic
      |
      +---- VM healthy? ---- NO  → remove from traffic path
11. Load-Balancing Rule

Created:

http-load-balancing-rule

Configuration:

Protocol:
TCP


Frontend Port:
80


Backend Port:
80


Health Probe:
http-health-probe


Backend Pool:
vmss-backend-pool

This connected the Load Balancer frontend to the VMSS backend instances.

12. VM Scale Set

Created:

vmss-az104-01

Orchestration mode:

Uniform

VM image:

Ubuntu 24.04 LTS

VM size:

Standard_D2ads_v7

Upgrade policy:

Automatic

Initial capacity:

2

Configured zones:

1
2
13. Initial VMSS State

Initial capacity:

2

Instances:

Instance 0 → Zone 1
Instance 1 → Zone 2

Both instances reached:

ProvisioningState:
Succeeded

Both instances were running.

This established the baseline availability architecture.

14. Availability Zones

The lab demonstrated the difference between capacity and availability.

The two baseline instances were distributed across:

Zone 1
Zone 2

This means the application does not depend on a single availability zone.

The design is:

Zone 1
VMSS Instance
      |
      +---- Application


Zone 2
VMSS Instance
      |
      +---- Application

The instances are active redundant capacity rather than a traditional backup instance.

15. Autoscale Policy

Created:

autoscale-vmss-01

Capacity settings:

Minimum:
2


Default:
2


Maximum:
4

The minimum of 2 was intentionally chosen to preserve the availability requirement.

The maximum of 4 was used to control cost in the lab.

16. Scale-Out Rule

Metric:

Percentage CPU

Condition:

CPU > 70%

Evaluation window:

5 minutes

Action:

Increase instance count by 1

Cooldown:

5 minutes

Concept:

Sustained high CPU
       |
       v
Scale OUT
       |
       v
+1 instance
17. Scale-In Rule

Metric:

Percentage CPU

Condition:

CPU < 30%

Evaluation window:

5 minutes

Action:

Decrease instance count by 1

Cooldown:

5 minutes

The minimum capacity remained:

2

Therefore:

4 → 3 → 2

was possible, but:

2 → 1

was not allowed by the autoscale profile.

18. CPU Baseline

Before introducing artificial CPU load, the VMSS CPU metric was very low.

Typical values were approximately:

0.1% – 0.3%

This established the low-load baseline.

The baseline was important because it allowed the effect of the controlled workload to be observed clearly.

19. Controlled CPU Load

A CPU workload was intentionally introduced using VMSS Run Command.

The purpose was to create sustained pressure on the VMSS CPU metric without manually changing the VMSS capacity.

The experiment followed this pattern:

Normal Load
     |
     v
Introduce CPU Load
     |
     v
Monitor Percentage CPU
     |
     v
Cross autoscale threshold
     |
     v
Observe scale-out
20. Scale-Out Experiment

CPU readings increased substantially after the workload was introduced.

The observed progression included:

~0.1%
   ↓
14.9%
   ↓
49.9%
   ↓
~99.6%

The VMSS then automatically scaled:

2 → 3

This demonstrated the scale-out policy working in Azure.

21. Continued Scale-Out

The elevated CPU condition continued.

The VMSS subsequently reached:

3 → 4

The configured maximum was:

4

Therefore the platform stopped adding instances after reaching the maximum capacity.

This demonstrated the importance of a maximum capacity guardrail.

22. Four-Instance Zone Distribution

At maximum capacity the VMSS contained:

Instance 0 → Zone 1
Instance 1 → Zone 2
Instance 2 → Zone 1
Instance 3 → Zone 2

The distribution was:

Zone 1
├── Instance 0
└── Instance 2


Zone 2
├── Instance 1
└── Instance 3

This provided a useful demonstration that multiple VMSS instances can be distributed across the configured availability zones as the scale set grows.

23. Scale-In Experiment

After the artificial CPU workload was stopped, CPU utilization decreased.

The VMSS began scaling back toward the configured minimum.

Observed capacity changes:

4 → 3

and eventually:

3 → 2

The VMSS did not scale below:

2

This demonstrated that autoscaling respects the configured minimum capacity.

24. Final Steady State

The final VMSS state returned to:

Capacity:
2

Instances:

Instance 0 → Zone 1 → Succeeded
Instance 1 → Zone 2 → Succeeded

This restored the intended cost-efficient baseline while preserving multi-zone availability.

25. Availability vs Scaling

This lab reinforced an important architectural distinction.

Availability Zones

Answer:

What happens if an infrastructure failure affects one zone?

VM Scale Set

Answers:

How do we manage identical compute instances as a group?

Autoscaling

Answers:

What happens when workload increases or decreases?

Load Balancer

Answers:

Where should incoming traffic be sent?

These are separate architectural responsibilities.

26. Cost Optimization

The architecture intentionally maintained:

Minimum:
2

instead of constantly running:

4

The platform could scale to:

3
4

when demand increased and then return toward:

2

when demand decreased.

This demonstrates elasticity:

Low demand
   ↓
2 instances


High demand
   ↓
3–4 instances


Low demand again
   ↓
2 instances
27. Why Threshold + Time Matters

The lab demonstrated why a scaling rule should not necessarily react to one instantaneous spike.

The scale-out condition required:

CPU > 70%
for 5 minutes

The scale-in condition required:

CPU < 30%
for 5 minutes

This introduces stability into the scaling policy.

The cooldown was:

5 minutes

The overall design was therefore:

Metric
  +
Threshold
  +
Time Window
  +
Cooldown
  +
Minimum / Maximum
28. Important Production Consideration

CPU was used for this lab because it is simple to generate and observe.

For a real stateless backend API, CPU is not necessarily the best scaling signal.

Possible production signals could include:

Requests per instance
Request latency
Queue depth
Application-specific metrics
CPU utilization

The correct metric depends on what actually represents workload pressure for the application.

29. Troubleshooting Model

When a load-balanced VMSS application is unhealthy, investigate layer by layer:

Client
   ↓
DNS / Public endpoint
   ↓
Load Balancer
   ↓
Frontend
   ↓
Load-balancing rule
   ↓
Health Probe
   ↓
Backend Pool
   ↓
VMSS Instance
   ↓
NSG
   ↓
Application

This prevents random troubleshooting.

30. Lab Lifecycle

The full experiment followed:

Design
   ↓
Build networking
   ↓
Build NSG
   ↓
Build Load Balancer
   ↓
Build health probe
   ↓
Build VMSS
   ↓
Distribute instances across zones
   ↓
Configure autoscale
   ↓
Generate load
   ↓
Scale OUT
   ↓
Reach maximum
   ↓
Remove load
   ↓
Scale IN
   ↓
Restore 2-instance baseline
   ↓
Cleanup
31. Cleanup

The entire temporary resource group was deleted:

rg-az104-vm-scaling-01

Final verification:

az group exists --name rg-az104-vm-scaling-01

Result:

false

This confirmed that the temporary VMSS, Load Balancer, VNet, NSG, public IP, and supporting resources were removed.

Key Lessons
Availability Zones provide failure-domain separation.
VM Scale Sets manage groups of identical VM instances.
Load Balancers distribute incoming traffic.
Health probes determine backend health.
Autoscaling responds to workload changes.
Minimum capacity protects baseline availability.
Maximum capacity limits cost and runaway scaling.
Thresholds should often be combined with sustained time windows.
Cooldowns help avoid rapid scaling oscillation.
Scaling and availability are separate architectural concerns.
The right scaling metric depends on the application workload.
Real scaling behavior is best understood by observing an actual scale-out and scale-in cycle.