
### 3. `portal-steps.md`

```powershell
@'
# Azure Networking — Portal Steps

## 1. Resource Group

Open Azure Portal and navigate to:

**Resource groups**

Create:

```text
Name: rg-az104-networking-01
Region: East US


Verify the resource group shows a successful provisioning state.

2. Virtual Network

Navigate to:

Virtual networks → Create

Create:

Name: vnet-az104-network-01
Region: East US
Address space: 10.10.0.0/16

Create the application subnet:

Name: snet-app
Address range: 10.10.1.0/24
3. Subnet Segmentation

Open:

vnet-az104-network-01 → Subnets

Create:

snet-management
10.10.2.0/24

Verify that the VNet contains two logical network segments.

4. Network Security Group

Navigate to:

Network security groups → Create

Create:

Name: nsg-az104-app
Region: East US

Add inbound security rule:

Name: Allow-SSH
Priority: 100
Direction: Inbound
Access: Allow
Protocol: TCP
Destination port: 22
Source: Internet

This rule is for lab demonstration only.

5. NSG Association

Open:

nsg-az104-app → Subnets → Associate

Select:

Virtual network:
vnet-az104-network-01


Subnet:
snet-app

Verify that the NSG is associated with the application subnet.

6. Route Table

Navigate to:

Route tables → Create

Create:

Name: rt-az104-app
Region: East US

Add route:

Name: route-to-private-network
Address prefix: 10.20.0.0/16
Next hop type: Virtual appliance
Next hop IP: 10.10.2.4
7. Route Table Association

Open:

rt-az104-app → Subnets → Associate

Select:

Virtual network:
vnet-az104-network-01


Subnet:
snet-app

Verify the subnet has both:

Network Security Group
Route Table
8. Second VNet

Create:

Name: vnet-az104-network-02
Region: East US
Address space: 10.20.0.0/16

Create:

snet-app
10.20.1.0/24
9. VNet Peering

Open:

vnet-az104-network-01 → Peerings → Add

Configure the first direction:

Peering name:
peer-vnet01-to-vnet02


Remote VNet:
vnet-az104-network-02


Allow virtual network access:
Enabled

Create the reverse peering from:

vnet-az104-network-02

to:

vnet-az104-network-01

Verify both peerings show:

Connected
10. Network Watcher

Navigate to:

Network Watcher

Verify the existing East US instance:

NetworkWatcher_eastus

Resource group:

NetworkWatcherRG

State:

Succeeded

No new Network Watcher was created because the regional instance already existed.

11. DNS

Open:

vnet-az104-network-01 → DNS servers

Verify that no custom DNS servers are configured.

The VNet therefore uses Azure-provided DNS behavior.

12. Private DNS

No Private DNS Zone was created in this consolidation lab.

Private DNS and private endpoint concepts were already covered in the Compute module.

13. Cleanup

After completing the lab:

Resource groups → rg-az104-networking-01 → Delete

Confirm deletion.

Do not delete:

NetworkWatcherRG

because it contains the existing Azure regional Network Watcher.
'@ | Set-Content .\portal-steps.md