# Compute Module 04 — VM Management, Monitoring & Operations

## Objective

Build and troubleshoot an Azure VM monitoring environment using Azure CLI.

This command history covers:

- Resource Group
- VNet
- Subnet
- NSG
- SSH rule
- Public IP
- NIC
- VM
- CPU baseline
- Network baseline
- Disk baseline
- VM health
- Azure Monitor metric alert
- VM Run Command
- CPU incident
- Process investigation
- Remediation
- Activity Log
- Cleanup

---

# 1. Resource Group

## Create

```powershell
az group create `
  --name rg-az104-vm-monitoring-01 `
  --location eastus `
  --output table



Verify
az group show `
  --name rg-az104-vm-monitoring-01 `
  --output table
2. Virtual Network
Create VNet and Subnet
az network vnet create `
  --resource-group rg-az104-vm-monitoring-01 `
  --name vnet-az104-monitoring-01 `
  --address-prefix 10.30.0.0/16 `
  --subnet-name snet-monitoring-01 `
  --subnet-prefix 10.30.1.0/24 `
  --output table
Verify VNet
az network vnet show `
  --resource-group rg-az104-vm-monitoring-01 `
  --name vnet-az104-monitoring-01 `
  --output table
Verify Subnet
az network vnet subnet show `
  --resource-group rg-az104-vm-monitoring-01 `
  --vnet-name vnet-az104-monitoring-01 `
  --name snet-monitoring-01 `
  --output table
3. Network Security Group
Create
az network nsg create `
  --resource-group rg-az104-vm-monitoring-01 `
  --name nsg-monitoring-01 `
  --location eastus `
  --output table
Verify
az network nsg show `
  --resource-group rg-az104-vm-monitoring-01 `
  --name nsg-monitoring-01 `
  --output table
4. SSH Rule
Create
az network nsg rule create `
  --resource-group rg-az104-vm-monitoring-01 `
  --nsg-name nsg-monitoring-01 `
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
Verify
az network nsg rule list `
  --resource-group rg-az104-vm-monitoring-01 `
  --nsg-name nsg-monitoring-01 `
  --output table
5. Associate NSG with Subnet
az network vnet subnet update `
  --resource-group rg-az104-vm-monitoring-01 `
  --vnet-name vnet-az104-monitoring-01 `
  --name snet-monitoring-01 `
  --network-security-group nsg-monitoring-01 `
  --output table
Verify
az network vnet subnet show `
  --resource-group rg-az104-vm-monitoring-01 `
  --vnet-name vnet-az104-monitoring-01 `
  --name snet-monitoring-01 `
  --output json
6. Public IP
Create
az network public-ip create `
  --resource-group rg-az104-vm-monitoring-01 `
  --name pip-vm-monitoring-01 `
  --location eastus `
  --sku Standard `
  --allocation-method Static `
  --output table
Verify
az network public-ip show `
  --resource-group rg-az104-vm-monitoring-01 `
  --name pip-vm-monitoring-01 `
  --output table
7. Network Interface
Create
az network nic create `
  --resource-group rg-az104-vm-monitoring-01 `
  --name nic-vm-monitoring-01 `
  --vnet-name vnet-az104-monitoring-01 `
  --subnet snet-monitoring-01 `
  --public-ip-address pip-vm-monitoring-01 `
  --output table
Verify IP Configuration
az network nic ip-config list `
  --resource-group rg-az104-vm-monitoring-01 `
  --nic-name nic-vm-monitoring-01 `
  --output table
8. Load SSH Public Key

The public key was reloaded because the lab was run from a new PowerShell session.

$sshPublicKey = (Get-Content "$env:USERPROFILE\Downloads\vm-az104-linux-01_key.pub" -Raw).Trim()
Verify
$sshPublicKey.Length

Observed:

552
9. VM Creation

The first VM creation attempt used an empty boot-diagnostics-storage argument:

--boot-diagnostics-storage ""

That failed because the CLI expected a value.

The working command removed that argument:

az vm create `
  --resource-group rg-az104-vm-monitoring-01 `
  --name vm-az104-monitoring-01 `
  --nics nic-vm-monitoring-01 `
  --image Ubuntu2404 `
  --size Standard_D2ads_v7 `
  --admin-username azureuser `
  --ssh-key-values $sshPublicKey `
  --output table
10. VM Verification
VM State
az vm show `
  --resource-group rg-az104-vm-monitoring-01 `
  --name vm-az104-monitoring-01 `
  --show-details `
  --output table
IP Addresses
az vm list-ip-addresses `
  --resource-group rg-az104-vm-monitoring-01 `
  --name vm-az104-monitoring-01 `
  --output table

