# AZ-104 Networking Notes

## 1. Core Azure Networking Model

Think about Azure networking in layers:

```text
VNet
 |
 +-- Subnets
 |     |
 |     +-- NSG
 |     +-- Route Table
 |     +-- Service Endpoint
 |     +-- Private Endpoint
 |
 +-- VNet Peering
 |
 +-- DNS
 |
 +-- Load Balancer
 |
 +-- Network Watcher



 2. VNet

A Virtual Network provides private network isolation in Azure.

Example:

VNet
10.40.0.0/16

A /16 provides a large address space from which smaller subnet ranges can be created.

Example:

10.40.1.0/24  → Web
10.40.2.0/24  → App
10.40.3.0/24  → Private Endpoints
Important

Subnet address spaces inside the same VNet must not overlap.

3. Subnets

A subnet divides the VNet address space.

Our lab:

VNet: 10.40.0.0/16


Web:
10.40.1.0/24


App:
10.40.2.0/24


Private Endpoints:
10.40.3.0/24

Think:

VNet
 |
 +-- Web subnet
 |
 +-- App subnet
 |
 +-- Private endpoint subnet

Subnets are where many Azure networking controls are attached.

4. Public IP vs Private IP
Private IP

Used for communication inside private network boundaries.

Example:

10.40.1.10
Public IP

Provides Internet-facing addressing when attached to an appropriate Azure resource.

Example:

20.x.x.x

Mental model:

Private IP
→ internal connectivity


Public IP
→ Internet-facing connectivity
5. Network Interface

A NIC connects a VM or another supported resource to a VNet.

Think:

VM
 |
NIC
 |
Subnet
 |
VNet

The NIC can contain IP configurations including private and public IP associations.

6. NSG

Network Security Group = traffic filtering.

An NSG contains security rules.

Typical rule attributes:

Priority
Name
Direction
Access
Protocol
Source
Source Port
Destination
Destination Port

Example:

Priority: 100
Direction: Inbound
Access: Allow
Protocol: TCP
Source: 10.40.1.0/24
Destination Port: 22
7. NSG Priority

This is extremely important for AZ-104.

Lower number = higher priority.

Example:

100 → Allow
200 → Deny

The priority 100 rule is evaluated before 200.

Remember:

100 beats 200

Do not think that the larger number has greater importance.

8. NSG Direction

Two directions:

Inbound
Outbound

Inbound:

Internet
   ↓
Azure resource

Outbound:

Azure resource
   ↓
Destination
9. NSG Association

An NSG can be associated with supported network interfaces or subnets.

In this lab we associated NSGs with subnets.

Example:

snet-web
   |
nsg-networking-web-01

and:

snet-app
   |
nsg-networking-app-01
10. NSG vs Route Table

This distinction must be automatic in your head.

NSG
Should traffic be allowed?
Route Table
Where should traffic go?

Example:

NSG:
Allow TCP 22 from 10.40.1.0/24


UDR:
10.50.0.0/16
→ Virtual Appliance
→ 10.40.1.10

One controls security.

The other controls routing.

11. NSG Priority Lab

We temporarily created:

Priority 100
Allow-HTTP
Internet → TCP 80
Allow

Then:

Priority 200
Deny-HTTP-Test
10.40.2.0/24 → TCP 80
Deny

Then we deleted the temporary rule.

Final state:

Allow-HTTP
Priority 100

The exercise demonstrated NSG rule evaluation order.

12. Route Tables

A route table controls routing decisions for associated subnets.

Example:

rt-networking-app-01

Route:

10.50.0.0/16
      ↓
Virtual Appliance
      ↓
10.40.1.10

This is a User Defined Route.

13. UDR

UDR = User Defined Route.

Use UDRs when you need custom routing behavior.

Example:

Destination:
10.50.0.0/16


Next Hop:
Virtual Appliance


Next Hop IP:
10.40.1.10

Mental model:

Traffic destined for 10.50.0.0/16
              ↓
Do not use the normal path
              ↓
Send toward 10.40.1.10

In this lab the virtual appliance itself was not deployed.

The purpose was to practice route configuration.

14. VNet Peering

VNet peering connects VNets privately.

Our design:

VNet-01
10.40.0.0/16
     |
     | Peering
     |
VNet-02
10.60.0.0/16

The address spaces do not overlap.

Important concept:

VNet Peering
≠
VPN

Peering provides private connectivity over Microsoft's network backbone.

15. DNS

DNS translates names to IP addresses.

Example:

web.lab.az104.example
        ↓
20.75.220.55

The Azure DNS zone used in the lab:

lab.az104.example

A record:

web
16. Public DNS vs Private DNS
Public DNS

Used for public DNS name resolution.

Example:

lab.az104.example
Private DNS

Used for private/internal name resolution.

Example:

internal.lab

Mental model:

Public DNS
→ public name resolution


Private DNS
→ private Azure network name resolution
17. Private DNS VNet Link

A Private DNS zone can be linked to a VNet.

Our lab:

internal.lab
     |
     | VNet Link
     ↓
vnet-az104-networking-01

This allows resources in the linked VNet to use the private DNS zone.

18. Service Endpoint

A service endpoint extends a subnet's VNet identity to supported Azure services.

Our lab enabled:

Microsoft.Storage

on:

snet-app

Think:

Subnet
   ↓
Service Endpoint
   ↓
Azure Storage

Important:

A service endpoint does NOT create a private IP address for the Azure service inside your subnet.

19. Private Endpoint

A Private Endpoint provides a private IP address in your VNet for an Azure service through Azure Private Link.

Our lab:

snet-private-endpoints
10.40.3.0/24
       |
       ↓
pe-storage-01
       |
       ↓
Azure Storage

Mental model:

Service Endpoint
→ subnet-based service access


Private Endpoint
→ private IP in your VNet
20. Service Endpoint vs Private Endpoint

Memorize this table:

Concept	Service Endpoint	Private Endpoint
Configured on	Subnet	Private Endpoint
Private IP in VNet	No	Yes
Private Link	No	Yes
DNS integration	Not normally required	Commonly required
Access model	Subnet/VNet identity	Private IP

If the exam asks:

"Which option gives the Azure service a private IP address in your VNet?"

Think:

PRIVATE ENDPOINT
21. Private Endpoint DNS

Private endpoints commonly use Private DNS.

The basic flow:

Application
    |
DNS lookup
    |
Private DNS
    |
Private IP
    |
Private Endpoint
    |
Azure Service

This is important because creating a private endpoint alone does not automatically mean every client will resolve the service name correctly in every DNS architecture.

22. Azure Load Balancer

Azure Load Balancer distributes network traffic across backend resources.

Core components:

Frontend IP
Backend Pool
Health Probe
Load Balancing Rule

Mental model:

Client
  ↓
Frontend IP
  ↓
Load Balancer
  ↓
Health Probe
  ↓
Healthy Backend
23. Health Probe

The health probe determines whether a backend is healthy enough to receive traffic.

Our probe:

Name: probe-http
Protocol: TCP
Port: 80
Interval: 5 seconds
Threshold: 2

If a backend fails the health probe, it becomes ineligible for load-balanced traffic.

24. Backend Pool

The backend pool contains the resources that can receive traffic.

Our lab created:

backend-pool

The pool was intentionally left without backend VMs/NICs.

This avoided creating unnecessary compute resources while still demonstrating the Load Balancer configuration model.

25. Load Balancing Rule

Our rule:

rule-http

Configuration:

Frontend Port: 80
Backend Port: 80
Protocol: TCP
Probe: probe-http

Flow:

Client
  ↓
TCP 80
  ↓
Frontend
  ↓
Backend Pool
  ↓
TCP 80
26. Network Watcher

Network Watcher provides Azure network diagnostic capabilities.

Our subscription already had:

NetworkWatcher_eastus

in:

NetworkWatcherRG

State:

Succeeded

Network Watcher is useful for diagnosing problems involving:

Connectivity
Routing
NSGs
Network paths
Packet behavior
27. Networking Troubleshooting Order

When something cannot connect, don't randomly change settings.

Use this order:

1. DNS
   ↓
2. NSG
   ↓
3. Route
   ↓
4. Endpoint
   ↓
5. Service/application

Ask:

DNS
Does the name resolve?
NSG
Is the traffic allowed?
Route
Where is the traffic being sent?
Endpoint
Does the destination actually exist?
Application
Is the application listening?
28. Important AZ-104 Exam Distinctions
NSG
Security filtering
Route Table
Routing
UDR
Custom route
VNet Peering
Private VNet-to-VNet connectivity
Public DNS
Public name resolution
Private DNS
Private name resolution
Service Endpoint
Subnet-based Azure service access
Private Endpoint
Private IP + Private Link
Load Balancer
Distribute traffic
Health Probe
Determine backend health
Network Watcher
Network diagnostics
29. Architecture Thinking

Do not memorize Azure networking as isolated commands.

Think in relationships:

VNet
 |
 +-- Subnet
 |     |
 |     +-- NSG
 |     +-- Route Table
 |
 +-- Peering
 |
 +-- DNS
 |
 +-- Private DNS
 |
 +-- Private Endpoint
 |
 +-- Load Balancer

Every resource has a job.

30. Practical Troubleshooting Scenario
Scenario

An application in:

10.40.2.0/24

cannot connect to a service in:

10.50.0.0/16

Check:

1. Is the destination reachable?
2. Does DNS resolve correctly?
3. Does the NSG allow the traffic?
4. Does the route table contain the correct route?
5. Is the next-hop appliance reachable?
6. Is the destination service listening?

Do not immediately modify the NSG.

A routing problem cannot be fixed by randomly changing a security rule.

31. Portfolio Lesson

The goal of this lab was not simply:

"Create a VNet."

The goal was to understand:

Network
   ↓
Segmentation
   ↓
Security
   ↓
Routing
   ↓
Name Resolution
   ↓
Private Connectivity
   ↓
Traffic Distribution
   ↓
Troubleshooting

This is the mindset needed for Azure administration and backend platform deployment.

32. PPST Connection

The networking concepts learned here will be directly useful when deploying the Patel Platform Service Template and the remaining backend projects to Azure.

Potential future architecture:

Internet
   |
Azure Load Balancer / Application Gateway
   |
Azure Container Apps
   |
Private networking
   |
Private endpoints
   |
+----------------------+
| PostgreSQL            |
| Redis                 |
| Storage               |
| Other platform deps  |
+----------------------+

The exact production architecture will depend on the deployment target and scaling requirements.

33. AZ-104 Memory Rules

Memorize these:

Lower NSG priority number = evaluated first.


NSG controls traffic.
Route table controls routing.


UDR = custom route.


VNet peering = private VNet connectivity.


Public DNS = public name resolution.


Private DNS = private name resolution.


Service Endpoint = subnet-based Azure service access.


Private Endpoint = private IP + Private Link.


Health Probe = determines backend eligibility.


Load Balancer = distributes traffic.


Network Watcher = network diagnostics.
34. Final Exam Mindset

For AZ-104 scenario questions:

Do not ask:

"What command do I remember?"

Ask:

"What Azure networking problem am I solving?"

Then identify the correct service.

Security?
→ NSG


Routing?
→ Route Table / UDR


VNet-to-VNet?
→ VNet Peering


Name resolution?
→ DNS / Private DNS


Private service access?
→ Private Endpoint


Subnet-based service access?
→ Service Endpoint


Traffic distribution?
→ Load Balancer


Network diagnostics?
→ Network Watcher

That decision-making model is more valuable than memorizing individual CLI commands.