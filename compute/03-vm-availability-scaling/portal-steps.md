# Compute Module 03 — VM Availability & Scaling

## Objective

Build and verify an Azure VM availability and scaling architecture through the Azure Portal.

The lab demonstrates:

- Virtual Networks
- Subnets
- Network Security Groups
- Load Balancers
- Public IPs
- Health Probes
- Backend Pools
- VM Scale Sets
- Availability Zones
- Autoscaling
- Scale-out
- Scale-in
- Capacity limits
- Final cleanup

---

# 1. Resource Group

Navigate to:

**Azure Portal → Resource groups**

Create:

```text
rg-az104-vm-scaling-01


Region:

East US

Verify the resource group exists.

2. Virtual Network

Navigate to:

Virtual Networks → Create

Configure:

Name:
vnet-az104-scaling-01


Address space:
10.20.0.0/16
3. Subnet

Create:

Name:
snet-vmss-01


Address range:
10.20.1.0/24

Result:

VNet
10.20.0.0/16
   |
   └── snet-vmss-01
       10.20.1.0/24
4. Network Security Group

Navigate to:

Network Security Groups → Create

Create:

nsg-vmss-01

Region:

East US
5. HTTP Inbound Rule

Open:

nsg-vmss-01 → Inbound security rules

Create:

Name:
Allow-HTTP


Priority:
100


Source:
Any


Destination:
Any


Protocol:
TCP


Destination port:
80


Action:
Allow

The application path for this lab is HTTP on TCP port 80.

6. Associate NSG with Subnet

Navigate to:

Virtual Networks → vnet-az104-scaling-01 → Subnets → snet-vmss-01

Associate:

Network Security Group:
nsg-vmss-01

Verify the subnet shows the NSG association.

7. Load Balancer Public IP

Navigate to:

Public IP addresses → Create

Configure:

Name:
lb-vmss-public-ip


SKU:
Standard


Assignment:
Static


Region:
East US

The public IP will be used by the Load Balancer frontend.

8. Load Balancer

Navigate to:

Load Balancers → Create

Configure:

Name:
lb-vmss-01


SKU:
Standard


Region:
East US

Frontend:

Name:
lb-frontend


Public IP:
lb-vmss-public-ip

Backend pool:

Name:
vmss-backend-pool
9. Health Probe

Open:

Load Balancer → Health probes

Create:

Name:
http-health-probe


Protocol:
HTTP


Port:
80


Path:
/


Interval:
15 seconds


Probe threshold:
1

The health probe determines whether a backend instance is healthy enough to receive traffic.

Conceptually:

Load Balancer
     |
     +---- Instance healthy → Traffic allowed
     |
     +---- Instance unhealthy → Traffic removed
10. Load-Balancing Rule

Open:

Load Balancer → Load balancing rules

Create:

Name:
http-load-balancing-rule


Protocol:
TCP


Frontend IP:
lb-frontend


Frontend port:
80


Backend pool:
vmss-backend-pool


Backend port:
80


Health probe:
http-health-probe

This creates the traffic path:

Internet
   |
Load Balancer
   |
Port 80
   |
Backend Pool
   |
VMSS Instances
11. VM Scale Set

Navigate to:

Virtual Machine Scale Sets → Create

Configure:

Name:
vmss-az104-01


Region:
East US


Image:
Ubuntu 24.04 LTS


VM Size:
Standard_D2ads_v7

Authentication:

SSH public key
Username:
azureuser
12. Availability Zones

During VMSS configuration, configure zone placement:

Zone 1
Zone 2

Initial capacity:

2 instances

The desired baseline becomes:

Zone 1 → Instance 0
Zone 2 → Instance 1

The goal is to maintain active redundant capacity across separate availability zones.

13. Networking

Connect the VMSS to:

Virtual network:
vnet-az104-scaling-01


Subnet:
snet-vmss-01

Attach the VMSS to:

Load Balancer:
lb-vmss-01


Backend pool:
vmss-backend-pool

The resulting architecture is:

Internet
   |
Public IP
   |
Load Balancer
   |
Backend Pool
   |
+-----------------------+
|                       |
Zone 1                Zone 2
Instance 0            Instance 1
+-----------------------+
14. Verify VMSS

Open:

VM Scale Set → Overview

Verify:

Capacity:
2


Zones:
1, 2


Upgrade policy:
Automatic
15. Verify Instances

Open:

VM Scale Set → Instances

Verify:

Instance 0
Running


Instance 1
Running

Verify that the instances are distributed across the configured availability zones.

16. Verify Load Balancer Backend

Open:

Load Balancer → Backend pools

Verify:

vmss-backend-pool

The VMSS should be associated with the backend pool.

17. Verify Health Probe

Open:

Load Balancer → Health probes

Verify:

Protocol:
HTTP


Port:
80


Path:
/


Provisioning:
Succeeded
18. Autoscale Configuration

Open:

VM Scale Set → Scaling

Enable autoscale.

Configure the capacity profile:

Minimum:
2


Default:
2


Maximum:
4

The minimum of 2 preserves the availability baseline.

The maximum of 4 limits cost and uncontrolled growth.

19. Scale-Out Rule

Configure:

Metric:
Percentage CPU


Operator:
Greater than


Threshold:
70%


Duration:
5 minutes


Action:
Increase instance count by 1

Cooldown:

5 minutes

Concept:

CPU > 70%
for 5 minutes
      |
      v
Scale OUT
      |
      v
+1 instance
20. Scale-In Rule

Configure:

Metric:
Percentage CPU


Operator:
Less than


Threshold:
30%


Duration:
5 minutes


Action:
Decrease instance count by 1

Cooldown:

5 minutes

The minimum capacity remains:

2

Therefore:

4 → 3 → 2

is allowed.

But:

2 → 1

is not allowed.

21. Review Autoscale Policy

The completed policy should be:

Minimum: 2
Default: 2
Maximum: 4

Scale out:

CPU > 70%
5 minutes
+1 instance
5-minute cooldown

Scale in:

CPU < 30%
5 minutes
-1 instance
5-minute cooldown
22. CPU Monitoring

Open:

VM Scale Set → Monitoring → Metrics

Select:

Percentage CPU

Use an appropriate time range to observe workload behavior.

Initial baseline in the lab was very low.

23. Controlled Load Test

The lab used VMSS Run Command to introduce controlled CPU load.

The experiment was:

Normal CPU
   |
CPU workload introduced
   |
CPU rises
   |
Autoscale threshold crossed

The workload caused CPU utilization to rise dramatically.

24. Observe Scale-Out

The VMSS initially had:

2 instances

During sustained high CPU utilization, autoscale increased capacity:

2 → 3

and eventually:

3 → 4

The maximum capacity was enforced at:

4
25. Verify Four-Instance Distribution

Open:

VM Scale Set → Instances

The lab reached:

Zone 1
├── Instance 0
└── Instance 2


Zone 2
├── Instance 1
└── Instance 3

This demonstrated multi-zone capacity while scaling.

26. Stop Artificial Load

After verifying scale-out, remove the artificial CPU workload.

The purpose is to allow CPU utilization to fall below the scale-in threshold.

27. Observe Scale-In

Monitor:

Percentage CPU

As CPU remained below the scale-in threshold for the required duration, autoscale reduced capacity:

4 → 3

and eventually:

3 → 2
28. Verify Final State

The final VMSS state should return to:

Capacity:
2

Instances:

Instance 0 → Zone 1
Instance 1 → Zone 2

Both should be:

Running
29. Architecture Summary

Final architecture:

                         Internet
                            |
                       Public IP
                            |
                      Load Balancer
                            |
                      Backend Pool
                            |
              +-------------+-------------+
              |                           |
              v                           v
          Zone 1                      Zone 2
       VMSS Instance 0            VMSS Instance 1
              |                           |
              +-------------+-------------+
                            |
                      Application

Autoscaling adds instances when workload increases:

2 → 3 → 4

and removes excess capacity as workload decreases:

4 → 3 → 2
30. Troubleshooting Model

When the load-balanced application is unavailable, troubleshoot:

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
VMSS
  ↓
NSG
  ↓
Application

Do not change multiple layers simultaneously.

31. Cleanup

After completing the experiment:

Navigate to:

Resource groups → rg-az104-vm-scaling-01

Delete the entire resource group.

Then verify with Azure CLI:

az group exists --name rg-az104-vm-scaling-01

Expected:

false

This removes the VMSS, Load Balancer, Public IP, VNet, subnet, NSG, autoscale settings, and supporting resources.

Screenshot Evidence

Recommended evidence captured during the lab:

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
17-autoscale-profile.png
18-autoscale-rules.png
19-autoscale-rules.png
20-autoscale-policy-summary.png
21-vmss-cpu-baseline.png
22-vmss-cpu-load-rising.png
23-vmss-scale-out-event.png
24-vmss-three-instances-zones.png
25-vmss-max-capacity-zones.png
26-vmss-scale-in-event.png
27-vmss-final-two-zone-state.png
28-load-balancer-final-verification.png
29-cleanup-resource-group.png