# Compute Module 06 — Azure Container Instances

## Overview

This lab demonstrates how to deploy, operate, troubleshoot, inspect, and clean up an Azure Container Instance using Azure CLI and the Azure Portal.

The lab focused on:

- Azure Container Instances
- Container groups
- Linux containers
- Container images
- Public networking
- DNS naming
- Port mapping
- CPU and memory allocation
- Environment variables
- Restart policies
- Container logs
- Container Exec
- Stop / Start / Restart
- HTTP application verification
- Deployment troubleshooting
- Resource provider registration
- Container image troubleshooting
- Cleanup

The central operational workflow was:

```text
Create
   ↓
Verify
   ↓
Test
   ↓
Inspect
   ↓
Troubleshoot
   ↓
Operate
   ↓
Verify Recovery
   ↓
Cleanup


Architecture
                         Internet
                            |
                         DNS / FQDN
                            |
                       Public IP
                            |
                     ACI Container Group
                            |
                     Linux Container
                            |
                     Node.js / Express
                            |
                         TCP 80
                            |
                      HTTP Response

The deployed container was:

aci-az104-01

using:

mcr.microsoft.com/azuredocs/aci-helloworld
Resource Configuration
Component	Configuration
Resource Group	rg-az104-aci-01
Region	East US
Container Instance	aci-az104-01
Image	mcr.microsoft.com/azuredocs/aci-helloworld
OS	Linux
CPU	1.0 core
Memory	1.5 GB
Restart Policy	Always
Public IP	20.75.220.55
Port	TCP 80
FQDN	aci-az104-01-mahes.eastus.azurecontainer.io
Why ACI?

The customer scenario was:

Run a lightweight stateless application without managing a full virtual machine.

The architectural decision was:

Need full OS control?
        ↓
VM / VMSS


Need simple container execution?
        ↓
ACI


Need managed web application platform?
        ↓
App Service


Need managed container application platform?
        ↓
Container Apps

ACI is useful when the workload primarily requires:

Lightweight container execution
Application isolation
Simple lifecycle management
Reduced infrastructure-management overhead
VM vs ACI
Virtual Machine
VM
├── Operating System
├── Patching
├── Runtime
├── Application
├── Processes
└── System administration
Azure Container Instance
ACI
├── Container Image
├── Runtime Configuration
├── CPU
├── Memory
├── Networking
└── Application

ACI removes much of the infrastructure management associated with traditional VMs.

Container Isolation

A container provides an isolation boundary around the application and its runtime environment.

This can provide:

Application isolation
Dependency isolation
Consistent packaging
Lightweight execution

Security is still dependent on:

Image provenance
Image contents
Runtime configuration
Networking
Identity
Secrets
Container security context

ACI should therefore not automatically be described as "more secure" than every other compute option.

Application Architecture

The deployed image contained a Node.js / Express application.

Inside the container:

/usr/src/app

The application included:

index.js
index.html
package.json
package-lock.json
node_modules/

The application listened on:

process.env.PORT || 80

This demonstrated the relationship between:

Container Image
        +
Runtime Environment
        ↓
Application
HTTP Verification

The application was tested through its public FQDN.

Example:

Invoke-WebRequest `
  http://aci-az104-01-mahes.eastus.azurecontainer.io `
  -UseBasicParsing

Successful result:

StatusCode        : 200
StatusDescription : OK

This demonstrated the complete traffic path:

Client
   ↓
FQDN
   ↓
Public IP
   ↓
ACI
   ↓
Container
   ↓
TCP 80
   ↓
Application
   ↓
HTTP 200
Container Logs

The application logs were inspected using:

az container logs `
  --resource-group rg-az104-aci-01 `
  --name aci-az104-01

Observed:

listening on port 80

and:

GET / HTTP/1.1 200 1696

This proved that the request reached the application inside the container.

Runtime Environment Variables

A separate test container demonstrated runtime configuration.

Container:

aci-az104-env-01

Environment variables:

APP_ENV=lab
APP_VERSION=1.0

This demonstrated:

Same Container Image
        +
Different Runtime Configuration
        ↓
Different Environment

The test container was removed after the experiment.

Restart Policies

The main service used:

Restart Policy:
Always

A temporary test container used:

Restart Policy:
Never