Observed:

Public IP:
20.127.48.107


Private IP:
10.30.1.4
11. VM Resource ID
az vm show `
  --resource-group rg-az104-vm-monitoring-01 `
  --name vm-az104-monitoring-01 `
  --query id `
  --output tsv

This resource ID was used as the scope for the Azure Monitor metric alert.

12. CPU Baseline
az monitor metrics list `
  --resource "/subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec/resourceGroups/rg-az104-vm-monitoring-01/providers/Microsoft.Compute/virtualMachines/vm-az104-monitoring-01" `
  --metric "Percentage CPU" `
  --interval PT1M `
  --aggregation Average `
  --output table

Observed quiet-period values included:

4.815
0.08
0.065
0.05
0.055
13. Network In Baseline
az monitor metrics list `
  --resource "/subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec/resourceGroups/rg-az104-vm-monitoring-01/providers/Microsoft.Compute/virtualMachines/vm-az104-monitoring-01" `
  --metric "Network In Total" `
  --interval PT1M `
  --aggregation Average `
  --output table

Observed examples:

1,855,117
44,167
44,922
43,558
14. Network Out Baseline
az monitor metrics list `
  --resource "/subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec/resourceGroups/rg-az104-vm-monitoring-01/providers/Microsoft.Compute/virtualMachines/vm-az104-monitoring-01" `
  --metric "Network Out Total" `
  --interval PT1M `
  --aggregation Average `
  --output table

Observed examples:

200,602
85,734
58,397
53,263
58,802
144,121
15. Disk Read Baseline
az monitor metrics list `
  --resource "/subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec/resourceGroups/rg-az104-vm-monitoring-01/providers/Microsoft.Compute/virtualMachines/vm-az104-monitoring-01" `
  --metric "Disk Read Bytes" `
  --interval PT1M `
  --aggregation Average `
  --output table

Observed examples:

0
127469778.95
69631.62
802842.7
50504961.94
16. Disk Write Baseline
az monitor metrics list `
  --resource "/subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec/resourceGroups/rg-az104-vm-monitoring-01/providers/Microsoft.Compute/virtualMachines/vm-az104-monitoring-01" `
  --metric "Disk Write Bytes" `
  --interval PT1M `
  --aggregation Average `
  --output table

Observed examples:

0
915371918.19
413734.69
311293.69
102376.8
618492.64
200710.67
27228690.86
17. VM Health Baseline
az vm get-instance-view `
  --resource-group rg-az104-vm-monitoring-01 `
  --name vm-az104-monitoring-01 `
  --query "instanceView.statuses[].{Code:code,Status:displayStatus,Level:level}" `
  --output table

Healthy state:

ProvisioningState/succeeded
PowerState/running
18. Create CPU Alert
az monitor metrics alert create `
  --resource-group rg-az104-vm-monitoring-01 `
  --name alert-vm-high-cpu-01 `
  --description "Alert when VM CPU remains above 80 percent for 5 minutes" `
  --scopes "/subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec/resourceGroups/rg-az104-vm-monitoring-01/providers/Microsoft.Compute/virtualMachines/vm-az104-monitoring-01" `
  --condition "avg Percentage CPU > 80" `
  --window-size 5m `
  --evaluation-frequency 1m `
  --severity 2 `
  --output table
19. Verify CPU Alert
az monitor metrics alert show `
  --resource-group rg-az104-vm-monitoring-01 `
  --name alert-vm-high-cpu-01 `
  --output table

Configuration:

Enabled:
True


Evaluation Frequency:
PT1M


Window Size:
PT5M


Severity:
2
20. Inspect Alert Definition
az monitor metrics alert show `
  --resource-group rg-az104-vm-monitoring-01 `
  --name alert-vm-high-cpu-01 `
  --output json

Important configuration:

