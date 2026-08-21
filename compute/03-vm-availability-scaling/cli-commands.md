# Compute Module 03 — VM Availability & Scaling

## Objective

Build and operate an Azure VM Scale Set environment using Azure CLI.

This command history covers:

- Resource Group
- VNet
- Subnet
- NSG
- HTTP security rule
- Load Balancer
- Public IP
- Health Probe
- Load-Balancing Rule
- VM Scale Set
- Availability Zones
- Autoscale
- CPU monitoring
- Controlled CPU load
- Scale-out
- Scale-in
- Cleanup

---

# 1. Resource Group

## Create

```powershell
az group create `
  --name rg-az104-vm-scaling-01 `
  --location eastus `
  --output table



Verify
az group show `
  --name rg-az104-vm-scaling-01 `
  --output table
2. Virtual Network
Create VNet and Subnet
az network vnet create `
  --resource-group rg-az104-vm-scaling-01 `
  --name vnet-az104-scaling-01 `
  --address-prefix 10.20.0.0/16 `
  --subnet-name snet-vmss-01 `
  --subnet-prefix 10.20.1.0/24 `
  --output table
Verify VNet
az network vnet show `
  --resource-group rg-az104-vm-scaling-01 `
  --name vnet-az104-scaling-01 `
  --output table
Verify Subnet
az network vnet subnet show `
  --resource-group rg-az104-vm-scaling-01 `
  --vnet-name vnet-az104-scaling-01 `
  --name snet-vmss-01 `
  --output table
3. Network Security Group
Create
az network nsg create `
  --resource-group rg-az104-vm-scaling-01 `
  --name nsg-vmss-01 `
  --location eastus `
  --output table
Verify
az network nsg show `
  --resource-group rg-az104-vm-scaling-01 `
  --name nsg-vmss-01 `
  --output table
4. HTTP Inbound Rule
az network nsg rule create `
  --resource-group rg-az104-vm-scaling-01 `
  --nsg-name nsg-vmss-01 `
  --name Allow-HTTP `
  --priority 100 `
  --direction Inbound `
  --access Allow `
  --protocol Tcp `
  --source-address-prefixes "*" `
  --source-port-ranges "*" `
  --destination-address-prefixes "*" `
  --destination-port-ranges 80 `
  --output table
Verify
az network nsg rule list `
  --resource-group rg-az104-vm-scaling-01 `
  --nsg-name nsg-vmss-01 `
  --output table
5. Associate NSG with Subnet
az network vnet subnet update `
  --resource-group rg-az104-vm-scaling-01 `
  --vnet-name vnet-az104-scaling-01 `
  --name snet-vmss-01 `
  --network-security-group nsg-vmss-01 `
  --output table
Verify
az network vnet subnet show `
  --resource-group rg-az104-vm-scaling-01 `
  --vnet-name vnet-az104-scaling-01 `
  --name snet-vmss-01 `
  --output json
6. Load Balancer Public IP
az network public-ip create `
  --resource-group rg-az104-vm-scaling-01 `
  --name lb-vmss-public-ip `
  --sku Standard `
  --allocation-method Static `
  --location eastus `
  --output table
7. Load Balancer
az network lb create `
  --resource-group rg-az104-vm-scaling-01 `
  --name lb-vmss-01 `
  --sku Standard `
  --location eastus `
  --frontend-ip-name lb-frontend `
  --backend-pool-name vmss-backend-pool `
  --public-ip-address lb-vmss-public-ip `
  --output table
Verify
az network lb show `
  --resource-group rg-az104-vm-scaling-01 `
  --name lb-vmss-01 `
  --output table
8. Health Probe
az network lb probe create `
  --resource-group rg-az104-vm-scaling-01 `
  --lb-name lb-vmss-01 `
  --name http-health-probe `
  --protocol Http `
  --port 80 `
  --path / `
  --interval 15 `
  --threshold 2 `
  --output table
Verify
az network lb probe show `
  --resource-group rg-az104-vm-scaling-01 `
  --lb-name lb-vmss-01 `
  --name http-health-probe `
  --output table

Observed:

Protocol: Http
Port: 80
Path: /
Interval: 15 seconds
Number of probes: 2
Probe threshold: 1
State: Succeeded
9. Load-Balancing Rule
az network lb rule create `
  --resource-group rg-az104-vm-scaling-01 `
  --lb-name lb-vmss-01 `
  --name http-load-balancing-rule `
  --protocol Tcp `
  --frontend-port 80 `
  --backend-port 80 `
  --frontend-ip-name lb-frontend `
  --backend-pool-name vmss-backend-pool `
  --probe-name http-health-probe `
  --output table
Verify
az network lb rule show `
  --resource-group rg-az104-vm-scaling-01 `
  --lb-name lb-vmss-01 `
  --name http-load-balancing-rule `
  --output table
