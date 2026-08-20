
PS C:\Users\mahes> az network nsg rule show `
>>   --resource-group rg-az104-vm-networking-01 `
>>   --nsg-name nsg-web-01 `
>>   --name Allow-SSH `
>>   --output table
Name       ResourceGroup              Priority    SourcePortRanges    SourceAddressPrefixes    SourceASG    Access    Protocol    Direction    DestinationPortRanges    DestinationAddressPrefixes    DestinationASG
---------  -------------------------  ----------  ------------------  -----------------------  -----------  --------  ----------  -----------  -----------------------  ----------------------------  ----------------
Allow-SSH  rg-az104-vm-networking-01  100         *                   *                        None         Allow     Tcp         Inbound      22                       *                             None
PS C:\Users\mahes> Test-NetConnection 20.102.48.166 -Port 22


ComputerName     : 20.102.48.166
RemoteAddress    : 20.102.48.166
RemotePort       : 22
InterfaceAlias   : Wi-Fi
SourceAddress    : 172.16.27.165
TcpTestSucceeded : True


                 > az group delete `
>>   --name rg-az104-vm-networking-01 `
>>   --yes
PS C:\Users\mahes>
                   az group exists --name rg-az104-vm-networking-01
false
PS C:\Users\mahes>



The network used:

VNet:
vnet-az104-networking-01


VNet address space:
10.10.0.0/16


Subnet:
snet-web-01


Subnet address range:
10.10.1.0/24
2. Virtual Network

Created:

vnet-az104-networking-01

Address space:

10.10.0.0/16

The VNet provides the private networking boundary for the Azure resources in this lab.

The VNet can contain multiple subnets.

Example:

VNet
10.10.0.0/16
|
├── 10.10.1.0/24
├── 10.10.2.0/24
└── 10.10.3.0/24

Subnetting allows network segmentation.

3. Subnet

Created:

snet-web-01

Address range:

10.10.1.0/24

The subnet is a smaller address range inside the VNet.

The VM was attached to this subnet through its NIC.

4. CIDR

The lab used:

10.10.0.0/16

for the VNet and:

10.10.1.0/24

for the subnet.

The main concept is:

VNet
   ↓
larger address space


Subnet
   ↓
smaller address range inside the VNet
5. Network Security Group

Created:

nsg-web-01

The NSG was associated with the subnet.

Conceptually:

Subnet
   |
   ↓
NSG
   |
   ↓
Security Rules

An NSG controls allowed and denied network traffic.

6. SSH Security Rule

Created:

Allow-SSH

Configuration:

Priority:
100


Direction:
Inbound


Access:
Allow


Protocol:
TCP


Destination port:
22


Source:
*

This rule allowed SSH connectivity for the temporary lab.

For production environments, SSH access should normally be restricted to appropriate source addresses or controlled access mechanisms.

7. NSG Priority

NSG rules use numerical priorities.

Lower numbers are evaluated before higher numbers.

Example:

Priority 100
Allow TCP 22


Priority 65000+
Default rules

The custom priority-100 rule was evaluated before Azure's default deny inbound rule.

8. Public IP

Created:

pip-vm-networking-01

Public IP:

20.102.48.166

The public IP provided the external endpoint used for SSH.

The public IP was associated with the NIC.

9. Network Interface

Created:

nic-vm-networking-01

The NIC was explicitly created before the VM.

It connected:

Public IP
   |
NIC
   |
Private IP
   |
Subnet

Private IP:

10.10.1.4

The NIC was then attached to:

vm-az104-networking-01
10. Complete Network Path

The final network relationship was:

Internet
   |
20.102.48.166
   |
NIC
nic-vm-networking-01
   |
Subnet
snet-web-01
10.10.1.0/24
   |
Private IP
10.10.1.4
   |
VM
vm-az104-networking-01

The subnet also had:

NSG
nsg-web-01
11. SSH Connectivity

The VM was successfully accessed through SSH.

The connection path was:

Windows PC
   |
Internet
   |
Public IP
20.102.48.166
   |
NSG TCP 22
   |
NIC
   |
Private IP
10.10.1.4
   |
Ubuntu VM

SSH username:

azureuser
12. Intentional NSG Failure

The SSH rule was intentionally changed from:

Allow

to:

Deny

The rule still used:

TCP
22
Inbound
Priority 100

Connectivity was then tested using:

