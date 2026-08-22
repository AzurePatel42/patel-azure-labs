# Azure Networking Lab — CLI Commands

## Overview

This document contains the Azure CLI commands used to build and validate the AZ-104 networking lab.

Resource Group:

```text
rg-az104-networking-01



Location:

eastus
1. Resource Group
Create Resource Group
az group create `
  --name rg-az104-networking-01 `
  --location eastus `
  --output table
Verify
az group show `
  --name rg-az104-networking-01 `
  --query "{Name:name,Location:location,State:properties.provisioningState}" `
  --output table
2. Primary VNet
Create VNet
az network vnet create `
  --resource-group rg-az104-networking-01 `
  --name vnet-az104-networking-01 `
  --address-prefixes 10.40.0.0/16 `
  --output table
Verify
az network vnet show `
  --resource-group rg-az104-networking-01 `
  --name vnet-az104-networking-01 `
  --query "{Name:name,AddressSpace:addressSpace.addressPrefixes,State:provisioningState}" `
  --output table
3. Web Subnet
Create
az network vnet subnet create `
  --resource-group rg-az104-networking-01 `
  --vnet-name vnet-az104-networking-01 `
  --name snet-web `
  --address-prefixes 10.40.1.0/24 `
  --output table
Verify
az network vnet subnet show `
  --resource-group rg-az104-networking-01 `
  --vnet-name vnet-az104-networking-01 `
  --name snet-web `
  --query "{Name:name,Prefix:addressPrefix}" `
  --output table
4. App Subnet
az network vnet subnet create `
  --resource-group rg-az104-networking-01 `
  --vnet-name vnet-az104-networking-01 `
  --name snet-app `
  --address-prefixes 10.40.2.0/24 `
  --output table
5. Private Endpoint Subnet
az network vnet subnet create `
  --resource-group rg-az104-networking-01 `
  --vnet-name vnet-az104-networking-01 `
  --name snet-private-endpoints `
  --address-prefixes 10.40.3.0/24 `
  --output table
Verify All Subnets
az network vnet subnet list `
  --resource-group rg-az104-networking-01 `
  --vnet-name vnet-az104-networking-01 `
  --query "[].{Subnet:name,Prefix:addressPrefix}" `
  --output table
6. Public IP
Create
az network public-ip create `
  --resource-group rg-az104-networking-01 `
  --name pip-networking-01 `
  --location eastus `
  --sku Standard `
  --allocation-method Static `
  --output table
Verify
az network public-ip show `
  --resource-group rg-az104-networking-01 `
  --name pip-networking-01 `
  --query "{Name:name,IP:ipAddress,SKU:sku.name,State:provisioningState}" `
  --output table
7. Network Interface

The web NIC was created and associated with the web subnet and public IP.

Example configuration:

az network nic create `
  --resource-group rg-az104-networking-01 `
  --name nic-networking-web-01 `
  --vnet-name vnet-az104-networking-01 `
  --subnet snet-web `
  --public-ip-address pip-networking-01 `
  --output table
Verify
az network nic show `
  --resource-group rg-az104-networking-01 `
  --name nic-networking-web-01 `
  --query "{Name:name,PrivateIP:ipConfigurations[0].privateIPAddress,PublicIP:ipConfigurations[0].publicIPAddress.id,Subnet:ipConfigurations[0].subnet.id}" `
  --output table
8. Web NSG
Create
az network nsg create `
  --resource-group rg-az104-networking-01 `
  --name nsg-networking-web-01 `
  --location eastus `
  --output table
Verify
az network nsg show `
  --resource-group rg-az104-networking-01 `
  --name nsg-networking-web-01 `
  --query "{Name:name,State:provisioningState,Location:location}" `
  --output table
9. HTTP NSG Rule
az network nsg rule create `
  --resource-group rg-az104-networking-01 `
  --nsg-name nsg-networking-web-01 `
  --name Allow-HTTP `
  --priority 100 `
  --direction Inbound `
  --access Allow `
  --protocol Tcp `
  --source-address-prefixes Internet `
  --source-port-ranges "*" `
  --destination-address-prefixes "*" `
  --destination-port-ranges 80 `
  --output table
Verify
az network nsg rule list `
  --resource-group rg-az104-networking-01 `
  --nsg-name nsg-networking-web-01 `
  --query "[].{Priority:priority,Name:name,Direction:direction,Access:access,Source:sourceAddressPrefix,DestinationPort:destinationPortRange}" `
  --output table
10. Associate Web NSG
az network vnet subnet update `
  --resource-group rg-az104-networking-01 `
  --vnet-name vnet-az104-networking-01 `
  --name snet-web `
  --network-security-group nsg-networking-web-01 `
  --output table
