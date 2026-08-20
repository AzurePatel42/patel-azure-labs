# Azure Compute Lab 01 — CLI Commands

## Objective

Use Azure CLI to verify the Azure subscription, resource group, regional quota, VM deployment, and final cleanup.

The CLI was used alongside the Azure Portal to reinforce the relationship between Portal operations and command-line administration.

---

# 1. Verify Azure CLI

Check the installed Azure CLI version.

```powershell
az --version

Example environment used during the lab:

azure-cli 2.86.0
Python 3.13.13
2. Sign in to Azure
az login

During login, Azure CLI displayed the available subscriptions.

The active subscription was:

patel-platform-service-template
3. List Azure Subscriptions
az account list --output table

The relevant subscription:

Name:
patel-platform-service-template


Subscription ID:
39896053-eeca-4bfb-99ca-cf10b0494eec


State:
Enabled


IsDefault:
True
4. Display Current Subscription
az account show --output table

This was used to confirm that Azure CLI was operating against the intended subscription.

5. Set the Subscription Explicitly
az account set --subscription "patel-platform-service-template"

Then verify:

az account show --output table

This is a good administrative habit when working with multiple subscriptions.

6. Create the Compute Resource Group

Create the resource group used for the VM lab.

az group create `
  --name rg-az104-compute-01 `
  --location eastus `
  --output table

Expected result:

Location    Name
----------  -------------------
eastus      rg-az104-compute-01
7. Verify the Resource Group
az group show `
  --name rg-az104-compute-01 `
  --output table

Expected:

Location    Name
----------  -------------------
eastus      rg-az104-compute-01
8. Verify the Resource Group Is Empty

Before VM deployment:

az resource list `
  --resource-group rg-az104-compute-01 `
  --output table

At the beginning of the lab, this returned no resources.

This confirmed that we were starting with a clean resource group.

9. Check Regional VM Quota

Before deploying the VM, inspect regional VM usage/quota.

az vm list-usage `
  --location eastus `
  --output table

Important quota categories observed included:

Total Regional vCPUs
Standard BS Family vCPUs
Standard D Family vCPUs
Standard DS Family vCPUs
Virtual Machines

The relevant quota state showed available capacity in the subscription.

Example:

Total Regional vCPUs
0 / 10


Standard D Family vCPUs
0 / 10


Virtual Machines
0 / 25000
Important distinction

Quota does not guarantee that a particular VM SKU is physically available in a region.

Subscription quota
        ↓
Can the subscription request the resource?
        ↓
Regional/SKU capacity
        ↓
Can Azure actually allocate the requested SKU?

This distinction was important during the lab because some smaller VM sizes were not available in the Portal.

10. VM Size Discovery

The Azure CLI version used during the lab displayed the following VM management commands:

az vm

Relevant commands included:

list-sizes [Deprecated]
list-skus
list-usage
list-vm-resize-options

The CLI showed:

list-sizes [Deprecated]

Therefore, do not rely on older commands blindly.

11. Deprecated VM Size Command Attempt

An older command was attempted:

az vm list -sizes --location eastus --output table

Azure CLI returned:

unrecognized arguments: -sizes --location eastus

The command was not valid for the installed CLI syntax.

A second attempt was made:

az vm list --sizes --location eastus --output table

This also returned:

unrecognized arguments: --sizes --location eastus

The Azure CLI help output showed:

list-sizes [Deprecated]

This was useful as a learning point:

Azure CLI commands and syntax can change over time. Use the current command reference/help output rather than assuming older syntax remains valid.

12. VM SKU Discovery Attempt

The current command was also tested:

az vm list-skus `
  --location eastus `
  --output table

This operation took a long time in the lab environment.

It was terminated.

A more specific attempt was also made:

