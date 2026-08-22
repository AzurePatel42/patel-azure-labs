# Azure App Service Plan — AZ-104 Lab

## Overview

This lab covers Azure App Service Plan concepts and the process of validating App Service Plan SKU and regional availability.

The deployment portion of this lab was intentionally tested against the Azure subscription quota.

Azure returned the following deployment limitation:

```text
Location: East US
Current Limit (Total VMs): 0
Current Usage: 0
Amount required: 1
Minimum new limit required: 1


Therefore, the App Service Plan could not be created in the current subscription.

This is documented as a quota-constrained AZ-104 lab rather than a falsely completed deployment.

Lab Environment
Item	Value
Resource Group	rg-az104-networking-01
Location	East US
Tested SKU	F1
App Service Plan	asp-az104-lab-01
Current Total VM Limit	0
Current Usage	0
Required Limit	1
Learning Objectives

This lab demonstrates how to:

Identify App Service Plan SKU options
Check regional SKU availability
Understand App Service Plan deployment requirements
Recognize subscription quota limitations
Diagnose an Azure deployment failure
Distinguish regional SKU availability from subscription quota
Use Azure CLI to investigate App Service capabilities
SKU Availability

The Azure CLI was used to check App Service Plan SKU availability.

The following SKUs were tested:

B1
F1

Both returned East US as an available region.

Therefore:

SKU availability in East US = Available
Existing Microsoft.Web Resources

The following command was used to determine whether existing App Service resources were consuming capacity:

az resource list `
  --query "[?contains(type, 'Microsoft.Web')].{Name:name,Type:type,RG:resourceGroup,Location:location}" `
  --output table

The command returned no resources.

Therefore:

Existing Microsoft.Web usage = None
App Service Plan Deployment Test

The following deployment was attempted:

az appservice plan create `
  --resource-group rg-az104-networking-01 `
  --name asp-az104-lab-01 `
  --location eastus `
  --sku F1 `
  --output table

Azure rejected the deployment because additional quota was required.

Azure reported:

Creating App Service Plan 'asp-az104-lab-01' (Windows).
Operation cannot be completed without additional quota.


Location:
East US


Current Limit (Total VMs):
0


Current Usage:
0


Amount required for this deployment (Total VMs):
1


Minimum new limit that you should request:
1
Root Cause

The deployment failure was caused by the subscription's regional quota.

The subscription currently has:

Total VM Limit = 0

The App Service Plan deployment requires:

Total VM Capacity = 1

Therefore:

0 available
<
1 required

The deployment cannot proceed until the quota is increased.

Important Distinction

The failure was not caused by SKU availability.

Azure confirmed that F1 is available in East US.

The failure was also not caused by existing Microsoft.Web resources, because no existing Microsoft.Web resources were found.

The actual blocker is:

Subscription quota
AZ-104 Administrator Lesson

A supported Azure SKU does not guarantee that a subscription can deploy that SKU.

A deployment can fail because of:

Region availability
SKU availability
Subscription quota
Resource limits
Permissions
Configuration

An Azure administrator must identify the actual cause rather than repeatedly retrying the deployment.

Current Lab Status
Resource Group investigation       COMPLETE
SKU availability investigation     COMPLETE
Regional availability              COMPLETE
Existing resource investigation    COMPLETE
F1 deployment test                 COMPLETE
Quota diagnosis                    COMPLETE
App Service Plan deployment        BLOCKED
Status

🟡 Learning objective completed; deployment blocked by subscription quota.

The lab should not be marked as a successful App Service Plan deployment because Azure did not permit creation.

Evidence

Screenshots captured:

01-resource-group.png
02-app-service-quata.png

The screenshots document the resource-group setup and quota investigation.

The final CLI deployment attempt provides the exact quota error and required limit.

Future Completion

If the Azure subscription quota is increased to at least:

1 Total VM

in:

East US

the App Service Plan deployment can be retried.

Example:

az appservice plan create `
  --resource-group rg-az104-networking-01 `
  --name asp-az104-lab-01 `
  --location eastus `
  --sku F1 `
  --output table

No quota increase is being requested solely for this learning lab at this time.

Portfolio Value

This lab demonstrates an important real-world Azure administration skill:

Deployment
    ↓
Failure
    ↓
Investigation
    ↓
Evidence
    ↓
Root Cause
    ↓
Corrective Action

The lab demonstrates that Azure administration includes troubleshooting infrastructure constraints, not only successful deployments.



Save and close.


---


### 2. `cli-commands.md`


Run:


```powershell
notepad .\cli-commands.md

Paste:

# Azure App Service Plan — CLI Commands


## Resource Group


Verify the resource group:


```powershell
az group show `
  --name rg-az104-networking-01 `
  --query "{Name:name,Location:location,State:properties.provisioningState}" `
  --output table
Check App Service SKU Availability

The Azure CLI requires a specific App Service Plan SKU.

Incorrect generic SKU
az appservice list-locations `
  --sku Standard `
  --output table

Result:

'Standard' is not a valid value for '--sku'.

The command requires an App Service SKU such as:

F1
B1
B2
B3
S1
S2
S3
Check B1 Availability
az appservice list-locations `
  --sku B1 `
  --output table

East US appeared in the returned list.

Check F1 Availability
az appservice list-locations `
  --sku F1 `
  --output table

East US appeared in the returned list.

Therefore:

F1 + East US = Supported
Check Existing Microsoft.Web Resources
az resource list `
  --query "[?contains(type, 'Microsoft.Web')].{Name:name,Type:type,RG:resourceGroup,Location:location}" `
  --output table

Result:

No resources returned

This confirmed that there were no existing Microsoft.Web resources consuming capacity.

Quota Investigation Attempt

The Azure CLI quota extension was invoked with:

az quota show `
  --resource-type Microsoft.Web `
  --scope eastus `
  --output json

The CLI installed the quota extension but reported that the command requires a specific:

--resource-name

The generic Microsoft.Web quota query was therefore not sufficient to identify the specific quota resource.

App Service Plan Deployment Test

The following deployment was attempted:

az appservice plan create `
  --resource-group rg-az104-networking-01 `
  --name asp-az104-lab-01 `
  --location eastus `
  --sku F1 `
  --output table

Azure returned:

Creating App Service Plan 'asp-az104-lab-01' (Windows).


Operation cannot be completed without additional quota.


Location:
East US


Current Limit (Total VMs):
0


Current Usage:
0


Amount required for this deployment (Total VMs):
1


Minimum new limit that you should request to enable this deployment:
1
Quota Diagnosis

Current state:

Location:
East US


Current Limit:
0 Total VMs


Current Usage:
0


Required:
1 Total VM


Minimum New Limit:
1

Therefore:

Current quota = 0
Required quota = 1

The deployment cannot proceed without additional quota.

Key CLI Commands
az appservice list-locations

Used to identify regions supporting a particular App Service Plan SKU.

az appservice plan create

Used to create an App Service Plan.

az resource list

Used to inspect existing resources.

az quota show

Used to query Azure quota information when the appropriate quota resource name is known.

Important CLI Lesson

az appservice list-locations requires the actual App Service SKU.

Examples:

--sku F1
--sku B1
--sku S1
--sku P1V3

Standard by itself is not a valid value for this command.

Deployment Result
SKU supported in East US       YES
Existing Microsoft.Web usage   NONE
Deployment command              VALID
Subscription quota              BLOCKED

The deployment was not completed because Azure requires a minimum Total VM quota of 1.



Save and close.


---


### 3. `notes.md`


Run:


```powershell
notepad .\notes.md

Paste:

# AZ-104 App Service Plan Notes


## Core Concept


An App Service Plan defines the compute resources and pricing tier used by Azure App Service workloads.


Think:


```text
App Service Plan
      |
      +-- Compute capacity
      +-- Pricing/SKU
      +-- Region
      |
      +-- Web Apps
      +-- Other App Service workloads
SKU Availability vs Quota

This lab demonstrated an important Azure administration distinction.

SKU availability

Question:

Does Azure offer this SKU in the selected region?

We verified:

F1 → East US = Available
B1 → East US = Available
Subscription quota

Different question:

Does this subscription have enough capacity/quota to deploy it?

Our subscription:

East US
Current Total VM Limit = 0
Required = 1

Therefore deployment was blocked.

The Important Mental Model
SKU available?
       |
       +-- No → Choose another SKU/region
       |
      Yes
       |
Quota available?
       |
       +-- No → Request/increase quota
       |
      Yes
       |
Deploy
What Happened In This Lab

We attempted:

F1 App Service Plan
East US

Azure confirmed that F1 is available.

But deployment failed because:

Current Total VM Limit = 0
Required = 1

Therefore:

Availability = YES
Quota = NO

This is the central lesson of the lab.

Quota Error

Azure reported:

Operation cannot be completed without additional quota.

Details:

Location:
East US


Current Limit:
0


Current Usage:
0


Required:
1


Minimum New Limit:
1

The fact that current usage is zero is important.

This was not caused by another App Service Plan consuming the available quota.

Administrator Troubleshooting

When a deployment fails:

1. Read the complete error.
2. Identify the affected region.
3. Identify the SKU.
4. Check regional availability.
5. Check existing resources.
6. Identify quota/resource limits.
7. Decide whether to change configuration or request quota.

Do not repeatedly retry the same deployment without understanding the error.

Azure CLI SKU Names

For:

az appservice list-locations

use an actual SKU identifier.

Examples:

F1
B1
B2
B3
S1
S2
S3
P1V3

The word:

Standard

is not itself accepted by this command.

F1

F1 is a Free App Service tier.

It was selected for the deployment test because the goal was to minimize cost while learning.

Even though F1 is supported in East US, the subscription quota still prevented deployment.

B1

B1 is a Basic App Service Plan SKU.

The Azure CLI confirmed that B1 is available in East US.

Availability does not override subscription quota.

AZ-104 Scenario Thinking
Scenario

You attempt to create an App Service Plan.

The portal/CLI says the SKU is supported.

But deployment fails with a quota message.

What should you investigate?