Verify
az network vnet subnet show `
  --resource-group rg-az104-networking-01 `
  --vnet-name vnet-az104-networking-01 `
  --name snet-web `
  --query "{Name:name,Prefix:addressPrefix,NSG:networkSecurityGroup.id}" `
  --output table
11. App NSG
Create
az network nsg create `
  --resource-group rg-az104-networking-01 `
  --name nsg-networking-app-01 `
  --location eastus `
  --output table
12. Allow SSH From Web Subnet
az network nsg rule create `
  --resource-group rg-az104-networking-01 `
  --nsg-name nsg-networking-app-01 `
  --name Allow-SSH-From-Web `
  --priority 100 `
  --direction Inbound `
  --access Allow `
  --protocol Tcp `
  --source-address-prefixes 10.40.1.0/24 `
  --source-port-ranges "*" `
  --destination-address-prefixes "*" `
  --destination-port-ranges 22 `
  --output table
Verify
az network nsg rule list `
  --resource-group rg-az104-networking-01 `
  --nsg-name nsg-networking-app-01 `
  --query "[].{Name:name,Priority:priority,Direction:direction,Access:access,Protocol:protocol,Source:sourceAddressPrefix,DestinationPort:destinationPortRange}" `
  --output table
13. Associate App NSG
az network vnet subnet update `
  --resource-group rg-az104-networking-01 `
  --vnet-name vnet-az104-networking-01 `
  --name snet-app `
  --network-security-group nsg-networking-app-01 `
  --output table
14. NSG Priority Demonstration

Temporary deny rule:

az network nsg rule create `
  --resource-group rg-az104-networking-01 `
  --nsg-name nsg-networking-web-01 `
  --name Deny-HTTP-Test `
  --priority 200 `
  --direction Inbound `
  --access Deny `
  --protocol Tcp `
  --source-address-prefixes 10.40.2.0/24 `
  --source-port-ranges "*" `
  --destination-address-prefixes "*" `
  --destination-port-ranges 80 `
  --output table

Inspect:

az network nsg rule list `
  --resource-group rg-az104-networking-01 `
  --nsg-name nsg-networking-web-01 `
  --query "[].{Priority:priority,Name:name,Direction:direction,Access:access,Source:sourceAddressPrefix,DestinationPort:destinationPortRange}" `
  --output table

Delete temporary rule:

az network nsg rule delete `
  --resource-group rg-az104-networking-01 `
  --nsg-name nsg-networking-web-01 `
  --name Deny-HTTP-Test

Final verification:

az network nsg rule list `
  --resource-group rg-az104-networking-01 `
  --nsg-name nsg-networking-web-01 `
  --query "[].{Priority:priority,Name:name,Direction:direction,Access:access}" `
  --output table
15. Route Table
Create
az network route-table create `
  --resource-group rg-az104-networking-01 `
  --name rt-networking-app-01 `
  --location eastus `
  --output table
Verify
az network route-table show `
  --resource-group rg-az104-networking-01 `
  --name rt-networking-app-01 `
  --query "{Name:name,State:provisioningState,Location:location}" `
  --output table
16. User Defined Route
az network route-table route create `
  --resource-group rg-az104-networking-01 `
  --route-table-name rt-networking-app-01 `
  --name Route-To-Test-Network `
  --address-prefix 10.50.0.0/16 `
  --next-hop-type VirtualAppliance `
  --next-hop-ip-address 10.40.1.10 `
  --output table