Conceptually:

Always
   ↓
Continuously running service


Never
   ↓
One-shot / controlled workload
Container Lifecycle

The main ACI was tested through several lifecycle operations.

Running
   ↓
Restart
   ↓
Running

And:

Running
   ↓
Stopped
   ↓
Running
   ↓
HTTP 200

This demonstrated ACI container-group lifecycle management without requiring traditional VM administration.

Container Exec

The lab used:

az container exec `
  --resource-group rg-az104-aci-01 `
  --name aci-az104-01 `
  --exec-command "/bin/sh"

Inside the container, we inspected:

pwd
ls -la
cat index.js

The container's working directory was:

/usr/src/app

This demonstrated the difference between:

VM
→ SSH
→ Operating System


ACI
→ container exec
→ Container environment
Lightweight Container Environment

Inside the container, some standard Linux utilities were not available:

hostname
ps

However, the application and its dependencies were available.

This reinforced an important container concept:

A container is not necessarily a complete operating-system environment. It contains the application, runtime, and dependencies needed by the workload.

Troubleshooting

This lab contained three real deployment troubleshooting events.

1. Resource Provider Not Registered

Initial deployment failed with:

MissingSubscriptionRegistration

The required provider was:

Microsoft.ContainerInstance

The provider was registered and verified as:

Registered

Lesson:

A service deployment can fail when the required Azure resource provider is not registered for the subscription.

2. Invalid OS Type

The next deployment attempt failed because the container group did not have a valid OS type.

Azure required:

Windows
or
Linux

The final deployment explicitly used:

--os-type Linux

Lesson:

Resource-provider requirements must be satisfied explicitly when Azure cannot infer the required property.

3. Inaccessible Container Image

The original image:

mcr.microsoft.com/oss/nginx/nginx:1.25.5

failed with:

InaccessibleImage

The lab switched to:

mcr.microsoft.com/azuredocs/aci-helloworld

and the deployment succeeded.

Lesson:

A syntactically valid image reference does not guarantee that the target service can pull the image.

Troubleshooting Pattern

The actual troubleshooting process was:

Deployment Attempt
       ↓
Read Exact Azure Error
       ↓
Identify Missing Requirement
       ↓
Make Smallest Correction
       ↓
Retry
       ↓
Verify

Actual sequence:

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
Container Running

This is a useful operational pattern for both manual Azure deployment and future Infrastructure as Code workflows.

ACI vs VMSS

VM Scale Sets are designed for managed VM fleets:

VMSS
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

ACI vs App Service

Conceptually:

ACI
→ Run containers


App Service
→ Run managed web applications

ACI provides a more direct container-execution model, while App Service provides a higher-level managed application platform.

ACI vs Container Apps

Conceptually:

ACI
→ Simple container execution


Container Apps
→ Managed application/container platform

The appropriate choice depends on how much platform functionality and application orchestration the workload requires.

Key Lessons
ACI provides lightweight container execution without customer-managed VM operating systems.
Containers provide application and dependency isolation.
ACI does not provide the same operating-system administration model as a VM.
Container images and runtime configuration are separate concerns.
Environment variables allow runtime configuration without rebuilding the image.
Restart policies influence container lifecycle behavior.
az container exec provides container-level operational access.
Container logs provide application-level evidence.
ACI supports direct stop, start, and restart operations.
Azure resource providers may need to be registered before deployment.
A valid image reference may still fail if the image cannot be pulled.
Azure error messages should be read literally and addressed one requirement at a time.
A container being Running is not enough; application behavior should also be verified.
The full operational workflow is:
Create
→ Verify
→ Test
→ Inspect
→ Troubleshoot
→ Operate
→ Verify
→ Cleanup
Screenshot Evidence

The lab includes evidence for:

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
Cleanup

The complete temporary ACI environment was deleted:

rg-az104-aci-01

Final verification:

az group exists --name rg-az104-aci-01

Result:

false

This confirmed cleanup of:

Main ACI container
Test environment-variable container
Public endpoint
Container groups
Supporting resources
Lab Status

COMPLETE

This lab successfully demonstrated Azure Container Instances, container lifecycle management, environment variables, container execution, logs, public networking, deployment troubleshooting, operational verification, and cleanup through hands-on Azure administration.