az vm list-skus `
  --location eastus `
  --resource-type virtualMachines `
  --output table

This also took too long for the lab environment and was terminated.

The Portal was therefore used to inspect currently available VM sizes.

13. VM Size Selection

The Portal showed current available VM families including:

D-Series v7
E-Series v7
F-Series v7

The workload was a temporary general-purpose Linux administration lab.

The selected VM was:

Standard D2ads_v7

Configuration:

2 vCPUs
8 GiB RAM

Reason:

General-purpose workload
+
Small temporary lab
+
SSH administration
+
Low compute requirements
14. Verify Resource Group Before Deployment
az resource list `
  --resource-group rg-az104-compute-01 `
  --output table

The resource group was empty before deployment.

15. Verify Active Azure Subscription
az account show --output table

Confirmed:

Subscription:
patel-platform-service-template
16. VM Verification After Deployment

After the VM was deployed through the Portal, Azure CLI could be used to inspect it.

az vm show `
  --resource-group rg-az104-compute-01 `
  --name vm-az104-linux-01 `
  --show-details `
  --output table

This can be used to inspect the VM state and configuration from the CLI.

17. List Resources Created by the VM Deployment
az resource list `
  --resource-group rg-az104-compute-01 `
  --output table

This can be used to see the resources created inside the VM resource group.

Conceptually, the deployment included:

Virtual Machine
Managed OS Disk
Network Interface
Public IP
Virtual Network
Subnet
Network Security Group
18. SSH Connection

The VM was accessed from Windows PowerShell using the generated private SSH key.

Example:

ssh -i "C:\Users\mahes\Downloads\vm-az104-linux-01_key.pem" azureuser@20.25.88.47

Successful connection resulted in:

Welcome to Ubuntu 24.04.4 LTS

and:

azureuser@vm-az104-linux-01:~$

This confirmed successful SSH connectivity.

19. Linux Verification Commands

After connecting through SSH, the following commands were used for VM verification.

Hostname
hostname
Operating system
cat /etc/os-release
CPU count
nproc
Memory
free -h
Disk usage
df -h /
Network interface
ip addr show eth0
Kernel
uname -a
System load and uptime
uptime

These commands verify that the VM is functioning as expected after deployment.

20. Resource Group Resource Listing

After deployment, resources can be inspected with:

az resource list `
  --resource-group rg-az104-compute-01 `
  --output table

This is useful for identifying resources that may continue generating charges if they are not removed.

21. Stop / Deallocate VM

Azure CLI supports VM lifecycle operations.

To deallocate:

az vm deallocate `
  --resource-group rg-az104-compute-01 `
  --name vm-az104-linux-01

Deallocation releases VM compute resources.

Important:

Deallocating the VM does not necessarily remove all associated resources or all possible charges.

For temporary labs, complete resource deletion is preferred after the exercise.

22. Delete the VM

If deleting only the VM:

az vm delete `
  --resource-group rg-az104-compute-01 `
  --name vm-az104-linux-01 `
  --yes

However, this does not necessarily remove all associated resources.

For this lab, the resource group was ultimately deleted instead.

23. Delete the Entire Resource Group

Because this was a temporary learning environment:

az group delete `
  --name rg-az104-compute-01 `
  --yes

This removes the resource group and its resources.

This is the preferred cleanup approach for this lab because it reduces the risk of leaving orphaned resources.

24. Verify Resource Group Deletion

After deletion:

az group exists `
  --name rg-az104-compute-01

Final result:

false

This confirmed that the resource group no longer existed.

25. Complete CLI Lifecycle

The CLI workflow for this lab can be summarized as:

az login
    ↓
az account show
    ↓
az account set
    ↓
az group create
    ↓
az group show
    ↓
az vm list-usage
    ↓
Portal VM deployment
    ↓
az resource list
    ↓
SSH verification
    ↓
az vm deallocate
    ↓
az group delete
    ↓
az group exists
26. Important AZ-104 CLI Lessons
Subscription Context

Always verify the active subscription before creating resources.

az account show --output table
Resource Groups

Use resource groups to organize and manage related resources.

az group create
az group show
az group delete
Quota

Check quota before deployment.

az vm list-usage --location eastus --output table
Capacity

Quota availability does not guarantee SKU availability.

VM Lifecycle

Know the difference between:

Stop
Deallocate
Delete
Cleanup

Always verify cleanup.

az group exists --name rg-az104-compute-01

Expected:

false
Lab Status

Azure Compute Lab 01 — Virtual Machines: COMPLETE

The lab successfully demonstrated:

Azure CLI authentication
Subscription selection
Resource group management
Regional quota inspection
VM size discovery
VM deployment through the Portal
CLI resource verification
SSH administration
Linux verification
VM lifecycle management
Resource group cleanup
Cleanup verification

