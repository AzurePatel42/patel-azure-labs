# Compute Module 02 — VM Networking & Network Security

## Overview

This lab demonstrates Azure Virtual Machine networking and network security by building the networking environment manually with Azure CLI before attaching the VM.

The lab covers:

- Virtual Networks
- Subnets
- CIDR addressing
- Network Security Groups
- NSG rules and priorities
- Public and private IP addresses
- Network Interfaces
- Effective NSG rules
- System routes
- User Defined Routes
- DNS and name resolution
- SSH connectivity
- Layer-by-layer troubleshooting
- Resource cleanup

---

## Architecture

```text
                         Internet
                            |
                      Public IP
                    20.102.48.166
                            |
                           NIC
                 nic-vm-networking-01
                            |
                     Private IP
                       10.10.1.4
                            |
                         Subnet
                      snet-web-01
                     10.10.1.0/24
                            |
                           NSG
                       nsg-web-01
                            |
                     Ubuntu VM
                vm-az104-networking-01




VNet:

vnet-az104-networking-01
10.10.0.0/16
Resource Configuration
Component	Configuration
Resource Group	rg-az104-vm-networking-01
Region	East US
VNet	vnet-az104-networking-01
VNet Address Space	10.10.0.0/16
Subnet	snet-web-01
Subnet Range	10.10.1.0/24
NSG	nsg-web-01
Public IP	pip-vm-networking-01
Public IP Address	20.102.48.166
NIC	nic-vm-networking-01
Private IP	10.10.1.4
VM	vm-az104-networking-01
OS	Ubuntu Server 24.04 LTS
VM Size	Standard D2ads_v7
SSH Port	TCP 22
Network Construction

Unlike the previous VM lab, the networking components were deliberately created first.

Resource Group
      ↓
VNet
      ↓
Subnet
      ↓
NSG
      ↓
NSG Rule
      ↓
NSG → Subnet Association
      ↓
Public IP
      ↓
NIC
      ↓
VM

This made the relationship between Azure networking resources visible instead of allowing the VM wizard to hide those dependencies.

Network Security

The subnet was associated with:

nsg-web-01

The SSH rule was:

Name:        Allow-SSH
Priority:    100
Direction:   Inbound
Protocol:    TCP
Destination: 22
Action:      Allow

Only TCP 22 was required for the temporary Linux administration lab.

NSG Troubleshooting Exercise

A deliberate failure was introduced by changing:

Allow → Deny

for TCP 22.

Connectivity was tested with:

Test-NetConnection 20.102.48.166 -Port 22

Result:

TcpTestSucceeded : False

At the same time, Azure confirmed:

VM running

and the VM retained:

Public IP: 20.102.48.166
Private IP: 10.10.1.4

This isolated the failure to the network security layer.

The NSG rule was then restored to Allow, and connectivity returned:

TcpTestSucceeded : True
Effective Security Rules

The effective NSG configuration was inspected on the NIC.

The effective rule set demonstrated that Azure combines custom rules with default security rules.

Important examples included:

Allow-SSH
Priority 100
TCP 22
Inbound
Allow

and Azure default rules such as:

AllowVnetInBound
AllowAzureLoadBalancerInBound
DenyAllInBound


AllowVnetOutBound
AllowInternetOutBound
DenyAllOutBound

This demonstrates why effective security rules are valuable when troubleshooting connectivity.

Routing

The effective route table was inspected on the NIC.

Important system routes included:

10.10.0.0/16 → VnetLocal
0.0.0.0/0    → Internet

This establishes the distinction between:

Routing
→ Where should the packet go?


NSG
→ Is the packet allowed?
User Defined Routes

A temporary route table was created:

rt-web-01

A test UDR was added:

Destination:
10.20.0.0/16


Next Hop:
None

After association with the subnet, the effective routes showed:

User
Active
10.20.0.0/16
None

This demonstrated how a custom route can change the effective routing behavior of a subnet.

The test route and route table were removed after the exercise.

Next-Hop Routing

A production architecture could use a UDR to send traffic through a firewall or network virtual appliance.

Conceptually:

VM
 ↓
Subnet
 ↓
UDR
 ↓
0.0.0.0/0
 ↓
Firewall / Virtual Appliance
 ↓
Internet

Routing determines the forwarding path; security controls determine whether the traffic should be permitted.

DNS

Inside the Ubuntu VM, the hostname was:

vm-az104-networking-01

The VM had an Azure internal FQDN.

The Azure DNS server reported by resolvectl was:

168.63.129.16

Linux used the local systemd-resolved stub:

127.0.0.53

The fully qualified Azure internal hostname successfully resolved to:

10.10.1.4

This demonstrated Azure internal DNS and the relationship between:

Name
 ↓
DNS
 ↓
Private IP
SSH Verification

The VM was successfully accessed using:

ssh -i "C:\Users\mahes\Downloads\vm-az104-linux-01_key.pem" azureuser@20.102.48.166

The successful connection demonstrated:

Public IP connectivity
NSG TCP 22 access
NIC configuration
Subnet association
Private IP assignment
Ubuntu SSH service availability
Layer-by-Layer Troubleshooting Model

This lab established the following troubleshooting approach:

Client
  ↓
DNS
  ↓
IP address
  ↓
Route
  ↓
NSG
  ↓
NIC
  ↓
Subnet
  ↓
VM
  ↓
OS firewall
  ↓
Service

The objective is to identify the first broken layer rather than changing multiple resources at once.

Key Lessons
VNet

Defines the private Azure networking boundary.

Subnet

Provides a smaller address range within the VNet.

NIC

Connects the VM to Azure networking.

Private IP

Provides internal network addressing.

Public IP

Provides internet-facing connectivity when required.

NSG

Controls allowed and denied network traffic.

Routing

Determines where network traffic is forwarded.

UDR

Provides custom routing behavior.

DNS

Resolves names to IP addresses.

Effective NSG Rules

Show the security rules actually applied to the NIC.

Effective Routes

Show the routes actually applied to the NIC.

Troubleshooting

Network failures should be isolated layer-by-layer.

Screenshot Evidence

The lab contains evidence covering:

Resource group
VNet
Subnet
NSG
NSG rule
Subnet association
Public IP
NIC
NIC IP configuration
SSH key troubleshooting
VM deployment
VM networking
SSH connectivity
NSG failure
NSG recovery
Effective NSG rules
Effective routes
UDR
DNS
Final connectivity
Cleanup
Cleanup

The entire temporary resource group was deleted after completing the lab:

rg-az104-vm-networking-01

Final verification:

az group exists --name rg-az104-vm-networking-01

Result:

false

This confirmed that the temporary networking environment was fully removed.