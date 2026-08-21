# Compute Module 06 — Azure Container Instances

## Objective

Build, troubleshoot, operate, and clean up an Azure Container Instance using Azure CLI.

This command history covers:

- Resource Group
- Azure resource provider registration
- ACI deployment
- Linux container configuration
- Public networking
- DNS
- Port mapping
- CPU and memory allocation
- Environment variables
- Restart policies
- Container logs
- Container Exec
- Stop / Start / Restart
- HTTP verification
- Troubleshooting
- Cleanup

---

# 1. Resource Group

## Create

```powershell
az group create `
  --name rg-az104-aci-01 `
  --location eastus `
  --output table



Verify
az group show `
  --name rg-az104-aci-01 `
  --output table
2. Initial ACI Deployment Attempt

Initial command:

az container create `
  --resource-group rg-az104-aci-01 `
  --name aci-az104-01 `
  --image mcr.microsoft.com/oss/nginx/nginx:1.25.5 `
  --dns-name-label aci-az104-01-$env:USERNAME `
  --ports 80 `
  --cpu 1 `
  --memory 1 `
  --restart-policy Always `
  --output table

Result:

MissingSubscriptionRegistration

Azure reported that the subscription was not registered for:

Microsoft.ContainerInstance
3. Register Microsoft.ContainerInstance
az provider register `
  --namespace Microsoft.ContainerInstance `
  --wait
Verify Registration
az provider show `
  --namespace Microsoft.ContainerInstance `
  --query "registrationState" `
  --output tsv

Expected:

Registered
4. Second ACI Deployment Attempt

The provider was registered, but the deployment still failed because the operating system type was not explicitly supplied.

Original image:

mcr.microsoft.com/oss/nginx/nginx:1.25.5

Result:

InvalidOsType

Azure required:

Windows
or
Linux
5. Specify Linux OS Type

Retry:

az container create `
  --resource-group rg-az104-aci-01 `
  --name aci-az104-01 `
  --image mcr.microsoft.com/oss/nginx/nginx:1.25.5 `
  --os-type Linux `
  --dns-name-label aci-az104-01-$env:USERNAME `
  --ports 80 `
  --cpu 1 `
  --memory 1 `
  --restart-policy Always `
  --output table

Result:

InaccessibleImage

Azure could not access the requested image.

6. Use Known-Good Microsoft ACI Image

The lab switched to:

mcr.microsoft.com/azuredocs/aci-helloworld

Successful command:

az container create `
  --resource-group rg-az104-aci-01 `
  --name aci-az104-01 `
  --image mcr.microsoft.com/azuredocs/aci-helloworld `
  --os-type Linux `
  --dns-name-label aci-az104-01-$env:USERNAME `
  --ports 80 `
  --cpu 1 `
  --memory 1.5 `
  --restart-policy Always `
  --output table

Successful result included:

Name:
aci-az104-01


Status:
Running


Image:
mcr.microsoft.com/azuredocs/aci-helloworld


IP:
20.75.220.55


Port:
80


CPU:
1.0 core


Memory:
1.5 GB


OS:
Linux


Location:
eastus
7. Inspect ACI
az container show `
  --resource-group rg-az104-aci-01 `
  --name aci-az104-01 `
  --query "{Name:name,State:instanceView.state,IP:ipAddress.ip,FQDN:ipAddress.fqdn,Ports:ipAddress.ports}" `
  --output table

Observed:

Name:
aci-az104-01


State:
Running


IP:
20.75.220.55


FQDN:
aci-az104-01-mahes.eastus.azurecontainer.io


Port:
80
8. HTTP Verification
Invoke-WebRequest `
  http://aci-az104-01-mahes.eastus.azurecontainer.io `
  -UseBasicParsing

Successful result:

StatusCode:
200


StatusDescription:
OK
9. Container Logs
az container logs `
  --resource-group rg-az104-aci-01 `
  --name aci-az104-01

Observed:

listening on port 80

and:

GET / HTTP/1.1 200 1696
10. Focused Container Configuration
az container show `
  --resource-group rg-az104-aci-01 `
  --name aci-az104-01 `
  --query "{Name:name,State:instanceView.state,Image:containers[0].image,CPU:containers[0].resources.requests.cpu,Memory:containers[0].resources.requests.memoryInGB,OS:osType,RestartPolicy:restartPolicy,IP:ipAddress.ip,FQDN:ipAddress.fqdn,Port:ipAddress.ports[0].port}" `
  --output table

Observed:

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


RestartPolicy:
Always


IP:
20.75.220.55


Port:
80
11. Environment Variables — Baseline

The main container was queried for environment variables:

az container show `
  --resource-group rg-az104-aci-01 `
  --name aci-az104-01 `
  --query "containers[0].environmentVariables" `
  --output table

No environment variables were configured on the main container.

12. Environment Variable Test Container

Created a second container:

az container create `
  --resource-group rg-az104-aci-01 `
  --name aci-az104-env-01 `
  --image mcr.microsoft.com/azuredocs/aci-helloworld `
  --os-type Linux `
  --environment-variables APP_ENV=lab APP_VERSION=1.0 `
  --ports 80 `
  --cpu 1 `
  --memory 1.5 `
  --restart-policy Never `
  --output table

