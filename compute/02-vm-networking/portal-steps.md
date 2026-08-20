# Compute Module 02 — VM Networking & Network Security

## Objective

Understand and verify Azure VM networking through the Azure Portal.

This lab focused on:

- Virtual Networks
- Subnets
- Network Security Groups
- Public IPs
- Network Interfaces
- Private IPs
- NSG rules
- Effective security rules
- Routing
- DNS
- VM connectivity
- Troubleshooting

---

# 1. Resource Group

Open the Azure Portal.

Navigate to:

**Resource groups**

Create:

```text
rg-az104-vm-networking-01


Region:

East US
2. Virtual Network

Navigate to:

Virtual networks

Create:

vnet-az104-networking-01

Address space:

10.10.0.0/16
3. Subnet

Create:

snet-web-01

Address range:

10.10.1.0/24

Concept:

VNet
10.10.0.0/16
   |
   └── Subnet
       10.10.1.0/24
4. Network Security Group

Navigate to:

Network Security Groups

Create:

nsg-web-01

Region:

East US
5. NSG SSH Rule

Open:

nsg-web-01 → Inbound security rules

Create:

Name:
Allow-SSH


Priority:
100


Source:
Any


Source port:
*


Destination:
Any


Destination port:
22


Protocol:
TCP


Action:
Allow

The rule allows SSH access for this temporary lab.

6. Associate NSG with Subnet

Open:

Virtual Network
→ vnet-az104-networking-01
→ Subnets
→ snet-web-01

Associate:

Network Security Group:
nsg-web-01

This creates subnet-level network security.

7. Public IP

Create:

pip-vm-networking-01

Configuration:

SKU:
Standard


Allocation:
Static

The public IP was used as the SSH endpoint.

8. Network Interface

Create or inspect:

nic-vm-networking-01

Verify:

Subnet:
snet-web-01


Private IP:
10.10.1.4


Public IP:
pip-vm-networking-01

Conceptually:

Public IP
   |
NIC
   |
Private IP
   |
Subnet
9. Virtual Machine

The VM was created using the existing NIC.

vm-az104-networking-01

Image:

Ubuntu Server 24.04 LTS

Size:

Standard D2ads_v7

Authentication:

SSH public key

Username:

azureuser
10. Verify VM Networking

Open:

Virtual machine → Networking

Review:

Public IP
Private IP
Network interface
Virtual network
Subnet
NSG

Expected:

Public IP:
20.102.48.166


Private IP:
10.10.1.4


VNet:
vnet-az104-networking-01


Subnet:
snet-web-01
11. Test SSH

Use:

VM → Connect → Native SSH

Or use Windows PowerShell with the generated SSH key.

Expected connection:

azureuser@vm-az104-networking-01:~$
12. Troubleshoot SSH

The lab deliberately changed the NSG rule:

Allow SSH

to:

Deny SSH

This caused new SSH connectivity to fail.

Troubleshooting process:

VM status
   ↓
Public IP
   ↓
NIC
   ↓
Subnet
   ↓
NSG
   ↓
SSH port
   ↓
VM / SSH service

The NSG was identified as the failing layer.

13. Restore SSH

Open:

nsg-web-01 → Inbound security rules

Change:

Allow-SSH

back to:

Action:
Allow

Verify that SSH connectivity works again.

14. Effective NSG Rules

Open the VM's networking/security configuration and inspect the effective rules where available.

The important concept is:

Configured NSG rules
        +
Azure default rules
        ↓
Effective security rules

Priority 100 SSH access was evaluated before the default deny rule.

15. Routing

Review the VM's effective routes.

Important concepts:

10.10.0.0/16
→ VnetLocal


0.0.0.0/0
→ Internet

Routing determines where traffic is forwarded.

16. User Defined Route

A temporary route table was created:

rt-web-01

A temporary test route was added:

Destination:
10.20.0.0/16


Next hop:
None

The route table was associated with:

snet-web-01

Effective routes were then inspected to verify that the custom route appeared.

The test route and route table were removed after verification.

17. DNS

Inside the Ubuntu VM, verify:

Hostname
FQDN
DNS resolver
Private IP

Azure internal DNS resolution successfully mapped the VM's internal FQDN to:

10.10.1.4

Important distinction:

DNS:
Name → IP


Routing:
Where should traffic go?


NSG:
Is the traffic allowed?
18. Networking Troubleshooting Model

Use this sequence when a VM cannot be reached:

1. Correct destination?
2. DNS resolving?
3. Public/private IP correct?
4. Route available?
5. NSG allows traffic?
6. NIC attached correctly?
7. VM running?
8. OS firewall?
9. Service listening?

Troubleshoot one layer at a time.

19. Cleanup

After completing the lab:

Resource groups → rg-az104-vm-networking-01 → Delete

Confirm the resource group name.

The lab was completely removed.

Final CLI verification:

az group exists --name rg-az104-vm-networking-01

Expected:

false
Screenshot Evidence

The lab contains evidence covering:

Network resources
VNet
Subnet
NSG
NSG rule
NSG association
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
Final state
Cleanup