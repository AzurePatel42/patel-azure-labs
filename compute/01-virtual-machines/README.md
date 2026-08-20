# Azure Compute Lab 01 — Virtual Machines

## Overview

This lab demonstrates the complete lifecycle of an Azure Linux Virtual Machine using the Azure Portal and Azure CLI.

The VM was created as a temporary AZ-104 learning environment, used for administration and networking practice, monitored, and then completely removed.

---

## Objectives

- Understand Azure VM sizing
- Select an appropriate VM family and SKU
- Configure Linux VM authentication
- Configure managed disks
- Understand VNet, subnet, NIC, IP, and NSG relationships
- Connect to a Linux VM using SSH
- Perform basic Linux verification
- Understand VM monitoring
- Understand quota vs. regional capacity
- Practice VM lifecycle management
- Apply cost-optimization principles
- Properly clean up Azure resources

---

## Environment

| Component | Configuration |
|---|---|
| Subscription | `patel-platform-service-template` |
| Resource Group | `rg-az104-compute-01` |
| Region | East US |
| VM | `vm-az104-linux-01` |
| OS | Ubuntu Server 24.04 LTS |
| VM Size | `Standard D2ads_v7` |
| vCPUs | 2 |
| Memory | 8 GiB |
| Architecture | x64 |
| Security | Trusted Launch |
| Authentication | SSH public key |
| Username | `azureuser` |
| OS Disk | StandardSSD_LRS |
| VNet | `vnet-eastus-1` |
| Subnet | `snet-eastus-1` |
| Subnet CIDR | `172.16.0.0/24` |
| Inbound Port | SSH / TCP 22 |
| Accelerated Networking | Enabled |
| Auto-shutdown | 19:00 Eastern |
| Boot Diagnostics | Enabled |

---

## Architecture

```text
                         Internet
                            |
                         SSH : 22
                            |
                       Public IP
                            |
                           NIC
                            |
                          NSG
                            |
                       Private IP
                       172.16.0.4
                            |
                         Subnet
                            |
                    snet-eastus-1
                            |
                          VNet
                            |
                    vnet-eastus-1
                            |
                    Ubuntu Linux VM
                 Standard D2ads_v7
                  2 vCPU / 8 GiB




VM Sizing Decision

The VM was selected based on the workload rather than simply choosing the cheapest or largest available SKU.

The lab required:

Linux administration
SSH
Basic networking
Monitoring
Azure CLI practice
Temporary usage

A general-purpose D-series VM was therefore appropriate.

The selected SKU was:

Standard D2ads_v7
2 vCPUs
8 GiB RAM
Quota and Capacity

Regional VM quota was checked before deployment:

az vm list-usage --location eastus --output table

The subscription had available regional vCPU quota.

Important distinction:

Quota
  ↓
Subscription resource limit


Capacity
  ↓
Actual Azure availability for a specific SKU/region

Available quota does not guarantee that a specific VM SKU will have current regional capacity.

Networking

The VM used a dedicated lab VNet and subnet.

VNet
└── snet-eastus-1
    └── VM NIC
        ├── Private IP
        └── Public IP

Only SSH was required:

TCP 22

No HTTP, HTTPS, or RDP ports were opened.

Storage

The VM used:

Managed OS Disk
StandardSSD_LRS

No additional data disks were required.

The OS disk was configured to be deleted with the VM.

This was appropriate for a temporary learning environment.

Authentication

SSH public-key authentication was used.

Username:
azureuser


Key:
vm-az104-linux-01_key

The private SSH key was downloaded during deployment and used from Windows PowerShell.

Private keys must never be committed to source control or exposed publicly.

Monitoring

Boot diagnostics were enabled.

The VM was also inspected through Azure Monitor and runtime Linux information.

Monitoring provides evidence that can later be used for:

Sizing
   ↓
Deployment
   ↓
Monitoring
   ↓
Actual utilization
   ↓
Right-sizing
   ↓
Cost optimization
Cost Optimization

Azure displayed an estimated monthly cost during deployment.

The lab intentionally used:

Appropriate VM sizing
Standard SSD
No unnecessary data disks
No load balancer
No backup
No unnecessary extensions
Auto-shutdown
Complete resource cleanup

The VM was temporary and was deleted after the exercise.

VM Lifecycle
Plan
  ↓
Configure
  ↓
Deploy
  ↓
Connect
  ↓
Verify
  ↓
Monitor
  ↓
Deallocate / Stop
  ↓
Delete
  ↓
Verify Cleanup
SSH Verification

The VM was successfully accessed from Windows PowerShell using SSH.

Example:

ssh -i "C:\Users\mahes\Downloads\vm-az104-linux-01_key.pem" azureuser@<PUBLIC-IP>

Successful login confirmed:

Public connectivity
SSH port 22
NSG configuration
SSH key authentication
Ubuntu availability
VM networking
Linux Verification

The following commands were used after connecting:

hostname
cat /etc/os-release
nproc
free -h
df -h /
ip addr show eth0
uname -a
uptime

These commands verified the operating system, CPU, memory, storage, network interface, kernel, and system state.

Cleanup

After completing the lab, the resource group was deleted.

Verification:

az group exists --name rg-az104-compute-01

Result:

false

This confirmed that the temporary compute environment had been removed.

Screenshots

The lab contains evidence for:

01-vm-review-configuration.png
02-ssh-key-download.png
03-deployment-complete.png
04-vm-overview.png
05-vm-networking.png
06-vm-running-state.png
07-ssh-connection.png
08-linux-verification.png
09-vm-monitoring.png
10-cleanup-resource-group.png
Key AZ-104 Lessons
1. Size based on workload

VM sizing should be driven by CPU, memory, storage, network, and business requirements.

2. Quota is not capacity

Having vCPU quota does not guarantee availability of a particular VM SKU in a region.

3. Monitor before optimizing

Actual utilization data should guide right-sizing and cost decisions.

4. Security follows the workload

Only required network ports should be exposed.

5. Availability and scalability are different

Availability addresses resilience.

Scalability addresses increasing workload.

6. Customer requirements drive architecture

The correct Azure architecture depends on:

Workload
Performance
Security
Compliance
Availability
RTO/RPO
Scalability
Budget
7. Clean up temporary resources

Temporary labs should be deleted after completion to avoid unnecessary Azure charges.

Lab Status

COMPLETE

The Azure Compute VM lab successfully demonstrated VM sizing, deployment, networking, SSH administration, monitoring, cost awareness, lifecycle management, and complete resource cleanup.