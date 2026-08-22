# Azure Networking — VNet, NSG, UDR, DNS, Private Endpoint & Load Balancer

## Overview

This lab demonstrates core Azure networking concepts required for the AZ-104 Azure Administrator certification.

The lab was built using Azure CLI and validated through Azure resource inspection and configuration evidence.

The focus was not simply creating resources, but understanding how Azure networking components work together:

- Virtual Networks
- Subnets
- Public IP addresses
- Network Interfaces
- Network Security Groups
- NSG rule priority
- User Defined Routes
- VNet Peering
- Azure DNS
- Private DNS
- Service Endpoints
- Private Endpoints
- Azure Load Balancer
- Health Probes
- Network Watcher
- Networking troubleshooting concepts

---

## Lab Environment

| Item | Value |
|---|---|
| Resource Group | `rg-az104-networking-01` |
| Location | `eastus` |
| Primary VNet | `vnet-az104-networking-01` |
| Primary Address Space | `10.40.0.0/16` |
| Secondary VNet | `vnet-az104-networking-02` |
| Secondary Address Space | `10.60.0.0/16` |

---

## Network Architecture

```text
                         Internet
                            |
                     Public IP / NIC
                            |
                       Web Subnet
                      10.40.1.0/24
                            |
                         Web NSG
                            |
                  -------------------
                  |       VNet       |
                  |  10.40.0.0/16   |
                  -------------------
                            |
                      App Subnet
                     10.40.2.0/24
                       /         \
                  App NSG       UDR
                                 |
                         10.50.0.0/16
                              |
                       Virtual Appliance
                         10.40.1.10

              Private Endpoint Subnet
                    10.40.3.0/24
                          |
                  Private Endpoint
                          |
                    Azure Storage



A second VNet was also created:

VNet-01                         VNet-02
10.40.0.0/16                    10.60.0.0/16
     |                               |
     +--------- VNet Peering --------+
Subnet Design
Web Subnet
Name:     snet-web
Prefix:   10.40.1.0/24
NSG:      nsg-networking-web-01

The web subnet allows HTTP traffic through the explicit Allow-HTTP NSG rule.

App Subnet
Name:       snet-app
Prefix:     10.40.2.0/24
NSG:        nsg-networking-app-01
Route Table: rt-networking-app-01

The application subnet allows SSH from the web subnet:

Source:      10.40.1.0/24
Destination: TCP 22
Access:      Allow
Priority:    100
Private Endpoint Subnet
Name:   snet-private-endpoints
Prefix: 10.40.3.0/24

This subnet was used for the Azure Storage private endpoint.

Network Security Groups

Two NSGs were created:

nsg-networking-web-01
nsg-networking-app-01
Web NSG

The web NSG contains:

Priority 100
Allow-HTTP
Inbound
TCP 80
Source: Internet
Access: Allow
App NSG

The app NSG contains:

Priority 100
Allow-SSH-From-Web
Inbound
TCP 22
Source: 10.40.1.0/24
Access: Allow
NSG Priority Demonstration

A temporary deny rule was created to demonstrate rule evaluation:

Priority 100
Internet → TCP 80 → Allow


Priority 200
10.40.2.0/24 → TCP 80 → Deny

The lower numerical priority was evaluated first.

The temporary rule was then deleted.

Final web NSG state contains only the intended Allow-HTTP rule.

Key concept

Lower NSG priority number = higher evaluation priority.

NSGs are stateful. Return traffic for an allowed connection does not require a separate reverse rule.

User Defined Route

A route table was created:

rt-networking-app-01

A user-defined route was configured:

Destination: 10.50.0.0/16
Next Hop:    Virtual Appliance
Next Hop IP: 10.40.1.10

The route table was associated with snet-app.

The virtual appliance was intentionally not deployed. The objective was to demonstrate UDR configuration and routing concepts without creating unnecessary infrastructure.

VNet Peering

A second VNet was created:

vnet-az104-networking-02
10.60.0.0/16

Bidirectional peering was configured between the two VNets.

VNet-01
10.40.0.0/16
     |
     | Connected
     |
VNet-02
10.60.0.0/16

The address spaces do not overlap.

Key concept

VNet peering provides private connectivity between VNets over Microsoft's network backbone.

VNet peering is different from a VPN connection.

Azure DNS

A DNS zone was created:

lab.az104.example

An A record was added:

web.lab.az104.example
        ↓
20.75.220.55

The .example domain is reserved for documentation/testing and was used only for this lab.

Private DNS

A Private DNS zone was created:

internal.lab

The zone was linked to:

vnet-az104-networking-01

A private A record was created:

db.internal.lab
        ↓
10.40.2.10

This demonstrates private name resolution within an Azure networking environment.

Storage Service Endpoint

The application subnet was configured with:

Microsoft.Storage

as a service endpoint.

This demonstrates subnet-based access to an Azure service.

Private Endpoint

An Azure Storage account was created:

staz104netlab01

A dedicated private endpoint subnet was created:

10.40.3.0/24

A Private Endpoint was then created:

pe-storage-01

The private endpoint was integrated with the Private DNS configuration.

Service Endpoint vs Private Endpoint
Feature	Service Endpoint	Private Endpoint
Configuration	Subnet	Private endpoint resource
Private IP in VNet	No	Yes
Azure Private Link	No	Yes
Common DNS integration	Not required	Commonly used
Service access model	VNet/subnet identity	Private IP
Azure Load Balancer

A Standard Azure Load Balancer was created:

lb-networking-01

Components configured:

Public IP
Frontend configuration
Backend pool
TCP health probe
TCP load-balancing rule

The health probe checks TCP port 80.

The backend pool was intentionally left without backend VMs/NICs.

The purpose was to demonstrate the Load Balancer architecture without deploying additional compute resources.

Load Balancer flow
Client
  |
Public IP :80
  |
Azure Load Balancer
  |
Health Probe
  |
Healthy Backend

An unhealthy backend is removed from the eligible backend set.

Network Watcher

The existing Azure Network Watcher in East US was verified:

NetworkWatcher_eastus
Resource Group: NetworkWatcherRG
State: Succeeded

Network Watcher is used for Azure network diagnostics and troubleshooting.

Troubleshooting Mental Model

When troubleshooting Azure networking, evaluate the problem systematically:

DNS
 |
Can the name resolve?
 |
NSG
 |
Is the traffic allowed?
 |
Route
 |
Where is the traffic being sent?
 |
Endpoint
 |
Does the destination actually exist and respond?
 |
Application
 |
Is the application listening on the expected port?

This lab intentionally separates:

NSG  → traffic filtering


UDR  → traffic routing


DNS  → name resolution


Private Endpoint → private connectivity


Load Balancer → traffic distribution
Evidence

The lab contains 41 screenshots documenting the build and validation process.

01-resource-group.png
02-vnet.png
03-web-subnet.png
04-app-subnet.png
05-subnet-layout.png
06-public-ip.png
07-nic-public-private-ip.png
08-subnet-network-properties.png
09-nsg-created.png
10-http-nsg-rule.png
11-web-subnet-nsg.png
12-app-nsg-created.png
13-app-nsg-rule.png
14-both-subnets-nsg.png
15-nsg-priority-rules.png
16-route-table.png
17-udr-created.png
18-app-subnet-route-table.png
19-route-table-final.png
20-vnet-02.png
21-vnet-peering.png
22-dns-zone.png
23-dns-a-record.png
24-private-dns-zone.png
25-private-dns-vnet-link.png
26-private-dns-record.png
27-storage-service-endpoint.png
28-storage-account.png
29-private-endpoint-subnet.png
30-private-endpoint.png
31-private-endpoint-dns.png
32-private-endpoint-ip.png
33-private-dns-final.png
34-load-balancer-public-ip.png
35-load-balancer-created.png
36-load-balancer-health-probe.png
37-load-balancer-rule.png
38-load-balancer-backend-pool.png
39-load-balancer-final.png
40-app-subnet-final-networking.png
41-final-networking-resources.png
AZ-104 Learning Outcomes

This lab reinforced the following Azure Administrator concepts:

Design VNet address spaces
Create and configure subnets
Configure public IPs and NICs
Configure NSGs
Understand NSG priority
Associate NSGs with subnets
Create route tables
Configure UDRs
Understand next-hop routing
Configure VNet peering
Understand DNS zones and records
Configure Private DNS
Link Private DNS to VNets
Configure service endpoints
Configure private endpoints
Understand Private Link
Configure Azure Load Balancer
Configure health probes
Understand backend pools
Use Network Watcher concepts for troubleshooting
Cleanup

Azure resources created for this lab should be removed when no longer needed to avoid unnecessary charges.

Before cleanup, verify:

az resource list `
  --resource-group rg-az104-networking-01 `
  --output table

Then remove the lab resource group:

az group delete `
  --name rg-az104-networking-01 `
  --yes

Verify:

az group exists `
  --name rg-az104-networking-01

Expected:

false
Portfolio Value

This lab demonstrates hands-on Azure networking administration rather than only theoretical knowledge.

It shows practical experience with:

VNet
Subnetting
NSG
Routing
Peering
DNS
Private Connectivity
Load Balancing
Network Troubleshooting

The lab was intentionally built, inspected, validated, documented, and designed for repeatability through Azure CLI.