Verify
az network route-table route show `
  --resource-group rg-az104-networking-01 `
  --route-table-name rt-networking-app-01 `
  --name Route-To-Test-Network `
  --query "{Name:name,Prefix:addressPrefix,NextHopType:nextHopType,NextHopIP:nextHopIpAddress,State:provisioningState}" `
  --output table
17. Associate Route Table With App Subnet
az network vnet subnet update `
  --resource-group rg-az104-networking-01 `
  --vnet-name vnet-az104-networking-01 `
  --name snet-app `
  --route-table rt-networking-app-01 `
  --output table
Verify
az network vnet subnet show `
  --resource-group rg-az104-networking-01 `
  --vnet-name vnet-az104-networking-01 `
  --name snet-app `
  --query "{Subnet:name,Prefix:addressPrefix,NSG:networkSecurityGroup.id,RouteTable:routeTable.id}" `
  --output table
18. VNet-02
Create
az network vnet create `
  --resource-group rg-az104-networking-01 `
  --name vnet-az104-networking-02 `
  --address-prefixes 10.60.0.0/16 `
  --output table
Verify
az network vnet show `
  --resource-group rg-az104-networking-01 `
  --name vnet-az104-networking-02 `
  --query "{Name:name,AddressSpace:addressSpace.addressPrefixes,State:provisioningState}" `
  --output table
19. VNet Peering
VNet-01 → VNet-02
az network vnet peering create `
  --resource-group rg-az104-networking-01 `
  --name peer-vnet01-to-vnet02 `
  --vnet-name vnet-az104-networking-01 `
  --remote-vnet vnet-az104-networking-02 `
  --allow-vnet-access `
  --output table
VNet-02 → VNet-01
az network vnet peering create `
  --resource-group rg-az104-networking-01 `
  --name peer-vnet02-to-vnet01 `
  --vnet-name vnet-az104-networking-02 `
  --remote-vnet vnet-az104-networking-01 `
  --allow-vnet-access `
  --output table
Verify VNet-01
az network vnet peering list `
  --resource-group rg-az104-networking-01 `
  --vnet-name vnet-az104-networking-01 `
  --query "[].{Name:name,RemoteVNet:remoteVirtualNetwork.id,State:peeringState,Access:allowVirtualNetworkAccess}" `
  --output table
Verify VNet-02
az network vnet peering list `
  --resource-group rg-az104-networking-01 `
  --vnet-name vnet-az104-networking-02 `
  --query "[].{Name:name,RemoteVNet:remoteVirtualNetwork.id,State:peeringState,Access:allowVirtualNetworkAccess}" `
  --output table
20. Azure DNS
Create DNS Zone
az network dns zone create `
  --resource-group rg-az104-networking-01 `
  --name lab.az104.example `
  --output table
Verify
az network dns zone show `
  --resource-group rg-az104-networking-01 `
  --name lab.az104.example `
  --output table
Create A Record
az network dns record-set a add-record `
  --resource-group rg-az104-networking-01 `
  --zone-name lab.az104.example `
  --record-set-name web `
  --ipv4-address 20.75.220.55 `
  --output table
Verify A Record
az network dns record-set a show `
  --resource-group rg-az104-networking-01 `
  --zone-name lab.az104.example `
  --name web `
  --query "aRecords[].ipv4Address" `
  --output tsv
21. Private DNS
Create Private DNS Zone
az network private-dns zone create `
  --resource-group rg-az104-networking-01 `
  --name internal.lab `
  --output table
Link VNet
az network private-dns link vnet create `
  --resource-group rg-az104-networking-01 `
  --zone-name internal.lab `
  --name link-networking-vnet-01 `
  --virtual-network vnet-az104-networking-01 `
  --registration-enabled false `
  --output table
Verify Link
az network private-dns link vnet show `
  --resource-group rg-az104-networking-01 `
  --zone-name internal.lab `
  --name link-networking-vnet-01 `
  --query "{Name:name,State:provisioningState,Registration:registrationEnabled,VNet:virtualNetwork.id}" `
  --output table
Create Private A Record
az network private-dns record-set a create `
  --resource-group rg-az104-networking-01 `
  --zone-name internal.lab `
  --name db `
  --output table
az network private-dns record-set a add-record `
  --resource-group rg-az104-networking-01 `
  --zone-name internal.lab `
  --record-set-name db `
  --ipv4-address 10.40.2.10 `
  --output table
