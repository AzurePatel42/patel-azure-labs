
### 4. `notes.md`

```powershell
@'
# Azure Networking — Notes

## Purpose

This module is an AZ-104 networking consolidation lab.

It intentionally avoids duplicating the deeper networking implementation already completed in the Compute module.

The goal is to independently reproduce and explain the core networking building blocks through Azure CLI.

---

## Core Networking Model

Azure networking can be understood as layers:

```text
VNet
 |
 +-- Subnets
      |
      +-- NSG
      |
      +-- Route Table



Additional connectivity can then be built between VNets using:

VNet Peering

Operational troubleshooting is supported through:

Network Watcher
VNet

A Virtual Network provides an isolated network boundary in Azure.

This lab used:

vnet-az104-network-01
10.10.0.0/16

and:

vnet-az104-network-02
10.20.0.0/16
Subnets

Subnets divide the VNet address space into logical network segments.

VNet 1:

snet-app
10.10.1.0/24


snet-management
10.10.2.0/24

VNet 2:

snet-app
10.20.1.0/24

Subnet segmentation provides logical separation inside a VNet.

Network Security Groups

An NSG controls network traffic using security rules.

This lab created:

nsg-az104-app

with:

Allow-SSH
Priority: 100
Inbound
TCP
Port 22
Allow

The NSG was associated directly with:

snet-app
NSG Association

Creating an NSG does not automatically apply it to a subnet.

The lab explicitly associated:

nsg-az104-app

with:

vnet-az104-network-01 / snet-app

This demonstrates the difference between creating a security policy and attaching that policy to a network resource.

Route Tables and UDR

A route table defines custom routing behavior.

This lab created:

rt-az104-app

with:

10.20.0.0/16
    |
    v
Virtual Appliance
10.10.2.4

This demonstrates a User Defined Route.

The route table was associated with:

snet-app
VNet Peering

VNet peering provides private connectivity between Azure VNets.

The lab created two VNets:

10.10.0.0/16

and:

10.20.0.0/16

Bidirectional peering was configured.

Both peering connections were verified as:

Connected
Network Watcher

Azure Network Watcher provides networking monitoring and troubleshooting capabilities.

The existing East US instance was verified:

NetworkWatcher_eastus
NetworkWatcherRG
eastus
Succeeded

The lab did not recreate the existing Network Watcher.

DNS

The VNet was inspected for custom DNS configuration.

No custom DNS servers were configured.

Therefore the VNet uses Azure-provided DNS behavior.

Private DNS

No Private DNS Zone was created in this module.

This was intentional.

Private DNS and private endpoint networking were already covered in the Compute module, so creating duplicate infrastructure would not add meaningful learning value.

Relationship to Compute

The Compute module already contained substantial networking work, including:

VNet
IP addressing
VM networking
Network security
Private networking
Private endpoints
DNS-related concepts
Network troubleshooting

Therefore this module is a consolidation rather than a replacement.

The goal is to demonstrate independent networking understanding while maintaining a clean learning roadmap.

Important AZ-104 Concepts

Remember:

VNet = network boundary


Subnet = network segmentation


NSG = traffic filtering


Route table = custom routing


UDR = user-defined route


VNet peering = VNet-to-VNet connectivity


Network Watcher = network troubleshooting


DNS = name resolution
Lab Design Principle

Do not build infrastructure merely to create screenshots.

Every resource should demonstrate a concept.

This module intentionally stopped after the networking foundation was validated.

The result is a smaller, cleaner and more repeatable AZ-104 networking lab.

Evidence

Nine screenshots were captured:

01-networking-resource-group-created.png
02-networking-vnet-subnet-created.png
03-networking-vnet-subnet-segmentation.png
04-networking-nsg-security-rule.png
05-networking-subnet-nsg-association.png
06-networking-udr-route-table.png
07-networking-subnet-nsg-udr-association.png
08-networking-vnet-peering-connected.png
09-networking-network-watcher-verification.png
Completion Criteria

The module is complete when:

Resource group created
VNet created
Subnets created
NSG created
NSG rule created
NSG associated
Route table created
UDR created
Route table associated
VNet peering established
Network Watcher verified
DNS configuration inspected
Documentation completed
Screenshots verified
Git commit created
GitHub push completed
'@ | Set-Content .\notes.md