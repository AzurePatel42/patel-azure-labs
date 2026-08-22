# Azure App Service Plan — Portal Steps

## Overview

This lab documents the Azure Portal workflow for creating an App Service Plan and troubleshooting a subscription quota limitation.

The deployment was tested in:

- Resource Group: `rg-az104-networking-01`
- Region: `East US`
- Operating System: Windows
- Tested SKU: `F1`
- App Service Plan: `asp-az104-lab-01`

The deployment was blocked because the subscription's Total VM quota was `0`, while the deployment required `1`.

---

## 1. Open App Service Plans

In Azure Portal:

```text
Search
  ↓
App Service Plans
  ↓
Create


2. Configure Basics

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
3. Select Pricing Tier

Select:

Change size

Review the available App Service Plan tiers.

For this learning test, use:

F1

The F1 tier was selected to minimize cost during the lab.

4. Review and Create

Select:

Review + create

Normally the next step would be:

Create

However, Azure blocked the deployment because additional quota was required.

5. Quota Investigation

The Azure subscription reported:

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

Therefore:

Current quota = 0
Required quota = 1

The App Service Plan could not be deployed.

6. Verify SKU Availability

The Azure CLI was used to confirm that the selected SKU was supported in East US.

F1:

F1 → East US = Available

B1 was also confirmed as available:

B1 → East US = Available

Therefore the deployment failure was not caused by regional SKU availability.

7. Verify Existing App Service Resources

The Azure CLI returned no existing Microsoft.Web resources.

Therefore there was no existing App Service resource identified as consuming the available capacity.

8. Identify the Actual Blocker

The investigation established:

F1 available in East US        YES
B1 available in East US        YES
Existing Microsoft.Web usage   NONE
Current Total VM quota         0
Required Total VM quota        1

The actual blocker was:

Subscription quota
9. Administrator Troubleshooting Workflow

When an Azure deployment fails:

Deployment
    ↓
Read the complete error
    ↓
Identify resource
    ↓
Check region
    ↓
Check SKU availability
    ↓
Check existing resources
    ↓
Check quota/resource limits
    ↓
Identify root cause
    ↓
Choose corrective action

Do not repeatedly retry a deployment without addressing the reported constraint.

10. Future Completion

If the subscription quota is increased to at least:

1 Total VM

in East US, the App Service Plan can be retried.

Expected configuration:

Name:
asp-az104-lab-01


Region:
East US


Operating System:
Windows


SKU:
F1

No quota increase was requested solely for this learning lab.

11. Evidence

Screenshots captured:

01-resource-group.png
02-app-service-quata.png

The screenshots document the resource-group setup and quota investigation.

The final CLI deployment attempt provides the exact Azure quota error.

12. AZ-104 Lesson

A supported SKU does not guarantee that a deployment can be completed.

Azure deployment can be constrained by:

SKU availability
Region availability
Subscription quota
Resource limits
Permissions
Azure Policy
Configuration

For this lab:

SKU availability      ✅
Region availability   ✅
Existing resources     ✅ None found
Quota                  ⛔
13. Final Lab Status
Portal workflow              COMPLETE
Resource group               COMPLETE
SKU investigation            COMPLETE
Quota investigation          COMPLETE
Deployment attempt           COMPLETE
Actual App Service Plan      BLOCKED

Final status:

🟡 Learning objective completed
⛔ Deployment blocked by subscription quota

The lab is intentionally documented as quota-constrained rather than representing the deployment as successful.