Verify
az network private-dns record-set a show `
  --resource-group rg-az104-networking-01 `
  --zone-name internal.lab `
  --name db `
  --output json
22. Storage Service Endpoint

Enable Microsoft.Storage on the application subnet:

az network vnet subnet update `
  --resource-group rg-az104-networking-01 `
  --vnet-name vnet-az104-networking-01 `
  --name snet-app `
  --service-endpoints Microsoft.Storage `
  --output table

Verify:

az network vnet subnet show `
  --resource-group rg-az104-networking-01 `
  --vnet-name vnet-az104-networking-01 `
  --name snet-app `
  --query "{Subnet:name,ServiceEndpoints:serviceEndpoints[].service}" `
  --output json
23. Storage Account
az storage account create `
  --resource-group rg-az104-networking-01 `
  --name staz104netlab01 `
  --location eastus `
  --sku Standard_LRS `
  --kind StorageV2 `
  --output table

Verify:

az storage account show `
  --resource-group rg-az104-networking-01 `
  --name staz104netlab01 `
  --query "{Name:name,Location:location,State:provisioningState}" `
  --output table
24. Private Endpoint

Create the endpoint:

az network private-endpoint create `
  --resource-group rg-az104-networking-01 `
  --name pe-storage-01 `
  --vnet-name vnet-az104-networking-01 `
  --subnet snet-private-endpoints `
  --private-connection-resource-id $(az storage account show `
      --resource-group rg-az104-networking-01 `
      --name staz104netlab01 `
      --query id `
      --output tsv) `
  --group-id blob `
  --connection-name pe-storage-connection-01 `
  --output table
Verify
az network private-endpoint show `
  --resource-group rg-az104-networking-01 `
  --name pe-storage-01 `
  --query "{Name:name,State:provisioningState,Subnet:subnet.id,Connection:privateLinkServiceConnections[0].privateLinkServiceConnectionState.status}" `
  --output table
25. Private Endpoint DNS Zone Group
az network private-endpoint dns-zone-group create `
  --resource-group rg-az104-networking-01 `
  --endpoint-name pe-storage-01 `
  --name private-dns-zone-group `
  --private-dns-zone internal.lab `
  --zone-name storage `
  --output table
Verify
az network private-endpoint dns-zone-group show `
  --resource-group rg-az104-networking-01 `
  --endpoint-name pe-storage-01 `
  --name private-dns-zone-group `
  --output table
26. Inspect Private Endpoint IP
az network private-endpoint show `
  --resource-group rg-az104-networking-01 `
  --name pe-storage-01 `
  --query "customDnsConfigs"
27. Private DNS Records
az network private-dns record-set list `
  --resource-group rg-az104-networking-01 `
  --zone-name internal.lab `
  --query "[].{Name:name,Type:type,TTL:ttl}" `
  --output table
28. Load Balancer Public IP
az network public-ip create `
  --resource-group rg-az104-networking-01 `
  --name pip-lb-networking-01 `
  --location eastus `
  --sku Standard `
  --allocation-method Static `
  --output table

Verify:

az network public-ip show `
  --resource-group rg-az104-networking-01 `
  --name pip-lb-networking-01 `
  --query "{Name:name,IP:ipAddress,SKU:sku.name,State:provisioningState}" `
  --output table
29. Load Balancer
az network lb create `
  --resource-group rg-az104-networking-01 `
  --name lb-networking-01 `
  --sku Standard `
  --public-ip-address pip-lb-networking-01 `
  --frontend-ip-name frontend-public `
  --backend-pool-name backend-pool `
  --output table
Verify
az network lb show `
  --resource-group rg-az104-networking-01 `
  --name lb-networking-01 `
  --query "{Name:name,SKU:sku.name,State:provisioningState,Frontend:frontendIPConfigurations[0].name,BackendPool:backendAddressPools[0].name}" `
  --output table
30. Load Balancer Health Probe
az network lb probe create `
  --resource-group rg-az104-networking-01 `
  --lb-name lb-networking-01 `
  --name probe-http `
  --protocol Tcp `
  --port 80 `
  --interval 5 `
  --threshold 2 `
  --output table

