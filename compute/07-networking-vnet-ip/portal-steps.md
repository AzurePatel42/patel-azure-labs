# Azure Networking Lab — Azure Portal Steps

## Overview

This document provides the Azure Portal workflow for reproducing the networking lab.

The lab covers:

- Resource Groups
- Virtual Networks
- Subnets
- Public IP
- Network Interfaces
- Network Security Groups
- NSG Rules
- Route Tables
- User Defined Routes
- VNet Peering
- Azure DNS
- Private DNS
- Service Endpoints
- Storage
- Private Endpoints
- Load Balancer
- Health Probes
- Network Watcher

Resource Group:

```text
rg-az104-networking-01


Region:

East US
1. Create Resource Group

In Azure Portal:

Portal
  ↓
Resource groups
  ↓
Create

Configure:

Subscription:
Your Azure subscription


Resource group:
rg-az104-networking-01


Region:
East US

Select:

Review + create

Then:

Create
2. Create Primary VNet

Navigate:

Virtual networks
  ↓
Create

Basics:

Resource group:
rg-az104-networking-01


Virtual network name:
vnet-az104-networking-01


Region:
East US

IP Addresses:

IPv4 address space:
10.40.0.0/16

Create the initial VNet.

3. Create Web Subnet

Open:

vnet-az104-networking-01
  ↓
Subnets
  ↓
+ Subnet

Configure:

Subnet name:
snet-web


Subnet address range:
10.40.1.0/24

Save.

4. Create App Subnet

Navigate:

VNet
  ↓
Subnets
  ↓
+ Subnet

Configure:

Subnet name:
snet-app


Subnet address range:
10.40.2.0/24

Save.

5. Create Private Endpoint Subnet

Configure:

Subnet name:
snet-private-endpoints


Subnet address range:
10.40.3.0/24

Save.

Final subnet layout:

VNet
10.40.0.0/16


├── snet-web
│   └── 10.40.1.0/24
│
├── snet-app
│   └── 10.40.2.0/24
│
└── snet-private-endpoints
    └── 10.40.3.0/24
6. Create Public IP

Navigate:

Public IP addresses
  ↓
Create

Configure:

Resource group:
rg-az104-networking-01


Name:
pip-networking-01


Region:
East US


SKU:
Standard


Assignment:
Static

Select:

Review + create

Then:

Create
7. Create Network Interface

Navigate:

Network interfaces
  ↓
Create

Configure:

Resource group:
rg-az104-networking-01


Name:
nic-networking-web-01


Region:
East US


Virtual network:
vnet-az104-networking-01


Subnet:
snet-web


Private IP:
Dynamic


Public IP:
pip-networking-01

Create the NIC.

8. Create Web NSG

Navigate:

Network security groups
  ↓
Create

Configure:

Resource group:
rg-az104-networking-01


Name:
nsg-networking-web-01


Region:
East US

Create.

9. Create HTTP NSG Rule

Open:

nsg-networking-web-01
  ↓
Inbound security rules
  ↓
Add

Configure:

Source:
Internet


Source port ranges:
*


Destination:
Any


Service:
HTTP


Destination port:
80


Protocol:
TCP


Action:
Allow


Priority:
100


Name:
Allow-HTTP

Save.

10. Associate Web NSG With Web Subnet

Open:

vnet-az104-networking-01
  ↓
Subnets
  ↓
snet-web

Under:

Network security group

Select:

nsg-networking-web-01

Save.

11. Create App NSG

Navigate:

Network security groups
  ↓
Create

Configure:

Name:
nsg-networking-app-01


Resource group:
rg-az104-networking-01


Region:
East US

Create.

12. Create SSH Rule

Open:

nsg-networking-app-01
  ↓
Inbound security rules
  ↓
Add

Configure:

Source:
IP Addresses


Source IP:
10.40.1.0/24


Destination:
Any


Service:
SSH


Destination port:
22


Protocol:
TCP


Action:
Allow


Priority:
100


Name:
Allow-SSH-From-Web

Save.

13. Associate App NSG

Open:

VNet
  ↓
Subnets
  ↓
snet-app

Set:

Network security group:
nsg-networking-app-01

Save.

14. NSG Priority Demonstration

Open:

nsg-networking-web-01
  ↓
Inbound security rules
  ↓
Add

Create a temporary rule:

Name:
Deny-HTTP-Test


Priority:
200


Source:
10.40.2.0/24


Destination port:
80


Protocol:
TCP


Action:
Deny

Observe the rule ordering.

The existing rule:

Priority 100
Allow-HTTP

appears before:

Priority 200
Deny-HTTP-Test

Delete the temporary rule after the demonstration.

Final state:

100 Allow-HTTP
15. Create Route Table

Navigate:

Route tables
  ↓
Create

Configure:

Resource group:
rg-az104-networking-01


Region:
East US


Name:
rt-networking-app-01

Create.

16. Create User Defined Route

Open:

rt-networking-app-01
  ↓
Routes
  ↓
+ Add

Configure:

Route name:
Route-To-Test-Network


Destination type:
IP Addresses


Destination IP addresses/CIDR ranges:
10.50.0.0/16


Next hop type:
Virtual appliance


Next hop address:
10.40.1.10

Save.

Important:

The virtual appliance was not deployed in this lab.

17. Associate Route Table With App Subnet

Navigate:

vnet-az104-networking-01
  ↓
Subnets
  ↓
snet-app

Set:

Route table:
rt-networking-app-01

Save.

18. Create VNet-02

Navigate:

Virtual networks
  ↓
Create

Configure:

Resource group:
rg-az104-networking-01


Name:
vnet-az104-networking-02


Region:
East US


Address space:
10.60.0.0/16

Create.

19. Configure VNet Peering

Open:

vnet-az104-networking-01
  ↓
Peerings
  ↓
Add

Configure the remote VNet:

Peering link name:
peer-vnet01-to-vnet02


Remote virtual network:
vnet-az104-networking-02


Allow virtual network access:
Enabled

Create.

Then create the reverse peering from VNet-02:

vnet-az104-networking-02
  ↓
Peerings
  ↓
Add

Configure:

Peering link name:
peer-vnet02-to-vnet01


Remote virtual network:
vnet-az104-networking-01


Allow virtual network access:
Enabled

Verify both peerings show:

Connected
20. Create Azure DNS Zone

Navigate:

DNS zones
  ↓
Create

Configure:

Resource group:
rg-az104-networking-01


Zone name:
lab.az104.example

Create.

21. Create DNS A Record

Open:

lab.az104.example
  ↓
Record sets
  ↓
+ Add

Configure:

Name:
web


Type:
A


IP address:
20.75.220.55


TTL:
3600

Save.

Result:

web.lab.az104.example
22. Create Private DNS Zone

Navigate:

Private DNS zones
  ↓
Create

Configure:

Resource group:
rg-az104-networking-01


Name:
internal.lab

Create.

23. Link Private DNS Zone to VNet

Open:

internal.lab
  ↓
Virtual network links
  ↓
+ Add

Configure:

Link name:
link-networking-vnet-01


Virtual network:
vnet-az104-networking-01


Enable auto registration:
No

Create.

24. Create Private DNS Record

Open:

internal.lab
  ↓
Record sets
  ↓
+ Add

Configure:

Name:
db


Type:
A


IP:
10.40.2.10

Save.

Result:

db.internal.lab
25. Configure Storage Service Endpoint

Open:

vnet-az104-networking-01
  ↓
Subnets
  ↓
snet-app

Under:

Service endpoints

Select:

Microsoft.Storage

Save.

26. Create Storage Account

Navigate:

Storage accounts
  ↓
Create

Configure:

Resource group:
rg-az104-networking-01


Storage account name:
staz104netlab01


Region:
East US


Performance:
Standard


Redundancy:
Locally-redundant storage (LRS)

Create.

27. Create Private Endpoint

Navigate:

Private endpoints
  ↓
Create

Basics:

Resource group:
rg-az104-networking-01


Name:
pe-storage-01


Region:
East US

Resource:

Connection method:
Connect to an Azure resource


Resource:
staz104netlab01


Target sub-resource:
blob

Networking:

Virtual network:
vnet-az104-networking-01


Subnet:
snet-private-endpoints

Create.

28. Configure Private DNS For Private Endpoint

During Private Endpoint creation, configure:

Integrate with private DNS zone:
Yes

Select the appropriate Private DNS zone.

For the lab, the Private DNS configuration was inspected after creation.

Verify:

Private Endpoint
      |
Private IP
      |
Private DNS
      |
Azure Storage
29. Inspect Private Endpoint

Open:

Private endpoints
  ↓
pe-storage-01

Review:

Overview
Network interface
DNS configuration
Private IP address
Connection state

Confirm the connection is approved/connected.

30. Create Load Balancer Public IP

Navigate:

Public IP addresses
  ↓
Create

Configure:

Name:
pip-lb-networking-01


Region:
East US


SKU:
Standard


Assignment:
Static

Create.

31. Create Load Balancer

Navigate:

Load balancers
  ↓
Create

Basics:

Resource group:
rg-az104-networking-01


Name:
lb-networking-01


Region:
East US


SKU:
Standard

Frontend IP:

pip-lb-networking-01

Backend pool:

backend-pool

Create.

32. Create Health Probe

Open:

lb-networking-01
  ↓
Health probes
  ↓
Add

Configure:

Name:
probe-http


Protocol:
TCP


Port:
80


Interval:
5 seconds


Unhealthy threshold:
2

Save.

33. Create Load Balancing Rule

Open:

lb-networking-01
  ↓
Load balancing rules
  ↓
Add

Configure:

Name:
rule-http


Frontend IP:
frontend-public


Frontend port:
80


Backend pool:
backend-pool


Backend port:
80


Protocol:
TCP


Health probe:
probe-http

Save.

34. Inspect Backend Pool

Open:

lb-networking-01
  ↓
Backend pools
  ↓
backend-pool

The lab intentionally has no backend VM/NIC attached.

This is expected.

The purpose was to demonstrate the Load Balancer configuration without deploying unnecessary compute resources.

35. Network Watcher

Navigate:

Network Watcher

Confirm the East US watcher exists.

Expected:

NetworkWatcher_eastus

Resource group:

NetworkWatcherRG

Status:

Succeeded

Network Watcher can be used for:

Connection troubleshooting
NSG diagnostics
Network path analysis
Routing investigation
Other network diagnostics
36. Final Networking Review

Open:

Resource groups
  ↓
rg-az104-networking-01
  ↓
Resources

Review the final resource inventory.

Expected major components:

vnet-az104-networking-01
vnet-az104-networking-02


pip-networking-01
nic-networking-web-01


nsg-networking-web-01
nsg-networking-app-01


rt-networking-app-01


lab.az104.example
internal.lab


staz104netlab01
pe-storage-01


pip-lb-networking-01
lb-networking-01
37. Final Subnet Review

Open:

vnet-az104-networking-01
  ↓
Subnets

Expected:

snet-web
10.40.1.0/24
NSG: nsg-networking-web-01


snet-app
10.40.2.0/24
NSG: nsg-networking-app-01
Route table: rt-networking-app-01


snet-private-endpoints
10.40.3.0/24
38. Final NSG Review

Open:

nsg-networking-web-01
  ↓
Inbound security rules

Expected:

Priority 100
Allow-HTTP
TCP 80
Internet
Allow

Open:

nsg-networking-app-01
  ↓
Inbound security rules

Expected:

Priority 100
Allow-SSH-From-Web
TCP 22
10.40.1.0/24
Allow
39. Final Route Review

Open:

rt-networking-app-01
  ↓
Routes

Expected:

Route-To-Test-Network


Address prefix:
10.50.0.0/16


Next hop:
Virtual appliance


Next hop IP:
10.40.1.10

Remember:

The virtual appliance was not deployed.

40. Final DNS Review

Public DNS:

lab.az104.example

Record:

web
20.75.220.55

Private DNS:

internal.lab

VNet link:

vnet-az104-networking-01

Record:

db
10.40.2.10
41. Final Private Endpoint Review

Verify:

Private Endpoint:
pe-storage-01


Subnet:
snet-private-endpoints


Storage:
staz104netlab01


Private IP:
Assigned by Azure


DNS:
Private DNS integration configured
42. Final Load Balancer Review

Verify:

Load Balancer:
lb-networking-01


SKU:
Standard


Frontend:
frontend-public


Backend pool:
backend-pool


Health probe:
probe-http


Rule:
rule-http

Backend pool is intentionally empty.

43. Final Architecture Review

The completed lab represents:

                         Internet
                            |
                         Public IP
                            |
                        Web NIC
                            |
                      Web Subnet
                     10.40.1.0/24
                            |
                        Web NSG
                            |
                  VNet 10.40.0.0/16
                            |
                      App Subnet
                     10.40.2.0/24
                       /         \
                    NSG          UDR
                                  |
                           Virtual Appliance
                            10.40.1.10


                  Private Endpoint Subnet
                     10.40.3.0/24
                            |
                     Private Endpoint
                            |
                     Azure Storage


VNet-01
10.40.0.0/16
     |
     | Peering
     |
VNet-02
10.60.0.0/16
44. Portal-to-CLI Practice

For AZ-104 practice, use the Portal and CLI interchangeably.

Example:

Portal:
Create VNet


CLI:
az network vnet create
Portal:
Create NSG


CLI:
az network nsg create
Portal:
Add NSG rule


CLI:
az network nsg rule create
Portal:
Create route


CLI:
az network route-table route create
Portal:
Create Private Endpoint


CLI:
az network private-endpoint create
Portal:
Create Load Balancer


CLI:
az network lb create

The goal is to understand the Azure resource model rather than memorize only one interface.

45. AZ-104 Portal Exam Mindset

When working through Portal-based scenarios:

Identify the resource.
Identify the resource group.
Identify the region.
Identify dependencies.
Configure networking.
Configure security.
Validate the final state.

Always verify the configuration after creation.

Do not assume:

Created = Correct

Instead:

Created
   ↓
Configured
   ↓
Inspected
   ↓
Validated
46. Cleanup

When the lab is no longer needed:

Navigate:

Resource groups
  ↓
rg-az104-networking-01
  ↓
Delete resource group

Enter:

rg-az104-networking-01

Confirm deletion.

Then verify that the resource group no longer exists.

Do not delete:

NetworkWatcherRG

unless you specifically intend to remove the subscription's existing Network Watcher infrastructure.

Final Portal Checklist
[ ] Resource Group
[ ] VNet-01
[ ] Web subnet
[ ] App subnet
[ ] Private endpoint subnet
[ ] Public IP
[ ] NIC
[ ] Web NSG
[ ] App NSG
[ ] NSG rules
[ ] Route table
[ ] UDR
[ ] VNet-02
[ ] VNet peering
[ ] Azure DNS
[ ] DNS A record
[ ] Private DNS
[ ] VNet link
[ ] Storage service endpoint
[ ] Storage account
[ ] Private endpoint
[ ] Private DNS integration
[ ] Load Balancer
[ ] Health probe
[ ] Load balancing rule
[ ] Network Watcher
[ ] Final resource validation
Lab Completion

The networking lab is complete when:

Architecture understood
        +
Portal workflow understood
        +
CLI workflow understood
        +
Resources validated
        +
Screenshots captured
        +
Documentation completed

This lab is part of the AZ-104 hands-on preparation and will also provide networking knowledge for future Azure deployment of the Patel Platform Service Template and backend services.