10. SSH Public Key

The public key was generated previously from:

C:\Users\mahes\Downloads\vm-az104-linux-01_key.pem

Because a new PowerShell session was used for Module 03, the public key was reloaded into a variable.

$sshPublicKey = (Get-Content "$env:USERPROFILE\Downloads\vm-az104-linux-01_key.pub" -Raw).Trim()

Verify:

$sshPublicKey.Length

Observed:

552
11. VM Scale Set
Create
az vmss create `
  --resource-group rg-az104-vm-scaling-01 `
  --name vmss-az104-01 `
  --orchestration-mode Uniform `
  --image Ubuntu2404 `
  --admin-username azureuser `
  --ssh-key-values $sshPublicKey `
  --vm-sku Standard_D2ads_v7 `
  --instance-count 2 `
  --zones 1 2 `
  --upgrade-policy-mode Automatic `
  --vnet-name vnet-az104-scaling-01 `
  --subnet snet-vmss-01 `
  --lb lb-vmss-01 `
  --backend-pool-name vmss-backend-pool `
  --output table

The command produced a future-default warning for VM size, but the explicitly selected:

Standard_D2ads_v7

was used.

12. Verify VMSS
az vmss show `
  --resource-group rg-az104-vm-scaling-01 `
  --name vmss-az104-01 `
  --output table

Expected baseline:

Capacity: 2
Zones: 1 2
UpgradePolicy: Automatic
13. List VMSS Instances
az vmss list-instances `
  --resource-group rg-az104-vm-scaling-01 `
  --name vmss-az104-01 `
  --output table
14. Verify Zone Placement

Initial focused query:

az vmss list-instances `
  --resource-group rg-az104-vm-scaling-01 `
  --name vmss-az104-01 `
  --query "[].{Instance:instanceId,Zone:zones[0],State:provisioningState}" `
  --output table

Initial result:

0 → Zone 1 → Succeeded
1 → Zone 2 → Succeeded

After scale-out to four instances:

0 → Zone 1
1 → Zone 2
2 → Zone 1
3 → Zone 2
15. VMSS NIC Inspection

Attempted:

az vmss nic list `
  --resource-group rg-az104-vm-scaling-01 `
  --vmss-name vmss-az104-01

The output exposed the VMSS instance IDs, but the attempted table projections did not display the private IP field as expected.

The lab therefore continued using VMSS instance IDs and Run Command rather than relying on private IP discovery.

16. VMSS Run Command Syntax Correction

Initial attempt:

az vmss run-command invoke `
  --resource-group rg-az104-vm-scaling-01 `
  --vmss-name vmss-az104-01 `
  ...

Result:

unrecognized arguments: --vmss-name vmss-az104-01

Correct syntax used:

az vmss run-command invoke `
  --resource-group rg-az104-vm-scaling-01 `
  --name vmss-az104-01 `
  --instance-id 0 `
  --command-id RunShellScript `
  --scripts "for i in 1 2; do yes > /dev/null & done" `
  --output table

The same command pattern was used for Instance 1.

17. Monitor VMSS CPU
az monitor metrics list `
  --resource "/subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec/resourceGroups/rg-az104-vm-scaling-01/providers/Microsoft.Compute/virtualMachineScaleSets/vmss-az104-01" `
  --metric "Percentage CPU" `
  --interval PT1M `
  --aggregation Average `
  --output table

Initial CPU baseline:

approximately 0.1% – 0.3%
18. Autoscale Creation

Initial command attempt:

az monitor autoscale create `
  --resource-group rg-az104-vm-scaling-01 `
  --resource vmss-az104-01 `
  --name autoscale-vmss-01 `
  --min-count 2 `
  --max-count 4 `
  --count 2 `
  --output table

Azure returned a usage error because the resource type needed to be specified.

Correct command:

az monitor autoscale create `
  --resource-group rg-az104-vm-scaling-01 `
  --resource vmss-az104-01 `
  --resource-type Microsoft.Compute/virtualMachineScaleSets `
  --name autoscale-vmss-01 `
  --min-count 2 `
  --max-count 4 `
  --count 2 `
  --output table
19. Verify Autoscale Setting
az monitor autoscale show `
  --resource-group rg-az104-vm-scaling-01 `
  --name autoscale-vmss-01 `
  --output table

Capacity policy:

Minimum: 2
Default: 2
Maximum: 4
20. Scale-Out Rule
az monitor autoscale rule create `
  --resource-group rg-az104-vm-scaling-01 `
  --autoscale-name autoscale-vmss-01 `
  --condition "Percentage CPU > 70 avg 5m" `
  --scale out 1 `
  --output table

Azure recommended adding a scale-in rule because the profile initially contained only a scale-out rule.

