
### 2. `cli-commands.md`

```powershell
@'
# Azure Networking — CLI Commands

Working directory:

```text
C:\patel-azure-labs\networking\01-networking-az104-consolidation


1. Create Resource Group
az group create `
  --name rg-az104-networking-01 `
  --location eastus `
  --output table

Verify:

az group show `
  --name rg-az104-networking-01 `
  --query "{Name:name,Location:location,ProvisioningState:properties.provisioningState}" `
  --output table
2. Create VNet and Subnet
az network vnet create `
  --resource-group rg-az104-networking-01 `
  --name vnet-az104-network-01 `
  --location eastus `
  --address-prefixes 10.10.0.0/16 `
  --subnet-name snet-app `
  --subnet-prefixes 10.10.1.0/24 `
  --output table

Verify:

az network vnet show `
  --resource-group rg-az104-networking-01 `
  --name vnet-az104-network-01 `
  --query "{Name:name,AddressSpace:addressSpace.addressPrefixes,Subnets:subnets[].{Name:name,Prefix:addressPrefix}}" `
  --output json
3. Add Management Subnet
az network vnet subnet create `
  --resource-group rg-az104-networking-01 `
  --vnet-name vnet-az104-network-01 `
  --name snet-management `
  --address-prefixes 10.10.2.0/24 `
  --output table

Verify:

az network vnet subnet list `
  --resource-group rg-az104-networking-01 `
  --vnet-name vnet-az104-network-01 `
  --query "[].{Name:name,Prefix:addressPrefix}" `
  --output table
4. Create NSG
az network nsg create `
  --resource-group rg-az104-networking-01 `
  --name nsg-az104-app `
  --location eastus `
  --output table
5. Create NSG Rule
az network nsg rule create `
  --resource-group rg-az104-networking-01 `
  --nsg-name nsg-az104-app `
  --name Allow-SSH `
  --priority 100 `
  --direction Inbound `
  --access Allow `
  --protocol Tcp `
  --source-address-prefixes Internet `
  --source-port-ranges "*" `
  --destination-address-prefixes "*" `
  --destination-port-ranges 22 `
  --output table

Verify:

az network nsg rule list `
  --resource-group rg-az104-networking-01 `
  --nsg-name nsg-az104-app `
  --query "[].{Name:name,Priority:priority,Direction:direction,Access:access,Protocol:protocol,DestinationPort:destinationPortRange}" `
  --output table
6. Associate NSG with Subnet
az network vnet subnet update `
  --resource-group rg-az104-networking-01 `
  --vnet-name vnet-az104-network-01 `
  --name snet-app `
  --network-security-group nsg-az104-app `
  --output table

Verify:

az network vnet subnet show `
  --resource-group rg-az104-networking-01 `
  --vnet-name vnet-az104-network-01 `
  --name snet-app `
  --query "{Subnet:name,Prefix:addressPrefix,NSG:networkSecurityGroup.id}" `
  --output table
7. Create Route Table
az network route-table create `
  --resource-group rg-az104-networking-01 `
  --name rt-az104-app `
  --location eastus `
  --output table
8. Create User Defined Route
az network route-table route create `
  --resource-group rg-az104-networking-01 `
  --route-table-name rt-az104-app `
  --name route-to-private-network `
  --address-prefix 10.20.0.0/16 `
  --next-hop-type VirtualAppliance `
  --next-hop-ip-address 10.10.2.4 `
  --output table

Verify:

az network route-table route list `
  --resource-group rg-az104-networking-01 `
  --route-table-name rt-az104-app `
  --query "[].{Name:name,AddressPrefix:addressPrefix,NextHopType:nextHopType,NextHopIP:nextHopIpAddress}" `
  --output table
9. Associate Route Table with Subnet
az network vnet subnet update `
  --resource-group rg-az104-networking-01 `
  --vnet-name vnet-az104-network-01 `
  --name snet-app `
  --route-table rt-az104-app `
  --output table

Verify:

az network vnet subnet show `
  --resource-group rg-az104-networking-01 `
  --vnet-name vnet-az104-network-01 `
  --name snet-app `
  --query "{Subnet:name,NSG:networkSecurityGroup.id,RouteTable:routeTable.id}" `
  --output table
10. Create Second VNet
az network vnet create `
  --resource-group rg-az104-networking-01 `
  --name vnet-az104-network-02 `
  --location eastus `
  --address-prefixes 10.20.0.0/16 `
  --subnet-name snet-app `
  --subnet-prefixes 10.20.1.0/24 `
  --output table
11. Create VNet Peering

VNet 1 to VNet 2:

az network vnet peering create `
  --resource-group rg-az104-networking-01 `
  --vnet-name vnet-az104-network-01 `
  --name peer-vnet01-to-vnet02 `
  --remote-vnet vnet-az104-network-02 `
  --allow-vnet-access `
  --output table

VNet 2 to VNet 1:

az network vnet peering create `
  --resource-group rg-az104-networking-01 `
  --vnet-name vnet-az104-network-02 `
  --name peer-vnet02-to-vnet01 `
  --remote-vnet vnet-az104-network-01 `
  --allow-vnet-access `
  --output table

Verify VNet 1:

az network vnet peering list `
  --resource-group rg-az104-networking-01 `
  --vnet-name vnet-az104-network-01 `
  --query "[].{Name:name,RemoteVNet:remoteVirtualNetwork.id,State:peeringState,Access:allowVirtualNetworkAccess}" `
  --output table

Verify VNet 2:

az network vnet peering list `
  --resource-group rg-az104-networking-01 `
  --vnet-name vnet-az104-network-02 `
  --query "[].{Name:name,RemoteVNet:remoteVirtualNetwork.id,State:peeringState,Access:allowVirtualNetworkAccess}" `
  --output table
12. Network Watcher

List existing Network Watcher instances:

az network watcher list `
  --query "[].{Name:name,ResourceGroup:resourceGroup,Location:location,State:provisioningState}" `
  --output table

Expected regional instance:

NetworkWatcher_eastus
NetworkWatcherRG
eastus
Succeeded
13. DNS Configuration

Inspect VNet DNS configuration:

az network vnet show `
  --resource-group rg-az104-networking-01 `
  --name vnet-az104-network-01 `
  --query "{Name:name,DnsServers:dhcpOptions.dnsServers,AddressSpace:addressSpace.addressPrefixes}" `
  --output table

A blank custom DNS value means custom DNS servers were not configured.

14. Private DNS Zone Check
az network private-dns zone list `
  --resource-group rg-az104-networking-01 `
  --query "[].{Name:name,ProvisioningState:provisioningState}" `
  --output table

No Private DNS zones were created in this consolidation resource group.

15. Cleanup
az group delete `
  --name rg-az104-networking-01 `
  --yes `
  --no-wait

Do not delete:

NetworkWatcherRG

because it contains the existing regional Network Watcher.
'@ | Set-Content .\cli-commands.md