Subscription quota

Not:

DNS
NSG
VNet
Application code

The error message identifies the infrastructure constraint.

Important Distinction
SKU
=
What service tier/configuration you want


Region availability
=
Where that SKU can be deployed


Quota
=
How much capacity the subscription is allowed to consume

These are different concepts.

Real-World Administrator Lesson

A deployment failure is not necessarily a configuration failure.

Azure may reject a valid configuration because of:

Quota
Capacity
Permissions
Policy
Region availability
Resource limits

The administrator's job is to determine which constraint is actually responsible.

Lab Status
Resource group              COMPLETE
SKU availability            COMPLETE
Region availability         COMPLETE
Resource inventory check    COMPLETE
Deployment attempt          COMPLETE
Quota diagnosis             COMPLETE
Actual App Service Plan     BLOCKED

Status:

🟡 Conceptually complete
⛔ Deployment blocked by subscription quota
Exam Memory

Remember:

Supported SKU ≠ Guaranteed deployment

And:

Quota = subscription/resource capacity constraint
Troubleshooting Formula
Deployment failure
       ↓
Read error
       ↓
Identify resource
       ↓
Identify region
       ↓
Check availability
       ↓
Check quota
       ↓
Check permissions/policy
       ↓
Correct the actual constraint
Portfolio Lesson

This lab demonstrates:

Azure CLI
+
Resource inspection
+
SKU investigation
+
Quota investigation
+
Deployment troubleshooting

The deployment did not succeed, but the troubleshooting exercise produced a valid Azure administration learning outcome.



Save and close.


---


### 4. `portal-steps.md`


Run:


```powershell
notepad .\portal-steps.md

Paste:

# Azure App Service Plan — Azure Portal Steps


## Overview


This document describes the Portal workflow for creating and troubleshooting an Azure App Service Plan.


The deployment was blocked by an Azure subscription quota limitation.


The Portal workflow remains important for AZ-104 because administrators frequently configure and inspect App Service resources through the Azure Portal.


---


# 1. Open Azure Portal


Open the Azure Portal and sign in.


Navigate to:


```text
Resource groups
2. Create/Inspect Resource Group

Use:

rg-az104-networking-01

Region:

East US

Open the resource group and confirm the resource inventory.

3. Navigate to App Service Plans

In Azure Portal:

Search
  ↓
App Service Plans

Select:

Create
4. Basics

Configure:

Subscription:
Your Azure subscription


Resource Group:
rg-az104-networking-01


Name:
asp-az104-lab-01


Operating System:
Windows


Region:
East US
5. Choose Pricing Tier

Select:

Change size

Review the available App Service Plan tiers.

For the lab deployment attempt, the equivalent low-cost learning tier was:

F1

The objective was to minimize cost.

6. Review + Create

Select:

Review + create

Review the configuration.

Normally the next step would be:

Create

However, in this subscription the deployment is blocked by quota.

7. Quota Investigation

The Azure Portal quota information showed that the subscription did not have sufficient Total VM quota for the requested App Service Plan deployment.

The relevant state was:

Location:
East US


Current Limit:
0 Total VMs


Current Usage:
0


Required:
1 Total VM

Minimum new limit:

1
8. Understanding the Error

The important point is:

F1 is available in East US

but:

Subscription quota is insufficient

Therefore the problem is not SKU availability.

9. Portal Troubleshooting Workflow

When an App Service Plan deployment fails:

Deployment
    ↓
Read error
    ↓
Check region
    ↓
Check SKU
    ↓
Check quota
    ↓
Check subscription/resource constraints

Do not repeatedly retry the same deployment without addressing the reported constraint.

10. What Was Successfully Validated

The lab validated:

Resource Group
        ↓
App Service Plan workflow
        ↓
SKU selection
        ↓
Region selection
        ↓
Quota investigation
        ↓
Deployment troubleshooting
11. Portal Evidence

Screenshots captured:

01-resource-group.png
02-app-service-quata.png

These document the resource-group setup and quota investigation.

12. Future Completion

If the subscription quota is increased to at least:

1 Total VM

in East US, return to:

App Service Plans
  ↓
Create

and retry:

Name:
asp-az104-lab-01


Region:
East US


SKU:
F1

No quota request is being made solely for this learning lab at this time.

13. AZ-104 Portal Mental Model

Remember:

App Service Plan
      |
      +-- Region
      +-- Operating System
      +-- Pricing Tier/SKU
      +-- Compute capacity

When creation fails, identify which part of the deployment is being rejected.

14. Exam Scenario

If an administrator selects a supported App Service Plan SKU and Azure reports:

Additional quota required

the correct direction is:

Investigate/request additional quota

Changing DNS, NSGs, or VNet configuration would not solve a quota problem.

15. Lab Status
Portal workflow understood       COMPLETE
Resource group                   COMPLETE
SKU investigation                COMPLETE
Quota investigation              COMPLETE
Deployment                       BLOCKED

Final status:

🟡 Learning objective completed
⛔ Deployment blocked by subscription quota

This limitation is documented intentionally rather than presenting an unsuccessful deployment as successful.