Metric:
Percentage CPU


Operator:
GreaterThan


Threshold:
80


Time Aggregation:
Average


Window:
5 minutes


Evaluation:
1 minute

The command shows the alert definition; the Azure Portal was used to verify the actual alert instance state.

21. Generate Controlled CPU Load
az vm run-command invoke `
  --resource-group rg-az104-vm-monitoring-01 `
  --name vm-az104-monitoring-01 `
  --command-id RunShellScript `
  --scripts "for i in 1 2; do yes > /dev/null & done" `
  --output table

This created two CPU-consuming yes processes.

22. Verify CPU Workload Processes
az vm run-command invoke `
  --resource-group rg-az104-vm-monitoring-01 `
  --name vm-az104-monitoring-01 `
  --command-id RunShellScript `
  --scripts "ps -eo pid,comm,args | grep '[y]es'" `
  --output json

Observed:

1552 yes yes
1553 yes yes

This proved the artificial workload was running.

23. Monitor CPU During Incident
az monitor metrics list `
  --resource "/subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec/resourceGroups/rg-az104-vm-monitoring-01/providers/Microsoft.Compute/virtualMachines/vm-az104-monitoring-01" `
  --metric "Percentage CPU" `
  --interval PT1M `
  --aggregation Average `
  --output table

Observed transition:

~0.05%
   ↓
49.74%
   ↓
99.485%
   ↓
~99.5% sustained
24. Alert Verification

The Azure Portal was used to inspect:

Monitor → Alerts → Alert instances

The lab showed:

alert-vm-high-cpu-01
Severity: 2 - Warning
Affected Resource:
vm-az104-monitoring-01


Condition:
Fired

The Portal evidence was used because the CLI rule display shows the rule definition rather than the live alert instance state.

25. Investigate CPU Workload
az vm run-command invoke `
  --resource-group rg-az104-vm-monitoring-01 `
  --name vm-az104-monitoring-01 `
  --command-id RunShellScript `
  --scripts "ps -eo pid,comm,args | grep '[y]es'" `
  --output json

This confirmed the yes processes were the source of the intentional CPU load.

26. Remediate Runaway CPU Workload
az vm run-command invoke `
  --resource-group rg-az104-vm-monitoring-01 `
  --name vm-az104-monitoring-01 `
  --command-id RunShellScript `
  --scripts "pkill yes || true" `
  --output table
27. Verify CPU Recovery
az monitor metrics list `
  --resource "/subscriptions/39896053-eeca-4bfb-99ca-cf10b0494eec/resourceGroups/rg-az104-vm-monitoring-01/providers/Microsoft.Compute/virtualMachines/vm-az104-monitoring-01" `
  --metric "Percentage CPU" `
  --interval PT1M `
  --aggregation Average `
  --output table

Recovery observed:

17:45 → 99.475%
17:46 → 9.295%
17:47 → 0.245%

This demonstrated recovery toward the original baseline.

28. Activity Log
az monitor activity-log list `
  --resource-group rg-az104-vm-monitoring-01 `
  --max-events 20 `
  --output table

The Activity Log was used to inspect Azure resource management-plane events.

29. Final VM Health Verification
az vm get-instance-view `
  --resource-group rg-az104-vm-monitoring-01 `
  --name vm-az104-monitoring-01 `
  --query "instanceView.statuses[].{Code:code,Status:displayStatus,Level:level}" `
  --output table

Final state:

ProvisioningState/succeeded
PowerState/running
30. Cleanup

Delete the entire temporary resource group:

az group delete `
  --name rg-az104-vm-monitoring-01 `
  --yes
Verify Deletion
az group exists --name rg-az104-vm-monitoring-01

Final result:

false

This confirmed cleanup of the temporary monitoring environment.

31. Troubleshooting Patterns Learned
Low CPU but Slow Application

Investigate:

Network
Disk
Application
Database
Latency
High CPU

Investigate:

Processes
Threads
Workload
Runaway jobs
Application behavior
High Network

Investigate:

Traffic source
Traffic destination
Unexpected transfers
Application workload
High Disk Activity

Investigate:

Read/write workload
Storage latency
IOPS
Application behavior
VM Unhealthy

Investigate:

VM state
Platform events
Activity Log
Guest OS
Application service