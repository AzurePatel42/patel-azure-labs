# Compute Module 06 — Azure Container Instances

## Objective

Build, inspect, operate, troubleshoot, and clean up an Azure Container Instance through the Azure Portal.

This lab covers:

- Azure Container Instances
- Container groups
- Container images
- Linux containers
- CPU and memory allocation
- Public networking
- DNS naming
- Port mapping
- Environment variables
- Restart policies
- Container logs
- Container execution
- Stop / Start / Restart
- Application verification
- Resource cleanup

---

# 1. Resource Group

Navigate to:

**Azure Portal → Resource groups**

Create:

```text
rg-az104-aci-01


Region:

East US

Verify that the resource group is created successfully.

2. Azure Container Instances

Navigate to:

Create a resource → Containers → Container Instances

Configure the basic container settings.

Container name:

aci-az104-01

Region:

East US

Image source:

Other registry

Container image:

mcr.microsoft.com/azuredocs/aci-helloworld

Image type:

Public

Operating system:

Linux
3. Container Resources

Configure:

CPU:
1 core


Memory:
1.5 GiB

The lab intentionally used a small resource allocation.

Conceptually:

Container Group
      |
      +-- CPU: 1 core
      |
      +-- Memory: 1.5 GiB
4. Networking

Configure the container to expose:

Port:
80

Protocol:

TCP

For the lab, use:

Public IP

The objective is to make the sample HTTP application directly reachable from the Internet.

5. DNS Name Label

Configure a globally unique DNS name label.

Example used by the lab:

aci-az104-01-mahes

The resulting FQDN was:

aci-az104-01-mahes.eastus.azurecontainer.io

Azure automatically provides the DNS name through the ACI public endpoint.

6. Restart Policy

For the primary container use:

Always

This is appropriate for a continuously running service.

The available conceptual choices are:

Always
OnFailure
Never

The lab also created a temporary second container using:

Never

to demonstrate the difference.

7. Advanced / Runtime Configuration

Environment variables can be supplied as part of the container configuration.

The lab used a separate test container with:

APP_ENV=lab
APP_VERSION=1.0

This demonstrated:

Container Image
      +
Runtime Configuration
      ↓
Container Instance

The primary application container itself did not require environment variables for the lab.

8. Review and Create

Before deployment, review:

Container name
Image
OS type
CPU
Memory
Port
Networking
DNS name
Restart policy

Then choose:

Create

9. Verify Container State

Open:

Container Instances → aci-az104-01

On the Overview page verify:

State:
Running


OS:
Linux


CPU:
1 core


Memory:
1.5 GiB
10. Verify Networking

Open:

Container Instance → Networking

Verify:

Public IP
Port 80
FQDN

The lab received:

Public IP:
20.75.220.55

FQDN:

aci-az104-01-mahes.eastus.azurecontainer.io
11. Verify the Application

Open the FQDN in a browser:

http://aci-az104-01-mahes.eastus.azurecontainer.io

Expected result:

Welcome to Azure Container Instances!

The CLI test also returned:

HTTP 200 OK

This proves:

Internet
   ↓
Public Endpoint
   ↓
ACI
   ↓
Container
   ↓
HTTP 80
   ↓
Application
12. Container Logs

Navigate to:

Container Instance → Containers → Logs

Review the application output.

The lab observed:

listening on port 80

and HTTP access logs similar to:

GET / HTTP/1.1 200 1696

This provides application-level evidence that traffic reached the container.

13. Application Inspection

The sample image used by the lab contains a Node.js / Express application.

The container filesystem included:

index.js
index.html
package.json
package-lock.json
node_modules/

The application listens on:

process.env.PORT || 80

This demonstrates the relationship between application runtime configuration and the container environment.

14. Container Exec

ACI supports executing commands inside a running container.

From the Azure Portal, use the container's available execution/console capability when present.

The lab used Azure CLI for this operation:

az container exec

Inside the container, the working directory was:

/usr/src/app

The container contained the application and its dependencies.

15. Lightweight Container Environment

The container did not provide every standard Linux utility normally available in a full VM.

For example, the lab observed that:

hostname
ps

were not available.

This demonstrates:

VM
→ full OS environment


Container
→ application + runtime + dependencies
16. Environment Variables

A temporary second container was created to demonstrate runtime variables.

Container:

aci-az104-env-01

Variables:

APP_ENV=lab
APP_VERSION=1.0

The Portal can be used to inspect the configured runtime environment variables.

This illustrates why application configuration can be separated from the container image.

17. Restart Policy

For the primary service:

Restart policy:
Always

A separate test container used:

Restart policy:
Never

Conceptually:

Always
   ↓
Service-oriented workload


Never
   ↓
One-shot / controlled workload
18. Restart Container Group

The lab tested the container lifecycle by restarting the container group.

Conceptually:

Running
   ↓
Restart
   ↓
Running

After the restart, the application was verified again through the HTTP endpoint.

19. Stop Container

From the Azure Portal, open:

Container Instance → Overview

Use the available lifecycle operation to stop the container group.

Expected state:

Stopped

The lab also verified this with Azure CLI.

20. Start Container

After stopping the container, start it again.

Expected state:

Running

Then verify the application again through:

http://aci-az104-01-mahes.eastus.azurecontainer.io

Expected:

HTTP 200 OK

Lifecycle:

Running
   ↓
Stopped
   ↓
Running
   ↓
HTTP 200
21. Troubleshooting — Provider Registration

The initial ACI creation failed because:

Microsoft.ContainerInstance

was not registered for the subscription.

The CLI error was:

MissingSubscriptionRegistration

The provider was registered using Azure CLI.

Portal equivalent:

Subscriptions → Resource providers

Search:

Microsoft.ContainerInstance

Verify registration state:

Registered

This is an important Azure administration concept:

A service deployment can fail when the required resource provider is not registered.

22. Troubleshooting — Operating System Type

After provider registration, the deployment required an explicit:

Linux

or:

Windows

OS type.

The final lab configuration used:

Linux
23. Troubleshooting — Container Image

The first image reference used in the lab was not accessible:

mcr.microsoft.com/oss/nginx/nginx:1.25.5

Azure returned an:

InaccessibleImage

error.

The lab switched to the known-good Microsoft ACI image:

mcr.microsoft.com/azuredocs/aci-helloworld

The deployment then succeeded.

Lesson:

A valid-looking image reference does not guarantee that the image can be pulled by the target service.

24. Operational Inspection

The final container configuration should show approximately:

Name:
aci-az104-01


State:
Running


Image:
mcr.microsoft.com/azuredocs/aci-helloworld


CPU:
1.0


Memory:
1.5 GB


OS:
Linux


Restart:
Always


Port:
80
25. Troubleshooting Model

ACI troubleshooting followed this sequence:

Deployment
   ↓
Read Azure error
   ↓
Identify missing requirement
   ↓
Make smallest correction
   ↓
Retry
   ↓
Verify

Actual lab sequence:

Provider not registered
        ↓
Register provider
        ↓
OS type missing
        ↓
Specify Linux
        ↓
Image inaccessible
        ↓
Use known-good image
        ↓
Running container
26. VM vs ACI
VM
Operating System
Runtime
Application
System tools
SSH
OS administration
ACI
Container image
Runtime configuration
CPU
Memory
Networking
Application

ACI removes much of the infrastructure management associated with traditional VMs.

27. ACI vs VMSS

VMSS is designed for managed VM fleets:

VM Scale Set
   ↓
Multiple VM instances
   ↓
Scaling
   ↓
Availability

ACI is designed for simpler container execution:

ACI
   ↓
Container Group
   ↓
Container Workload

ACI is therefore not a direct replacement for VMSS.

28. ACI vs App Service

Conceptually:

ACI
→ Run containers


App Service
→ Run managed web applications

The appropriate choice depends on how much application-platform functionality is required.

29. ACI vs Container Apps

The AZ-104 concepts can be viewed as:

ACI
→ Simple container execution


Container Apps
→ Managed application/container platform

ACI is useful when the requirement is primarily straightforward container execution without managing VMs.

30. Cleanup

After completing the experiment:

Navigate to:

Resource groups → rg-az104-aci-01

Choose:

Delete resource group

Confirm the deletion.

CLI verification:

az group exists --name rg-az104-aci-01

Expected result:

false

This removes:

Container Instance
Public endpoint
Container group
Test environment-variable container
Supporting resources
Screenshot Evidence

Recommended evidence:

01-resource-group.png
02-aci-created.png
03-aci-http-test.png
04-aci-logs.png
05-aci-configuration.png
06-aci-environment-variables.png
07-aci-restart-policy.png
08-aci-lifecycle-baseline.png
09-aci-restart.png
10-aci-stop-start.png
11-aci-final-operational-state.png
12-cleanup-resource-group.png
Lab Status

COMPLETE