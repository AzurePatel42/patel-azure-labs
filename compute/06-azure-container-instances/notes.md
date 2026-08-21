# Compute Module 06 — Azure Container Instances

## Objective

Build and operate an Azure Container Instance from scratch and understand the operational difference between container execution and VM-based compute.

The lab focused on:

- Azure Container Instances
- Container images
- Container groups
- Linux containers
- Public networking
- DNS naming
- Port mapping
- CPU and memory allocation
- Environment variables
- Restart policies
- Container logs
- Container exec
- Stop/start lifecycle
- HTTP application verification
- Provider registration
- Image troubleshooting
- Cleanup

The central architecture was:

```text
Container Image
      ↓
Azure Container Instance
      ↓
Container Group
      ↓
Running Application



1. Architecture Decision

The customer scenario was:

Run a lightweight stateless application without managing a full virtual machine.

The decision was to use Azure Container Instances because the workload did not require full VM-level operating-system management.

Conceptually:

VM
 ↓
OS
 ↓
Runtime
 ↓
Application

versus:

ACI
 ↓
Container Image
 ↓
Application

Azure manages the underlying container host infrastructure.

2. VM vs ACI
Virtual Machine

A VM provides more control:

VM
├── Operating System
├── Patching
├── Runtime
├── Application
├── Processes
└── System administration
Azure Container Instance

ACI provides a higher level of abstraction:

ACI
├── Container Image
├── Runtime Configuration
├── CPU
├── Memory
├── Networking
└── Application

The underlying host infrastructure is managed by Azure.

3. Container Isolation

A container provides an isolation boundary around the application and its runtime environment.

This is useful for:

Application packaging
Dependency isolation
Lightweight execution
Consistent deployment
Reduced infrastructure-management overhead

Security still depends on:

Image provenance
Image contents
Runtime configuration
Networking
Identity
Secrets management
Container security settings

ACI should therefore not automatically be described as "more secure" than every other compute option.

4. Resource Group

Created:

rg-az104-aci-01

Region:

East US
5. Azure Container Instance

Created:

aci-az104-01

Final successful image:

mcr.microsoft.com/azuredocs/aci-helloworld

Operating system:

Linux

CPU:

1.0 core

Memory:

1.5 GB

Restart policy:

Always

Public networking:

Public

Port:

80
6. Public Endpoint

The container received:

Public IP:
20.75.220.55

FQDN:

aci-az104-01-mahes.eastus.azurecontainer.io

Application port:

80

Architecture:

Internet
   ↓
ACI FQDN
   ↓
Public IP
   ↓
Container Group
   ↓
Port 80
   ↓
Application
7. HTTP Verification

The application endpoint was tested using:

Invoke-WebRequest `
  http://aci-az104-01-mahes.eastus.azurecontainer.io `
  -UseBasicParsing

Result:

StatusCode:
200


StatusDescription:
OK

This demonstrated successful end-to-end application connectivity.

8. Container Logs

Container logs were inspected with:

az container logs `
  --resource-group rg-az104-aci-01 `
  --name aci-az104-01

Observed:

listening on port 80

and:

GET / HTTP/1.1 200 1696

This proved that the HTTP request reached the application inside the container.

9. Application Inside the Container

Using:

az container exec `
  --resource-group rg-az104-aci-01 `
  --name aci-az104-01 `
  --exec-command "/bin/sh"

an interactive shell was opened inside the container.

The working directory was:

/usr/src/app

The container contained:

index.js
index.html
package.json
package-lock.json
node_modules/
10. Application Runtime

The application was a Node.js / Express application.

The inspected index.js included:

const express = require('express');
const morgan = require('morgan');


const app = express();
app.use(morgan('combined'));


app.get('/', (req, res) => {
  res.sendFile(__dirname + '/index.html')
});


var listener = app.listen(process.env.PORT || 80, function() {
 console.log('listening on port ' + listener.address().port);
});

Important observation:

process.env.PORT || 80

demonstrates that runtime configuration can be supplied through environment variables.

11. Lightweight Container Environment

Inside the container, standard VM utilities such as:

hostname
ps

were not available.

However, application files and dependencies were present.

This demonstrated an important container concept:

VM
→ Full operating-system environment


Container
→ Application + runtime + required dependencies

The container image does not need to provide the complete toolbox of a VM.

12. Environment Variables

A separate test container was created:

aci-az104-env-01

Environment variables:

APP_ENV=lab
APP_VERSION=1.0

Verified with:

APP_ENV      lab
APP_VERSION  1.0

This demonstrated:

Container Image
      +
Runtime Configuration
      ↓
Container Instance

The same image can therefore be reused across environments with different runtime values.

Example:

Same Image
   ↓
APP_ENV=dev


Same Image
   ↓
APP_ENV=test


Same Image
   ↓
APP_ENV=prod

The test container was later deleted.

13. Restart Policies

Two restart-policy concepts were demonstrated.

Main Container
aci-az104-01
restartPolicy:
Always

This is appropriate for a continuously running service.

Test Container
aci-az104-env-01
restartPolicy:
Never

This is suitable for workloads where Azure should not automatically restart the container after it exits.

14. Container Lifecycle

The main ACI lifecycle was tested:

Running
   ↓
Stop
   ↓
Stopped
   ↓
Start
   ↓
Running
   ↓
HTTP 200

Commands used:

az container stop
az container start
az container show

After restarting:

State:
Running

and the application again returned:

HTTP 200 OK

This demonstrated ACI container-group lifecycle management.

15. Container Restart

The container group was also explicitly restarted.

Initial state:

Running
RestartPolicy:
Always


RestartCount:
0

The restart operation demonstrated that ACI supports container-group restart operations directly.

This differs from VM administration because we are operating at the container-group lifecycle level, not administering a guest operating system.

16. Container Exec vs VM SSH

The lab demonstrated an important operational distinction.

VM
SSH
 ↓
Operating System
 ↓
System administration
ACI
az container exec
 ↓
Container
 ↓
Application environment

The ACI container does not provide the same operating-system administration model as a VM.

17. Troubleshooting #1 — Provider Registration

The first ACI creation attempt failed:

MissingSubscriptionRegistration

Azure reported:

The subscription is not registered to use namespace
'Microsoft.ContainerInstance'

The provider was registered:

az provider register `
  --namespace Microsoft.ContainerInstance `
  --wait

Verification:

az provider show `
  --namespace Microsoft.ContainerInstance `
  --query "registrationState" `
  --output tsv