Verify:

az container show `
  --resource-group rg-az104-aci-01 `
  --name aci-az104-env-01 `
  --query "containers[0].environmentVariables" `
  --output table

Observed:

APP_ENV      lab
APP_VERSION  1.0
13. Inspect Test Container Lifecycle
az container show `
  --resource-group rg-az104-aci-01 `
  --name aci-az104-env-01 `
  --query "{Name:name,State:instanceView.state,RestartPolicy:restartPolicy,OS:osType}" `
  --output table

Observed:

Name:
aci-az104-env-01


State:
Running


RestartPolicy:
Never


OS:
Linux
14. Delete Environment Variable Test Container
az container delete `
  --resource-group rg-az104-aci-01 `
  --name aci-az104-env-01 `
  --yes

Verify removal:

az container show `
  --resource-group rg-az104-aci-01 `
  --name aci-az104-env-01 `
  --output table

Expected result:

ResourceNotFound
15. Main Container Lifecycle Baseline
az container show `
  --resource-group rg-az104-aci-01 `
  --name aci-az104-01 `
  --query "{Name:name,State:instanceView.state,RestartPolicy:restartPolicy,RestartCount:containers[0].instanceView.restartCount}" `
  --output table

Initial state:

State:
Running


RestartPolicy:
Always


RestartCount:
0
16. ACI Command Help
az container --help

Supported lifecycle/operations commands observed included:

attach
create
delete
exec
export
list
logs
restart
show
start
stop
17. Restart Container Group
az container restart `
  --resource-group rg-az104-aci-01 `
  --name aci-az104-01

Verify:

az container show `
  --resource-group rg-az104-aci-01 `
  --name aci-az104-01 `
  --query "{Name:name,State:instanceView.state,RestartPolicy:restartPolicy,RestartCount:containers[0].instanceView.restartCount}" `
  --output table

The container returned to:

Running

with:

RestartPolicy:
Always
18. Container Exec
az container exec `
  --resource-group rg-az104-aci-01 `
  --name aci-az104-01 `
  --exec-command "/bin/sh"

Inside the container:

pwd

Observed:

/usr/src/app
19. Inspect Container Filesystem

Inside the container:

ls -la

Observed application files included:

index.js
index.html
package.json
package-lock.json
node_modules/
20. Inspect Application

Inside the container:

cat index.js

The application used:

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

Exit:

exit
21. Final Operational State
az container show `
  --resource-group rg-az104-aci-01 `
  --name aci-az104-01 `
  --query "{Name:name,State:instanceView.state,Image:containers[0].image,CPU:containers[0].resources.requests.cpu,Memory:containers[0].resources.requests.memoryInGb,RestartPolicy:restartPolicy,RestartCount:containers[0].instanceView.restartCount,IP:ipAddress.ip,Port:ipAddress.ports[0].port}" `
  --output table

Final state included:

Running
mcr.microsoft.com/azuredocs/aci-helloworld
1.0 CPU
Always
20.75.220.55
80
22. Final Logs
az container logs `
  --resource-group rg-az104-aci-01 `
  --name aci-az104-01

Observed:

listening on port 80
GET / HTTP/1.1 200 1696
23. Stop Container Group
az container stop `
  --resource-group rg-az104-aci-01 `
  --name aci-az104-01

Verify:

az container show `
  --resource-group rg-az104-aci-01 `
  --name aci-az104-01 `
  --query "{Name:name,State:instanceView.state,RestartPolicy:restartPolicy}" `
  --output table

Observed:

State:
Stopped


RestartPolicy:
Always
24. Start Container Group
az container start `
  --resource-group rg-az104-aci-01 `
  --name aci-az104-01

Verify:

az container show `
  --resource-group rg-az104-aci-01 `
  --name aci-az104-01 `
  --query "{Name:name,State:instanceView.state,RestartPolicy:restartPolicy}" `
  --output table

Observed:

State:
Running
25. Verify Application Recovery
Invoke-WebRequest `
  http://aci-az104-01-mahes.eastus.azurecontainer.io `
  -UseBasicParsing

Expected:

StatusCode:
200


StatusDescription:
OK

This demonstrated:

Running
→ Stop
→ Stopped
→ Start
→ Running
→ HTTP 200
26. Final Cleanup

Delete the resource group:

az group delete `
  --name rg-az104-aci-01 `
  --yes

Verify:

az group exists --name rg-az104-aci-01

Expected:

false
Troubleshooting Summary
Issue 1 — Provider Not Registered

Error:

MissingSubscriptionRegistration

Resolution:

az provider register `
  --namespace Microsoft.ContainerInstance `
  --wait

Verify:

az provider show `
  --namespace Microsoft.ContainerInstance `
  --query "registrationState" `
  --output tsv
Issue 2 — Invalid OS Type

Error:

InvalidOsType

Resolution:

--os-type Linux
Issue 3 — Inaccessible Image

Error:

InaccessibleImage

Original image:

mcr.microsoft.com/oss/nginx/nginx:1.25.5

Resolution:

mcr.microsoft.com/azuredocs/aci-helloworld
Lab Status

COMPLETE