21. Scale-In Rule
az monitor autoscale rule create `
  --resource-group rg-az104-vm-scaling-01 `
  --autoscale-name autoscale-vmss-01 `
  --condition "Percentage CPU < 30 avg 5m" `
  --scale in 1 `
  --output table
22. Verify Autoscale Policy
az monitor autoscale show `
  --resource-group rg-az104-vm-scaling-01 `
  --name autoscale-vmss-01 `
  --output json

Final policy:

Minimum: 2
Default: 2
Maximum: 4

Scale-out:

Percentage CPU > 70%
Average
5-minute time window
Increase by 1
Cooldown: 5 minutes

Scale-in:

Percentage CPU < 30%
Average
5-minute time window
Decrease by 1
Cooldown: 5 minutes
23. Autoscale Capacity Check
az vmss show `
  --resource-group rg-az104-vm-scaling-01 `
  --name vmss-az104-01 `
  --query "sku.capacity" `
  --output tsv
24. Generate CPU Load

Instance 0:

az vmss run-command invoke `
  --resource-group rg-az104-vm-scaling-01 `
  --name vmss-az104-01 `
  --instance-id 0 `
  --command-id RunShellScript `
  --scripts "for i in 1 2; do yes > /dev/null & done" `
  --output table

Instance 1:

az vmss run-command invoke `
  --resource-group rg-az104-vm-scaling-01 `
  --name vmss-az104-01 `
  --instance-id 1 `
  --command-id RunShellScript `
  --scripts "for i in 1 2; do yes > /dev/null & done" `
  --output table
25. Observe CPU Growth

The metric increased from the normal baseline to high CPU.

Observed progression included:

~0.1%
   ↓
14.9%
   ↓
49.9%
   ↓
~99.6%
26. Observe Scale-Out

Check capacity:

az vmss show `
  --resource-group rg-az104-vm-scaling-01 `
  --name vmss-az104-01 `
  --query "sku.capacity" `
  --output tsv

Observed:

2

followed by:

3

and eventually:

4

This demonstrated automatic scale-out.

27. Verify Four Instances
az vmss list-instances `
  --resource-group rg-az104-vm-scaling-01 `
  --name vmss-az104-01 `
  --query "[].{Instance:instanceId,Zone:zones[0],State:provisioningState}" `
  --output table

Observed:

0 → Zone 1 → Succeeded
1 → Zone 2 → Succeeded
2 → Zone 1 → Succeeded
3 → Zone 2 → Succeeded
28. Stop Artificial CPU Load

Instance 0:

az vmss run-command invoke `
  --resource-group rg-az104-vm-scaling-01 `
  --name vmss-az104-01 `
  --instance-id 0 `
  --command-id RunShellScript `
  --scripts "pkill yes || true" `
  --output table

Instance 1:

az vmss run-command invoke `
  --resource-group rg-az104-vm-scaling-01 `
  --name vmss-az104-01 `
  --instance-id 1 `
  --command-id RunShellScript `
  --scripts "pkill yes || true" `
  --output table
29. Observe CPU Recovery
az monitor metrics list `
  --resource "/subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec/resourceGroups/rg-az104-vm-scaling-01/providers/Microsoft.Compute/virtualMachineScaleSets/vmss-az104-01" `
  --metric "Percentage CPU" `
  --interval PT1M `
  --aggregation Average `
  --output table

CPU decreased after the artificial workload was removed.

30. Observe Scale-In

Check capacity repeatedly:

az vmss show `
  --resource-group rg-az104-vm-scaling-01 `
  --name vmss-az104-01 `
  --query "sku.capacity" `
  --output tsv

Observed:

4
3
3
3
2

This demonstrated:

4 → 3 → 2
31. Verify Final Two-Zone State
az vmss list-instances `
  --resource-group rg-az104-vm-scaling-01 `
  --name vmss-az104-01 `
  --query "[].{Instance:instanceId,Zone:zones[0],State:provisioningState}" `
  --output table

Final result:

0 → Zone 1 → Succeeded
1 → Zone 2 → Succeeded
32. Final Load Balancer Verification
Load Balancer
az network lb show `
  --resource-group rg-az104-vm-scaling-01 `
  --name lb-vmss-01 `
  --output table
Backend Pool
az network lb address-pool show `
  --resource-group rg-az104-vm-scaling-01 `
  --lb-name lb-vmss-01 `
  --name vmss-backend-pool `
  --output table
Health Probe
az network lb probe show `
  --resource-group rg-az104-vm-scaling-01 `
  --lb-name lb-vmss-01 `
  --name http-health-probe `
  --output table

Final observed health probe:

Protocol: Http
Port: 80
Path: /
State: Succeeded
33. Cleanup

Delete the complete lab resource group:

az group delete `
  --name rg-az104-vm-scaling-01 `
  --yes
Verify Cleanup
az group exists --name rg-az104-vm-scaling-01

Final result:

false