Result:

Registered

Lesson:

A correct deployment command can still fail if the required Azure resource provider is not registered for the subscription.

18. Troubleshooting #2 — Missing OS Type

After provider registration, the next deployment failed with:

InvalidOsType

Azure required:

Windows
or
Linux

The correction was:

--os-type Linux

Lesson:

Container-group configuration must explicitly satisfy the resource provider's required properties.

19. Troubleshooting #3 — Inaccessible Image

The original image reference:

mcr.microsoft.com/oss/nginx/nginx:1.25.5

failed with:

InaccessibleImage

Azure reported:

The image ... is not accessible.
Please check the image and registry credential.

The lab switched to Microsoft's known-good ACI image:

mcr.microsoft.com/azuredocs/aci-helloworld

The deployment then succeeded.

Lesson:

A syntactically valid image name does not guarantee that the image reference is accessible to the target service.

20. Troubleshooting Model

The ACI troubleshooting sequence was:

Deployment attempt
      ↓
Azure error
      ↓
Read exact error
      ↓
Identify missing requirement
      ↓
Make smallest correction
      ↓
Retry
      ↓
Verify

Actual sequence:

Provider not registered
        ↓
Register provider
        ↓
Invalid OS type
        ↓
Specify Linux
        ↓
Image inaccessible
        ↓
Use known-good image
        ↓
Container Running

This is a valuable cloud-operations pattern.

21. Container Configuration

The final main container configuration included:

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


Restart Policy:
Always


Public IP:
20.75.220.55


Port:
80
22. Resource Requests

The container was intentionally kept small:

CPU:
1.0 core


Memory:
1.5 GB

The purpose was to keep the learning workload lightweight while demonstrating ACI resource allocation.

23. Operational Verification

The final operational state was verified with:

Provisioning:
Succeeded


State:
Running


Restart:
Always


Port:
80

Application validation:

HTTP 200 OK

Logs confirmed:

listening on port 80
GET / HTTP/1.1 200 1696
24. ACI vs VM
Area	VM	ACI
OS management	Customer	Azure-managed host
OS patching	Customer	Azure-managed host
Application packaging	VM/files	Container image
Lifecycle	VM operations	Container-group operations
Access model	SSH	Container Exec
Infrastructure control	Higher	Lower
Operational overhead	Higher	Lower
Best fit	Full OS control	Lightweight container workloads
25. ACI vs VMSS

VM Scale Sets are designed for a fleet of VMs:

VMSS
   ↓
Multiple VM instances
   ↓
Availability / scaling

ACI is aimed at simpler container execution:

ACI
   ↓
Container group
   ↓
Container workload

ACI should not be treated as a direct VMSS replacement.

26. ACI vs App Service

App Service is a managed application platform.

ACI is a lower-level container execution service.

Conceptually:

ACI
→ Run container


App Service
→ Run managed web application

The choice depends on how much application-platform functionality and abstraction the workload needs.

27. ACI vs Container Apps

The lab focused on ACI.

A useful conceptual comparison is:

ACI
→ Simple container execution


Container Apps
→ Managed application/container platform

ACI is useful when we need straightforward container execution without managing VMs.

28. Key Lessons
ACI provides lightweight container execution without customer-managed VM operating systems.
A container is an application packaging and isolation boundary.
ACI does not provide the same operating-system administration model as a VM.
Container images and runtime configuration are separate concerns.
Environment variables allow runtime configuration without rebuilding the image.
Restart policies influence container lifecycle behavior.
az container exec provides container-level operational access.
Container logs provide application-level evidence.
ACI supports direct stop, start, and restart operations.
Azure resource providers must be registered before certain services can be deployed.
A valid-looking container image reference may still fail if the image is inaccessible.
Azure errors should be read literally and addressed one requirement at a time.
Application health should be verified with an actual request, not only a Running state.
The final operational pattern was:
Create
→ Verify
→ Test
→ Inspect
→ Troubleshoot
→ Operate
→ Verify
→ Cleanup
29. Final Cleanup

The complete ACI lab resource group was deleted:

rg-az104-aci-01

Final verification:

az group exists --name rg-az104-aci-01

Expected:

false

This confirmed cleanup of:

Container Instance
Public endpoint
Container group
Test environment-variable container
Supporting resources
Lab Status

COMPLETE