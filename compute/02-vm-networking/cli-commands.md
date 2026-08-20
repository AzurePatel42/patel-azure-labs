# Compute Module 02 — VM Networking & Network Security

## Objective

Use Azure CLI to build, inspect, troubleshoot, and clean up an Azure VM networking environment.

This lab was built layer-by-layer instead of allowing the VM wizard to automatically create the networking resources.

---

# 1. Resource Group

## Create

```powershell
az group create `
  --name rg-az104-vm-networking-01 `
  --location eastus `
  --output table



Verify
az group show `
  --name rg-az104-vm-networking-01 `
  --output table
2. Virtual Network
Create VNet and Subnet
az network vnet create `
  --resource-group rg-az104-vm-networking-01 `
  --name vnet-az104-networking-01 `
  --address-prefix 10.10.0.0/16 `
  --subnet-name snet-web-01 `
  --subnet-prefix 10.10.1.0/24 `
  --output table
Verify VNet
az network vnet show `
  --resource-group rg-az104-vm-networking-01 `
  --name vnet-az104-networking-01 `
  --output table
Verify Subnet
az network vnet subnet show `
  --resource-group rg-az104-vm-networking-01 `
  --vnet-name vnet-az104-networking-01 `
  --name snet-web-01 `
  --output table
3. Network Security Group
Create NSG
az network nsg create `
  --resource-group rg-az104-vm-networking-01 `
  --name nsg-web-01 `
  --location eastus `
  --output table
Verify NSG
az network nsg show `
  --resource-group rg-az104-vm-networking-01 `
  --name nsg-web-01 `
  --output table
4. SSH Inbound Rule
Create Allow-SSH Rule
az network nsg rule create `
  --resource-group rg-az104-vm-networking-01 `
  --nsg-name nsg-web-01 `
  --name Allow-SSH `
  --priority 100 `
  --direction Inbound `
  --access Allow `
  --protocol Tcp `
  --source-address-prefixes "*" `
  --source-port-ranges "*" `
  --destination-address-prefixes "*" `
  --destination-port-ranges 22 `
  --output table
List NSG Rules
az network nsg rule list `
  --resource-group rg-az104-vm-networking-01 `
  --nsg-name nsg-web-01 `
  --output table
5. Associate NSG with Subnet
az network vnet subnet update `
  --resource-group rg-az104-vm-networking-01 `
  --vnet-name vnet-az104-networking-01 `
  --name snet-web-01 `
  --network-security-group nsg-web-01 `
  --output table
Verify Association
az network vnet subnet show `
  --resource-group rg-az104-vm-networking-01 `
  --vnet-name vnet-az104-networking-01 `
  --name snet-web-01 `
  --output json

Look for:

networkSecurityGroup
6. Public IP
Create Public IP
az network public-ip create `
  --resource-group rg-az104-vm-networking-01 `
  --name pip-vm-networking-01 `
  --location eastus `
  --sku Standard `
  --allocation-method Static `
  --output table
Verify Public IP
az network public-ip show `
  --resource-group rg-az104-vm-networking-01 `
  --name pip-vm-networking-01 `
  --output table

Observed public IP:

20.102.48.166
7. Network Interface
Create NIC
az network nic create `
  --resource-group rg-az104-vm-networking-01 `
  --name nic-vm-networking-01 `
  --vnet-name vnet-az104-networking-01 `
  --subnet snet-web-01 `
  --public-ip-address pip-vm-networking-01 `
  --output table
Verify NIC
az network nic show `
  --resource-group rg-az104-vm-networking-01 `
  --name nic-vm-networking-01 `
  --output table
Verify NIC IP Configuration
az network nic ip-config list `
  --resource-group rg-az104-vm-networking-01 `
  --nic-name nic-vm-networking-01 `
  --output table

Observed private IP:

10.10.1.4
8. SSH Public Key Troubleshooting

The original private key was:

C:\Users\mahes\Downloads\vm-az104-linux-01_key.pem

The first attempt to generate a public key resulted in a .pub file that OpenSSH rejected.

Failed validation
ssh-keygen -lf "$env:USERPROFILE\Downloads\vm-az104-linux-01_key.pub"

Result:

is not a public key file.

This identified a problem with how the public key file had been generated/encoded.

Regenerate Public Key
ssh-keygen -y -f "$env:USERPROFILE\Downloads\vm-az104-linux-01_key.pem" |
    Set-Content -Encoding ascii "$env:USERPROFILE\Downloads\vm-az104-linux-01_key.pub"
Verify Public Key
ssh-keygen -lf "$env:USERPROFILE\Downloads\vm-az104-linux-01_key.pub"

Successful result included:

3072 SHA256:uVEZck8fc0JR9PTArYMVvvbznRTPb+P4p3caWKGJ84M no comment (RSA)
9. Load Public Key into PowerShell Variable
$sshPublicKey = (Get-Content "$env:USERPROFILE\Downloads\vm-az104-linux-01_key.pub" -Raw).Trim()

Verify:

$sshPublicKey.Length

The value was non-zero.

10. Create VM Using Existing NIC

The VM was created using the networking resources built manually.

az vm create `
  --resource-group rg-az104-vm-networking-01 `
  --name vm-az104-networking-01 `
  --nics nic-vm-networking-01 `
  --image Ubuntu2404 `
  --size Standard_D2ads_v7 `
  --admin-username azureuser `
  --ssh-key-values $sshPublicKey `
  --output table

The VM was created successfully.

Observed:

PowerState:
VM running


Public IP:
20.102.48.166


Private IP:
10.10.1.4
11. Verify VM
az vm show `
  --resource-group rg-az104-vm-networking-01 `
  --name vm-az104-networking-01 `
  --show-details `
  --output table
Verify VM IP Addresses
az vm list-ip-addresses `
  --resource-group rg-az104-vm-networking-01 `
  --name vm-az104-networking-01 `
  --output table