Verify:

az network lb probe show `
  --resource-group rg-az104-networking-01 `
  --lb-name lb-networking-01 `
  --name probe-http `
  --query "{Name:name,Protocol:protocol,Port:port,Interval:intervalInSeconds,Threshold:numberOfProbes}" `
  --output table
31. Load Balancing Rule
az network lb rule create `
  --resource-group rg-az104-networking-01 `
  --lb-name lb-networking-01 `
  --name rule-http `
  --frontend-ip-name frontend-public `
  --frontend-port 80 `
  --backend-pool-name backend-pool `
  --backend-port 80 `
  --protocol Tcp `
  --probe-name probe-http `
  --output table

Verify:

az network lb rule show `
  --resource-group rg-az104-networking-01 `
  --lb-name lb-networking-01 `
  --name rule-http `
  --query "{Name:name,Protocol:protocol,FrontendPort:frontendPort,BackendPort:backendPort,Probe:probe.id}" `
  --output table
32. Inspect Backend Pool
az network lb address-pool show `
  --resource-group rg-az104-networking-01 `
  --lb-name lb-networking-01 `
  --name backend-pool `
  --query "{Name:name,BackendAddresses:backendIPConfigurations}" `
  --output json

The backend pool was intentionally left without backend VMs/NICs.

33. Inspect Complete Load Balancer
az network lb show `
  --resource-group rg-az104-networking-01 `
  --name lb-networking-01 `
  --query "{Name:name,SKU:sku.name,Frontend:frontendIPConfigurations[].name,BackendPools:backendAddressPools[].name,Probes:probes[].name,Rules:loadBalancingRules[].name}" `
  --output json
34. Network Watcher
List Network Watchers
az network watcher list `
  --output table

Expected East US watcher:

NetworkWatcher_eastus
NetworkWatcherRG

Note: the installed Azure CLI version used in this lab did not support:

az network watcher show

Therefore Network Watcher was verified through the supported list command.

35. Final Resource Inspection
Resource Groups
az group list `
  --query "[].{Name:name,Location:location,State:properties.provisioningState}" `
  --output table
Lab Resources
az resource list `
  --resource-group rg-az104-networking-01 `
  --query "[].{Name:name,Type:type,Location:location}" `
  --output table
Subnet Configuration
az network vnet subnet list `
  --resource-group rg-az104-networking-01 `
  --vnet-name vnet-az104-networking-01 `
  --query "[].{Subnet:name,Prefix:addressPrefix,NSG:networkSecurityGroup.id,RouteTable:routeTable.id}" `
  --output table
Final Route Inspection
az network route-table route list `
  --resource-group rg-az104-networking-01 `
  --route-table-name rt-networking-app-01 `
  --query "[].{Name:name,Prefix:addressPrefix,NextHopType:nextHopType,NextHopIP:nextHopIpAddress}" `
  --output table
Final App NSG Inspection
az network nsg show `
  --resource-group rg-az104-networking-01 `
  --name nsg-networking-app-01 `
  --query "{Name:name,Rules:securityRules[].{Name:name,Priority:priority,Direction:direction,Access:access,Protocol:protocol,Source:sourceAddressPrefix,DestinationPort:destinationPortRange}}" `
  --output json
36. Cleanup

Before deleting the lab, inspect resources:

az resource list `
  --resource-group rg-az104-networking-01 `
  --output table

Delete the lab resource group:

az group delete `
  --name rg-az104-networking-01 `
  --yes

Verify deletion:

az group exists `
  --name rg-az104-networking-01

Expected:

false
Command-Line Lessons

Important Azure CLI patterns used throughout this lab:

az group
az resource
az network vnet
az network vnet subnet
az network public-ip
az network nic
az network nsg
az network nsg rule
az network route-table
az network route-table route
az network vnet peering
az network dns
az network private-dns
az network private-endpoint
az network lb
az network watcher

PowerShell multiline commands use the backtick character:

`

JMESPath queries were used extensively with:

--query

and output was commonly formatted with:

--output table
--output json
--output tsv

This combination makes Azure CLI useful for both infrastructure deployment and operational inspection.