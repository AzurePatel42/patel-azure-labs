# Azure Compute Lab 01 — Portal Steps

## Objective

Deploy, configure, connect to, verify, monitor, and clean up an Azure Linux Virtual Machine using the Azure Portal.

---

# 1. Open Azure Virtual Machines

1. Sign in to the Azure Portal.
2. Search for **Virtual machines**.
3. Select **Create → Azure virtual machine**.

---

# 2. Basics

Configure the VM with the following settings.

### Project details

**Subscription**

```text
patel-platform-service-template


Resource group

rg-az104-compute-01
Instance details

Virtual machine name

vm-az104-linux-01

Region

East US

Availability

No infrastructure redundancy required

Security type

Trusted launch virtual machines

Enable:

Secure Boot: Yes
vTPM: Yes
Integrity monitoring: No
Image
Ubuntu Server 24.04 LTS
Architecture
x64
VM size

Selected:

Standard D2ads_v7

Configuration:

2 vCPUs
8 GiB RAM

The D-series was selected because the workload was a general-purpose administration lab.

3. Administrator Account

Select:

Authentication type:
SSH public key

Username:

azureuser

SSH key source:

Generate new key pair

SSH key type:

RSA

Key pair name:

vm-az104-linux-01_key

Inbound port:

SSH (22)

Only SSH was required for this lab.

4. SSH Key Download

After selecting the configuration and creating the VM, Azure generated an SSH key pair.

Download and securely store the private key.

Example local path:

C:\Users\mahes\Downloads\vm-az104-linux-01_key.pem

Do not:

Upload the private key to GitHub
Commit it to the repository
Share it publicly
5. Disks

Configure the OS disk.

OS disk
OS disk size:
Image default
OS disk type:
StandardSSD_LRS
Use managed disks:
Yes
Delete OS disk with VM:
Yes
Data disks

No additional data disks were required.

Ephemeral OS disk
None
Encryption at host

Left disabled because it was not required for this lab.

Azure managed disk encryption at rest remains part of the platform's disk protection.

6. Networking

Create a new virtual network for the lab.

Virtual network
vnet-eastus-1
Subnet
snet-eastus-1

Address space used by the subnet:

172.16.0.0/24
Public IP

Create a new public IP:

vm-az104-linux-01-ip

The public IP was required to connect to the VM from the local computer using SSH.

7. Network Security

Configure the VM for SSH access.

Required inbound port:

TCP 22

Do not open unnecessary ports.

The lab did not require:

HTTP 80
HTTPS 443
RDP 3389

Azure displayed a warning that SSH was exposed to the internet.

This was accepted because the VM was a temporary learning environment.

For production systems, SSH access should be restricted to appropriate trusted sources.

8. Network Interface

Azure created a network interface for the VM.

The NIC provides connectivity between the VM and the Azure network.

Conceptually:

VM
 ↓
NIC
 ↓
Subnet
 ↓
VNet

Accelerated networking was enabled because it was required/supported by the selected VM size.

9. Load Balancing

No load balancing solution was configured.

Reason:

One VM
+
Temporary lab
=
No load balancer required
10. Management
Managed Identity
System assigned managed identity:
Off

A managed identity was not required for this introductory VM.

Microsoft Entra ID Login
Off

The lab used SSH public-key authentication instead.

Backup
Off

Backup was not required for the temporary lab.

Site Recovery
Off
Periodic assessment
Off
Hotpatch
Off
Auto-shutdown
On

Configuration:

Time:
19:00


Time zone:
Eastern Standard Time


Notification:
On

Auto-shutdown provides additional protection against accidentally leaving the temporary VM running.

11. Monitoring
Recommended alerts
Off
Boot diagnostics
On

Boot diagnostics were enabled to support VM startup troubleshooting.

OS guest diagnostics
Off
Application health monitoring
Off

The lab did not deploy an application that required application health monitoring.

12. Advanced Configuration

No extensions were configured.

Extensions:
None

No VM applications were configured.

VM Applications:
None

No cloud-init script was required.

Cloud-init:
No

No capacity reservation was configured.

Capacity Reservation:
None

The selected VM used the NVMe disk controller configuration required by the VM size.

13. Review + Create

Before deployment, review the configuration.

Verify:

VM name:
vm-az104-linux-01


Region:
East US


Image:
Ubuntu Server 24.04 LTS


Size:
Standard D2ads_v7


Authentication:
SSH public key


Username:
azureuser


Inbound:
SSH 22 only


OS disk:
StandardSSD_LRS


VNet:
vnet-eastus-1


Subnet:
snet-eastus-1


Public IP:
vm-az104-linux-01-ip


Auto-shutdown:
19:00 Eastern Standard Time


Boot diagnostics:
Enabled

Review the estimated monthly cost.

The Portal showed an estimated monthly cost of approximately:

$89.27/month

This was a monthly estimate. The VM was intended for temporary lab use.

14. Deployment

Select:

Create

Azure begins deploying the VM and its associated resources.

Wait for:

Your deployment is complete
15. VM Overview

Open:

vm-az104-linux-01

Verify:

Status:
Running

Verify the operating system:

Linux / Ubuntu 24.04

Verify the VM size:

Standard D2ads v7
2 vCPUs
8 GiB RAM

Verify networking information.

Example:

Public IP:
20.25.88.47
Private IP:
172.16.0.4
VNet:
vnet-eastus-1
Subnet:
snet-eastus-1
16. Connect to the VM

From the VM Overview page:

Select Connect.
Choose the SSH connection option.
Use the generated private SSH key.
Connect using the azureuser account.

Example PowerShell command:

ssh -i "C:\Users\mahes\Downloads\vm-az104-linux-01_key.pem" azureuser@20.25.88.47

On first connection, verify the host fingerprint and enter:

yes

A successful connection displays an Ubuntu shell:

azureuser@vm-az104-linux-01:~$
17. Linux Verification

After connecting through SSH, verify the operating system.

hostname

Verify OS information:

cat /etc/os-release

Verify CPU:

nproc

Verify memory:

free -h

Verify root disk:

df -h /

Verify network interface:

ip addr show eth0

Verify kernel:

uname -a

Verify system uptime/load:

uptime

These commands verify that the deployed Azure VM is functioning correctly.

18. Monitoring

Open the VM's Monitor section.

Review available VM metrics.

Important metrics include:

CPU utilization
Disk activity
Network activity
Availability/health information where available

The purpose is to connect actual VM behavior with the original sizing decision.

Conceptually:

Initial sizing
      ↓
Deploy
      ↓
Monitor
      ↓
Collect actual usage
      ↓
Compare with requirements
      ↓
Right-size if necessary
19. Stop / Deallocate

When the lab work is complete, stop/deallocate the VM.

From the VM Overview:

Stop

Confirm the operation.

The VM should move to a deallocated state.

Deallocation releases compute resources so compute charges no longer continue for the VM, although associated resources may still incur charges.

20. Resource Cleanup

Because this was a temporary learning environment, delete the entire resource group.

Navigate to:

rg-az104-compute-01

Select:

Delete resource group

Enter:

rg-az104-compute-01

to confirm deletion.

This removes the lab environment and associated resources.

21. Verify Cleanup with Azure CLI

Open Windows PowerShell.

Run:

az group exists --name rg-az104-compute-01

Expected result:

false

This confirms that the resource group no longer exists.

22. Screenshot Evidence

Screenshots captured for this lab:

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

The screenshots provide evidence of:

Configuration
SSH key generation
Deployment
VM status
Networking
Running state
SSH connectivity
Linux verification
Monitoring
Cleanup
23. Lab Completion

The VM lifecycle was successfully completed:

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
Stop / Deallocate
    ↓
Delete
    ↓
Verify cleanup

Final Azure CLI verification:

az group exists --name rg-az104-compute-01

Result:

false

The temporary Azure Compute environment was successfully removed.