12. Verify NIC → Subnet → Public IP → VM
az network nic show `
  --resource-group rg-az104-vm-networking-01 `
  --name nic-vm-networking-01 `
  --output json

Important relationships confirmed:

NIC
 ↓
Private IP: 10.10.1.4
 ↓
Subnet: snet-web-01
 ↓
Public IP: pip-vm-networking-01
 ↓
VM: vm-az104-networking-01
13. Test SSH Port

From Windows PowerShell:

Test-NetConnection 20.102.48.166 -Port 22

Successful result:

TcpTestSucceeded : True
14. SSH Connection
ssh -i "C:\Users\mahes\Downloads\vm-az104-linux-01_key.pem" azureuser@20.102.48.166

Successful login:

azureuser@vm-az104-networking-01:~$
15. Intentional NSG Failure
Change SSH Rule to Deny
az network nsg rule update `
  --resource-group rg-az104-vm-networking-01 `
  --nsg-name nsg-web-01 `
  --name Allow-SSH `
  --access Deny `
  --output table
Test Connectivity
Test-NetConnection 20.102.48.166 -Port 22

Expected:

TcpTestSucceeded : False
16. Verify VM During Failure
az vm get-instance-view `
  --resource-group rg-az104-vm-networking-01 `
  --name vm-az104-networking-01 `
  --query "instanceView.statuses[].displayStatus" `
  --output table

The VM remained:

VM running

This proved the failure was not caused by VM power state.

17. Verify IP During Failure
az vm list-ip-addresses `
  --resource-group rg-az104-vm-networking-01 `
  --name vm-az104-networking-01 `
  --output table

Public IP remained:

20.102.48.166

Private IP remained:

10.10.1.4
18. Inspect Failing NSG Rule
az network nsg rule show `
  --resource-group rg-az104-vm-networking-01 `
  --nsg-name nsg-web-01 `
  --name Allow-SSH `
  --output table

The critical result was:

Access: Deny
Protocol: Tcp
Direction: Inbound
Port: 22
Priority: 100
19. Restore SSH Rule
az network nsg rule update `
  --resource-group rg-az104-vm-networking-01 `
  --nsg-name nsg-web-01 `
  --name Allow-SSH `
  --access Allow `
  --output table
Test Again
Test-NetConnection 20.102.48.166 -Port 22

Successful:

TcpTestSucceeded : True
20. Effective NSG Rules
az network nic list-effective-nsg `
  --resource-group rg-az104-vm-networking-01 `
  --name nic-vm-networking-01 `
  --output json

Important effective rule:

Allow
TCP
Inbound
22
Priority 100

Default inbound rules included:

AllowVnetInBound
AllowAzureLoadBalancerInBound
DenyAllInBound
21. Effective Routes
az network nic show-effective-route-table `
  --resource-group rg-az104-vm-networking-01 `
  --name nic-vm-networking-01 `
  --output table

Important system routes included:

10.10.0.0/16 → VnetLocal
0.0.0.0/0    → Internet
22. Route Table
Create
az network route-table create `
  --resource-group rg-az104-vm-networking-01 `
  --name rt-web-01 `
  --location eastus `
  --output table
Verify
az network route-table show `
  --resource-group rg-az104-vm-networking-01 `
  --name rt-web-01 `
  --output table
23. User Defined Route
Create Test Route
az network route-table route create `
  --resource-group rg-az104-vm-networking-01 `
  --route-table-name rt-web-01 `
  --name TestRoute `
  --address-prefix 10.20.0.0/16 `
  --next-hop-type None `
  --output table
Verify
az network route-table route show `
  --resource-group rg-az104-vm-networking-01 `
  --route-table-name rt-web-01 `
  --name TestRoute `
  --output table
24. Associate Route Table with Subnet
az network vnet subnet update `
  --resource-group rg-az104-vm-networking-01 `
  --vnet-name vnet-az104-networking-01 `
  --name snet-web-01 `
  --route-table rt-web-01 `
  --output table
25. Verify Effective UDR
az network nic show-effective-route-table `
  --resource-group rg-az104-vm-networking-01 `
  --name nic-vm-networking-01 `
  --output table

The custom route appeared as:

User
Active
10.20.0.0/16
None
26. Remove Test UDR
az network route-table route delete `
  --resource-group rg-az104-vm-networking-01 `
  --route-table-name rt-web-01 `
  --name TestRoute
Detach Route Table

The empty string syntax was rejected by Azure CLI.

Working syntax:

az network vnet subnet update `
  --resource-group rg-az104-vm-networking-01 `
  --vnet-name vnet-az104-networking-01 `
  --name snet-web-01 `
  --route-table null `
  --output table
Verify Detachment
az network vnet subnet show `
  --resource-group rg-az104-vm-networking-01 `
  --vnet-name vnet-az104-networking-01 `
  --name snet-web-01 `
  --query routeTable `
  --output json

No route table was returned.

Delete Route Table
az network route-table delete `
  --resource-group rg-az104-vm-networking-01 `
  --name rt-web-01
27. DNS / Linux Verification

After reconnecting through SSH:

hostname
hostname -f
cat /etc/resolv.conf
ip addr show eth0
resolvectl status
getent hosts vm-az104-networking-01
getent hosts vm-az104-networking-01.<azure-internal-domain>

The fully qualified internal hostname resolved to:

10.10.1.4

Azure DNS server observed:

168.63.129.16
28. Final Cleanup
Delete Resource Group
az group delete `
  --name rg-az104-vm-networking-01 `
  --yes
Verify Deletion
az group exists --name rg-az104-vm-networking-01

Final result:

false

This confirmed the temporary networking lab was completely removed.