Test-NetConnection 20.102.48.166 -Port 22

Result:

TcpTestSucceeded : False

At the same time, the VM remained:

VM running

The public and private IP addresses also remained correct.

This isolated the failure to the network security layer.

13. Layer-by-Layer Troubleshooting

The troubleshooting model used in this lab was:

Client
   ↓
Public IP
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
Operating System
   ↓
SSH Service

The objective was to identify the first broken layer rather than randomly changing resources.

The NSG was identified as the failure point because:

VM:
Running


Public IP:
Correct


Private IP:
Correct


NSG:
Deny TCP 22
14. Restore Connectivity

The SSH rule was restored from:

Deny

to:

Allow

Connectivity was tested again.

Result:

TcpTestSucceeded : True

This demonstrated the complete troubleshooting cycle:

Known good
   ↓
Introduce failure
   ↓
Test
   ↓
Identify broken layer
   ↓
Restore configuration
   ↓
Verify
15. Effective NSG Rules

The effective NSG rules were inspected using Azure CLI.

The effective rules showed:

Allow-SSH
Priority 100
Inbound
TCP
Port 22
Allow

The output also showed Azure's default rules such as:

AllowVnetInBound
AllowAzureLoadBalancerInBound
DenyAllInBound
AllowVnetOutBound
AllowInternetOutBound
DenyAllOutBound

This demonstrated the distinction between:

Configured NSG rule

and:

Effective security rules

Effective rules show what actually applies to the NIC.

16. Routing

The effective route table was inspected.

Important system routes included:

10.10.0.0/16
Next Hop:
VnetLocal

and:

0.0.0.0/0
Next Hop:
Internet

The routing model is:

Route:
Where should the packet go?


NSG:
Is the traffic allowed?

These are separate networking functions.

17. User Defined Routes

A route table was created:

rt-web-01

A temporary test route was created:

Name:
TestRoute


Destination:
10.20.0.0/16


Next Hop:
None

The route table was associated with the subnet.

The effective route table then showed:

User
Active
10.20.0.0/16
None

This demonstrated how a user-defined route can alter effective routing behavior.

The test route and route table were removed after the exercise.

18. Next-Hop Routing

A production architecture could use a custom route to send traffic through a firewall or network virtual appliance.

Example:

VM
   |
Subnet
   |
Route Table
   |
0.0.0.0/0
   |
Virtual Appliance
   |
Firewall
   |
Internet

A UDR determines where traffic should be forwarded.

19. DNS

Inside the Ubuntu VM:

hostname:
vm-az104-networking-01

The VM also had an Azure internal FQDN.

The Azure DNS server reported by resolvectl was:

168.63.129.16

Linux used the local systemd-resolved stub:

127.0.0.53

The fully qualified Azure internal hostname successfully resolved to:

10.10.1.4

Example:

vm-az104-networking-01.<azure-internal-domain>
        ↓
10.10.1.4
20. DNS vs Routing vs NSG

These concepts solve different problems.

DNS

What IP address does this name resolve to?

Routing

Where should traffic destined for that IP go?

NSG

Is the traffic allowed?

Troubleshooting should therefore proceed logically:

Name
 ↓
DNS
 ↓
IP
 ↓
Route
 ↓
NSG
 ↓
NIC
 ↓
VM
 ↓
Service
21. Important Networking Lessons
VNet

Defines the private Azure network boundary.

Subnet

Segments the VNet into smaller address ranges.

NIC

Connects the VM to Azure networking.

Private IP

Provides internal network addressing.

Public IP

Provides external connectivity when required.

NSG

Controls allowed network traffic.

Routing

Determines where packets should go.

UDR

Provides custom routing behavior.

DNS

Resolves names to IP addresses.

Effective NSG

Shows the security rules actually applied.

Effective routes

Show the routes actually applied to the NIC.

22. Troubleshooting Principle

The most important lesson from this lab:

Troubleshoot networking layer by layer.

Don't immediately change multiple resources.

Instead:

Observe
   ↓
Identify layer
   ↓
Test
   ↓
Confirm failure
   ↓
Change one thing
   ↓
Retest
23. Cleanup

The temporary networking resource group was deleted after completing the lab:

rg-az104-vm-networking-01

Final verification:

az group exists --name rg-az104-vm-networking-01

Result:

false

This confirmed that the temporary Azure environment had been removed.