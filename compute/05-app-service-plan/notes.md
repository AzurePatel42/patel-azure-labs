# AZ-104 App Service Plan Notes

## Core Concept

An App Service Plan defines the compute resources, region, and pricing tier used by App Service workloads.

Mental model:

```text
App Service Plan
    |
    +-- Region
    +-- SKU / Pricing Tier
    +-- Compute Capacity
    |
    +-- Web Apps



SKU Availability vs Quota

These are different concepts.

SKU Availability

Question:

Does Azure support this SKU in the selected region?

We verified:

F1 → East US = Available
B1 → East US = Available
Subscription Quota

Question:

Does this subscription have enough capacity to deploy it?

Our deployment attempt showed:

Current Total VM Limit = 0
Current Usage          = 0
Required               = 1
Minimum New Limit      = 1

Therefore:

Availability = YES
Quota        = NO
Deployment Failure

The F1 App Service Plan deployment was attempted in East US.

Azure rejected it because additional quota was required.

The important error was:

Operation cannot be completed without additional quota.

The minimum new limit identified by Azure was:

1 Total VM
What This Was NOT

The failure was not caused by:

Wrong SKU
Unsupported region
Existing Microsoft.Web resources

We verified:

F1 supported in East US
B1 supported in East US
No existing Microsoft.Web resources

The actual blocker was subscription quota.

AZ-104 Troubleshooting Model

When an Azure deployment fails:

1. Read the complete error.
2. Identify the resource.
3. Check the region.
4. Check SKU availability.
5. Check existing resources.
6. Check quota/resource limits.
7. Correct the actual constraint.

Do not repeatedly retry the same deployment without understanding the error.

Exam Memory
SKU availability ≠ deployment guarantee

A supported SKU can still fail because of subscription quota.

Remember:

NSG      = security
Route    = routing
DNS      = name resolution
Quota    = subscription/resource capacity
Lab Status
Resource Group              COMPLETE
SKU investigation           COMPLETE
Region investigation        COMPLETE
Resource inventory          COMPLETE
Deployment test             COMPLETE
Quota diagnosis             COMPLETE
Actual App Service Plan     BLOCKED

Final status:

🟡 Conceptually complete
⛔ Deployment blocked by subscription quota
Administrator Lesson

Azure administration is not only successful deployment.

A real administrator must be able to:

Deploy
  ↓
Read errors
  ↓
Investigate
  ↓
Identify root cause
  ↓
Choose corrective action

This lab demonstrates that workflow.



Save and close.


Then `portal-steps.md`:


```powershell
notepad .\portal-steps.md

Paste:

# Azure App Service Plan — Portal Steps


## 1. Open App Service Plans


In Azure Portal:


```text
Search
  ↓
App Service Plans
  ↓
Create
2. Basics

Use:

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
3. Choose Pricing Tier

Select:

Change size

Review the available App Service Plan tiers.

For this learning test, F1 was selected because it is a low-cost tier.

4. Review and Create

Select:

Review + create

Then normally:

Create

However, the deployment was blocked by subscription quota.

5. Quota Result

Azure reported:

Location:
East US


Current Limit:
0 Total VMs


Current Usage:
0


Amount Required:
1 Total VM


Minimum New Limit:
1

Therefore the App Service Plan could not be created.

6. Troubleshooting

The investigation established:

F1 available in East US        YES
B1 available in East US        YES
Existing Microsoft.Web usage   NONE
Subscription quota             0
Required quota                 1

The actual blocker was subscription quota.

7. Administrator Decision

Do not repeatedly retry the same deployment.

Possible future corrective action:

Request/increase the required quota

For this learning lab, no quota increase was requested.

8. Evidence

Screenshots:

01-resource-group.png
02-app-service-quata.png

These document the resource-group setup and quota investigation.

9. AZ-104 Lesson

When an App Service deployment fails, distinguish between:

SKU availability
Region availability
Subscription quota
Permissions
Policy
Configuration

A quota failure is an infrastructure capacity issue, not a networking issue.

10. Lab Status
Portal workflow              COMPLETE
SKU investigation            COMPLETE
Quota investigation          COMPLETE
Deployment                   BLOCKED

Final status:

🟡 Learning objective completed
⛔ Deployment blocked by subscription quota