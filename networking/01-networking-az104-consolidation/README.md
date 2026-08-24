@'
# Azure Networking — AZ-104 Consolidation Lab

## Overview

This lab consolidates the core Azure networking concepts required for AZ-104.

The deeper networking implementations were already completed during the Compute module. This module provides a focused networking consolidation covering:

- Virtual Networks (VNet)
- Subnets
- Subnet segmentation
- Network Security Groups (NSG)
- NSG security rules
- NSG-to-subnet association
- Route tables
- User Defined Routes (UDR)
- Route table-to-subnet association
- VNet peering
- Network Watcher
- Azure-provided DNS behavior

The lab was intentionally kept small and focused to avoid duplicating the more extensive networking work already completed in the Compute module.

---

## Architecture

```text
                    Azure Subscription
                           |
                           v
              rg-az104-networking-01
                           |
              +------------+------------+
              |                         |
              v                         v
     vnet-az104-network-01     vnet-az104-network-02
          10.10.0.0/16              10.20.0.0/16
              |                         |
        +-----+------+                  |
        |            |                  |
        v            v                  v
    snet-app   snet-management      snet-app
   10.10.1.0/24  10.10.2.0/24     10.20.1.0/24
        |
        +------------------+
        |                  |
        v                  v
   NSG: nsg-az104-app   UDR: rt-az104-app
        |                  |
    Allow-SSH        route to 10.20.0.0/16
        |             via virtual appliance
        +------------------+
                 |
                 v
           VNet Peering
                 |
                 v
       vnet-az104-network-02


Resources Created
Resource	Name
Resource Group	rg-az104-networking-01
VNet 1	vnet-az104-network-01
VNet 2	vnet-az104-network-02
App Subnet	snet-app
Management Subnet	snet-management
NSG	nsg-az104-app
NSG Rule	Allow-SSH
Route Table	rt-az104-app
UDR	route-to-private-network
Network Watcher	NetworkWatcher_eastus
Addressing
VNet 1
10.10.0.0/16

Subnets:

snet-app
10.10.1.0/24


snet-management
10.10.2.0/24
VNet 2
10.20.0.0/16

Subnet:

snet-app
10.20.1.0/24
Security

The application subnet is associated with:

nsg-az104-app

The NSG contains:

Allow-SSH
Priority: 100
Direction: Inbound
Protocol: TCP
Destination Port: 22
Access: Allow

This rule exists strictly for demonstrating NSG behavior in the lab.

Routing

The application subnet is associated with:

rt-az104-app

The route table contains:

Address Prefix: 10.20.0.0/16
Next Hop Type: VirtualAppliance
Next Hop IP: 10.10.2.4

This demonstrates User Defined Routing (UDR).

VNet Peering

Two VNets were created:

vnet-az104-network-01
        |
        | Peering
        |
vnet-az104-network-02

Both directions were configured and verified as connected.

Network Watcher

The existing Azure Network Watcher instance was verified:

Name: NetworkWatcher_eastus
Resource Group: NetworkWatcherRG
Location: eastus
State: Succeeded

Network Watcher was not recreated because Azure had already provisioned the regional instance.

DNS

The networking VNet was inspected for custom DNS configuration.

No custom DNS servers were configured.

Therefore the VNet uses Azure-provided DNS behavior.

No Private DNS Zone was created in this consolidation lab because Private DNS concepts were already covered in the Compute module.

Relationship to Compute Module

This module intentionally does not duplicate the deeper networking labs already completed under:

compute/07-networking-vnet-ip

The Compute module contains more extensive hands-on networking coverage.

This consolidation module focuses on demonstrating that the AZ-104 networking concepts can be independently understood and reproduced using Azure CLI.

Validation

The lab was validated using Azure CLI commands for:

Resource group creation
VNet creation
Subnet creation
Subnet segmentation
NSG creation
NSG rule creation
NSG association
Route table creation
UDR creation
Route table association
VNet peering
Network Watcher verification
DNS configuration inspection
Screenshots
Screenshot	Evidence
01-networking-resource-group-created.png	Networking resource group
02-networking-vnet-subnet-created.png	VNet and initial subnet
03-networking-vnet-subnet-segmentation.png	Subnet segmentation
04-networking-nsg-security-rule.png	NSG security rule
05-networking-subnet-nsg-association.png	NSG associated with subnet
06-networking-udr-route-table.png	Route table and UDR
07-networking-subnet-nsg-udr-association.png	NSG and UDR associations
08-networking-vnet-peering-connected.png	VNet peering
09-networking-network-watcher-verification.png	Network Watcher verification
Cleanup

The networking resource group can be removed after the lab:

az group delete `
  --name rg-az104-networking-01 `
  --yes `
  --no-wait

The existing NetworkWatcherRG resource group should not be deleted because Network Watcher is an existing regional Azure resource.

Outcome

The lab was intentionally built, inspected, validated, documented, and designed for repeatability through Azure CLI.

The result is a focused AZ-104 networking consolidation module that complements the deeper networking work already completed in the Compute module.
'@ | Set-Content .\README.md