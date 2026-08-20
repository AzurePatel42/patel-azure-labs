# Azure Compute Lab 01 — Virtual Machines

## Objective

Learn the complete Azure Virtual Machine lifecycle using the Azure Portal and Azure CLI.

This lab focuses on:

- VM sizing
- Compute configuration
- Storage configuration
- Networking
- SSH authentication
- Monitoring
- Cost awareness
- VM administration
- Resource cleanup

The VM was created as a temporary learning environment and deleted after the lab was completed.

---

# 1. Use Case

The VM was created for AZ-104 hands-on learning.

Requirements:

- Linux operating system
- SSH access
- General-purpose workload
- Small temporary lab
- Low-cost configuration
- Ability to inspect networking and monitoring
- Ability to delete the entire environment after completion

Because this is a lab and not a production workload, we intentionally avoided unnecessary services and infrastructure.

---

# 2. VM Sizing

The VM size was selected based on the workload rather than simply choosing the cheapest or largest available VM.

### Selected VM

**Standard D2ads_v7**

- 2 vCPUs
- 8 GiB RAM
- General-purpose D-series
- x64 architecture

### Sizing principle

VM sizing should depend on the workload.

```text
Use case
    ↓
CPU / memory requirements
    ↓
VM family
    ↓
VM size



For this lab, a general-purpose D-series VM was appropriate.

E-series was unnecessary because the workload did not require high memory capacity.

F-series was unnecessary because the workload was not compute intensive.

3. Quota vs Capacity

Before deployment, Azure CLI was used to inspect regional VM usage.

Important distinction:

Quota
  ↓
How many resources/vCPUs the subscription is allowed to use


Capacity
  ↓
Whether Azure currently has physical capacity
for the selected VM SKU in the selected region

Having available quota does not guarantee that a particular VM SKU will be available at deployment time.

This was important during the lab because Azure VM size availability varied by region.

4. Operating System

Selected image:

Ubuntu Server 24.04 LTS

The VM was deployed as a Linux VM and administered through SSH.

Verification after login confirmed:

Ubuntu 24.04.4 LTS
Linux kernel
x86_64 architecture
5. Authentication

Authentication method:

SSH public key

Username:

azureuser

SSH key:

vm-az104-linux-01_key

Key format:

RSA

SSH was used instead of password authentication.

The private key was downloaded during VM creation and used from Windows PowerShell.

Example:

ssh -i "C:\Users\mahes\Downloads\vm-az104-linux-01_key.pem" azureuser@<PUBLIC-IP>

The private key must never be committed to GitHub or stored in a public location.

6. VM Security

The VM used:

Trusted Launch

Enabled:

Secure Boot
vTPM

Integrity monitoring was not enabled for this lab.

Only the required inbound port was opened:

TCP 22 — SSH

No HTTP, HTTPS, or RDP ports were required.

Security principle:

Only expose the network ports required by the workload.

For a production environment, SSH access should normally be restricted further rather than broadly exposed to the public internet.

7. Storage Configuration

The VM used an Azure managed OS disk.

Configuration:

OS Disk:
StandardSSD_LRS


OS Disk:
Image default size


Delete OS disk with VM:
Enabled


Ephemeral OS disk:
None


Data disks:
None
Why Standard SSD?

The workload was a temporary administration lab.

It did not require:

Ultra Disk
high-performance database storage
large data disks
specialized storage performance

Standard SSD provided an appropriate balance between performance and cost.

8. VM Temporary Disk

Azure VMs can include a temporary disk for short-term storage.

Temporary storage should not be treated as permanent application data.

Conceptually:

OS Disk
    ↓
Persistent managed storage


Temporary Disk
    ↓
Short-term / temporary storage


Data Disk
    ↓
Optional persistent application data
9. Networking

The VM was deployed into a new virtual network.

VNet
vnet-eastus-1
Subnet
snet-eastus-1
172.16.0.0/24
Private IP
172.16.0.4
Public IP
vm-az104-linux-01-ip

The VM's public IP was used for SSH access from the local computer.

The basic network path was:

Windows PC
    ↓
Internet
    ↓
Public IP
    ↓
NIC / NSG
    ↓
Private IP
    ↓
Subnet
    ↓
VNet
    ↓
Ubuntu VM
10. Network Interface

The VM uses a Network Interface Card (NIC) to communicate with Azure networking resources.

Conceptually:

VM
 ↓
NIC
 ↓
Subnet
 ↓
VNet

The NIC provided connectivity for the VM and was associated with the VM's private/public networking configuration.

Accelerated networking was enabled because the selected VM size required/supports it.

11. Network Security

SSH access was configured through port:

TCP 22

The Azure portal warned that SSH was exposed to the internet.

This was acceptable for the temporary learning lab.

Production systems should use more restrictive network access where possible.

12. Public IP

A public IP was required for direct SSH access from the local Windows computer.

The VM received a public IP during deployment.

The public IP was used only for the temporary lab.

The configuration was set to delete the public IP and NIC when the VM was deleted.

13. Auto-Shutdown

Auto-shutdown was enabled.

Configuration:

Enabled
Time: 19:00
Time zone: Eastern Standard Time
Notification: Enabled

Auto-shutdown provides an additional safeguard against accidentally leaving a temporary lab VM running.

This is an example of cost-control automation.

14. Monitoring

Boot diagnostics were enabled.

Other monitoring features were intentionally kept minimal for this introductory VM lab.

Configuration:

Boot diagnostics:
Enabled


Recommended alerts:
Disabled


OS guest diagnostics:
Disabled


Application health monitoring:
Disabled

Monitoring should be selected based on the workload and operational requirements.

Production workloads may require much more extensive monitoring, logging, alerting, and application health monitoring.

15. Monitoring and Sizing

Sizing and monitoring are connected.

Initial sizing is an educated decision:

Requirements
    ↓
Initial VM size

Monitoring provides actual workload data:

CPU
Memory
Disk
Network
Application behavior

That data can then be used to determine whether the VM is:

undersized
appropriately sized
oversized

The optimization cycle is:

Size
  ↓
Deploy
  ↓
Monitor
  ↓
Collect data
  ↓
Compare actual usage
  ↓
Optimize
  ↓
Monitor again

Cost optimization should be based on evidence rather than assumptions.

16. Cost Awareness

Azure showed an estimated monthly cost during VM creation.

The estimate included multiple resource categories:

Compute
+
Disk
+
Networking
+
Other applicable resources

The VM compute cost was the largest component of the estimate.

The VM was only intended for temporary lab use.

Therefore, leaving it running unnecessarily would create avoidable cost.

Cost-management practices used in this lab included:

Selecting an appropriate VM size
Using Standard SSD instead of higher-performance storage
Avoiding unnecessary data disks
Avoiding unnecessary services
Enabling auto-shutdown
Deleting the environment after the lab
17. Availability and Scalability

This VM was intentionally deployed as a simple single-VM lab.

No availability zone, availability set, scale set, or load balancer was required.

Availability

Availability addresses:

Can the application continue operating when something fails?

Scalability

Scalability addresses:

Can the system handle increasing workload?

These are different requirements.

A production application may require:

Multiple VM instances
+
Load balancing
+
Availability Zones
+
Monitoring

The architecture should depend on customer requirements and business needs.

18. Backup and Disaster Recovery

Backup and disaster recovery were not enabled for this temporary lab.

The distinction is important:

Backup

Protects the ability to recover data.

Availability

Helps keep the application/service operating during failures.

Disaster Recovery

Provides a strategy for recovering from larger failures or loss of an environment.

Architecture should be driven by business requirements such as:

RTO

Recovery Time Objective:

How quickly must the service be restored?

RPO

Recovery Point Objective:

How much data loss is acceptable?

These requirements influence architecture and cost.

19. Customer Requirements

Azure architecture should not be designed by choosing services first.

Start with customer requirements.

Important questions include:

How many users?
What workload?
CPU requirements?
Memory requirements?
How critical is the application?
How much downtime is acceptable?
What are the RTO/RPO requirements?
What are the security requirements?
What are the compliance requirements?
How frequently is data accessed?
How long must data be retained?
What is the budget?
What level of scalability is required?

The correct architecture depends on the use case.

20. Storage Lifecycle and Cost Optimization

Storage lifecycle management should also be based on customer requirements.

Important considerations include:

Data retention
Compliance requirements
Access frequency
Recovery requirements
Storage cost
Retrieval cost
Data transfer considerations

The cheapest storage tier is not always the cheapest overall solution.

Conceptually:

Frequently accessed
        ↓
Hot


Less frequently accessed
        ↓
Cool


Rarely accessed
        ↓
Archive


Retention period completed
        ↓
Delete

Lifecycle policies should respect business and compliance requirements.

Storage cost must be considered together with retrieval and operational requirements.

21. VM Administration

The VM was successfully accessed through SSH.

Connection:

Windows PowerShell
      ↓
SSH
      ↓
Public IP
      ↓
Azure networking
      ↓
Ubuntu VM

The successful SSH session confirmed that:

The VM was running
The public IP was reachable
SSH port 22 was accessible
The SSH key authentication worked
The Ubuntu operating system was operational
22. Linux Verification

After connecting, the VM displayed:

Ubuntu 24.04.4 LTS

The login banner also provided useful system information, including:

System load
Disk usage
Memory usage
Process count
Private IP address
Kernel information

This demonstrated the relationship between deployment and actual runtime observations.

23. VM Lifecycle

The complete lifecycle practiced in this lab was:

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
Verify cleanup

The lab environment was temporary.

The resource group was ultimately deleted.

Final Azure CLI verification:

az group exists --name rg-az104-compute-01

Result:

false

This confirmed that the resource group no longer existed.

24. Final Architecture

The completed temporary VM environment consisted conceptually of:

rg-az104-compute-01
│
├── Virtual Machine
│   └── vm-az104-linux-01
│
├── Managed OS Disk
│
├── Network Interface
│
├── Public IP
│
├── Network Security Group
│
├── Virtual Network
│   └── Subnet
│
└── Supporting Azure resources

The entire resource group was deleted after completing the lab.

25. Key Lessons
Lesson 1 — Size for the workload

Do not automatically choose the largest VM or the cheapest VM.

Choose based on requirements.

Lesson 2 — Quota is not capacity

Having available vCPU quota does not guarantee that a specific SKU is currently available in a region.

Lesson 3 — Monitor before optimizing

Actual usage data is needed to make better sizing and cost decisions.

Lesson 4 — Cost is more than compute

Consider:

Compute
+
Storage
+
Networking
+
Data transfer
+
Operations
Lesson 5 — Security should follow the workload

Only expose required ports.

Lesson 6 — Availability and scalability are different

Availability addresses resilience.

Scalability addresses workload growth.

Lesson 7 — Backup and disaster recovery are different

Backup protects recoverability of data.

Disaster recovery addresses recovery of services/environments.

Lesson 8 — Customer requirements drive architecture

There is no universal "best" Azure architecture.

The correct solution depends on:

Business requirements
+
Technical requirements
+
Security
+
Compliance
+
Performance
+
Availability
+
Budget
Lesson 9 — Temporary labs need cleanup

Always verify that temporary resources are removed.

Final verification:

az group exists --name rg-az104-compute-01

Expected:

false
Lab Status

Status: COMPLETE

VM deployment, administration, verification, monitoring, and cleanup were successfully completed.