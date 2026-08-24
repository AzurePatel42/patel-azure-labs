
PS C:\patel-azure-labs\monitoring\01-azure-monitor-log-analytics> Get-Item .\portal-steps.md |
>>     Select-Object Name, Length

Name            Length
----            ------
portal-steps.md   2283


PS C:\patel-azure-labs\monitoring\01-azure-monitor-log-analytics>



2. Verify Resource Group
az group show `
  --name rg-az104-monitoring-01 `
  --output table
3. Verify Resource Providers
az provider show `
  --namespace Microsoft.OperationalInsights `
  --query "{Namespace:namespace,RegistrationState:registrationState}" `
  --output table
az provider show `
  --namespace Microsoft.Insights `
  --query "{Namespace:namespace,RegistrationState:registrationState}" `
  --output table
4. Verify Log Analytics Workspace
az monitor log-analytics workspace show `
  --workspace-name lawaz104mon01 `
  --resource-group rg-az104-monitoring-01 `
  --query "{Name:name,ResourceId:id,CustomerId:customerId,ProvisioningState:provisioningState}" `
  --output table
5. Verify Storage Account
az storage account show `
  --name staz104mon01 `
  --resource-group rg-az104-monitoring-01 `
  --query "{Name:name,Location:primaryLocation,Kind:kind,Sku:sku.name,ProvisioningState:provisioningState}" `
  --output table
6. Get Storage Account Resource ID
$storageId = az storage account show `
  --name staz104mon01 `
  --resource-group rg-az104-monitoring-01 `
  --query id `
  --output tsv
7. Build Queue Service Resource ID
$queueServiceId = "$storageId/queueServices/default"

Verify:

$queueServiceId
8. List Diagnostic Categories
az monitor diagnostic-settings categories list `
  --resource $queueServiceId `
  --output json
9. Create Diagnostic Setting
az monitor diagnostic-settings create `
  --name diag-staz104mon01-queue `
  --resource $queueServiceId `
  --workspace $workspaceId `
  --logs '[{"category":"StorageRead","enabled":true},{"category":"StorageWrite","enabled":true},{"category":"StorageDelete","enabled":true}]' `
  --metrics '[{"category":"Capacity","enabled":true},{"category":"Transaction","enabled":true}]' `
  --output json
10. Verify Diagnostic Setting
az monitor diagnostic-settings list `
  --resource $queueServiceId `
  --query "[].{Name:name,Workspace:workspaceId,Logs:logs[].category,Metrics:metrics[].category}" `
  --output table

Expected diagnostic setting:

diag-staz104mon01-queue

Expected workspace:

lawaz104mon01

Expected logs:

StorageRead
StorageWrite
StorageDelete

Expected metrics:

Capacity
Transaction
11. Create Storage Queue
az storage queue create `
  --name az104-monitoring-queue `
  --account-name staz104mon01 `
  --account-key $storageKey `
  --output table
12. Send Test Message
az storage message put `
  --queue-name az104-monitoring-queue `
  --content "AZ104 monitoring diagnostic test" `
  --account-name staz104mon01 `
  --account-key $storageKey `
  --output table
13. Read Queue Message
az storage message get `
  --queue-name az104-monitoring-queue `
  --account-name staz104mon01 `
  --account-key $storageKey `
  --output table
14. Query Azure Monitor Metrics
az monitor metrics list `
  --resource $queueServiceId `
  --metric "Transactions" `
  --interval PT1M `
  --aggregation Total `
  --output table

The lab observed transaction activity during the test operations.

15. Get Workspace Resource ID
$workspaceId = az monitor log-analytics workspace show `
  --workspace-name lawaz104mon01 `
  --resource-group rg-az104-monitoring-01 `
  --query id `
  --output tsv

Verify:

$workspaceId
16. Query Log Analytics
az monitor log-analytics query `
  --workspace $workspaceId `
  --analytics-query "search * | where TimeGenerated > ago(1h) | take 50" `
  --output table

Note: The Azure CLI log-analytics extension is currently a preview extension in this lab environment.

17. KQL — Storage Queue Logs

Use Log Analytics Logs:

StorageQueueLogs
| project TimeGenerated, OperationName, StatusCode
| order by TimeGenerated desc
18. KQL — Operational Summary
StorageQueueLogs
| summarize Count=count() by OperationName, StatusCode
| order by Count desc
19. Confirm Diagnostic Pipeline
az monitor diagnostic-settings list `
  --resource $queueServiceId `
  --query "[].{Name:name,Workspace:workspaceId,Logs:logs[].category,Metrics:metrics[].category}" `
  --output json
Important PowerShell Note

PowerShell interprets <MESSAGE_ID> and <POP_RECEIPT> as syntax rather than placeholders.

Use the actual values returned by the queue command.

Example:

az storage message delete `
  --queue-name az104-monitoring-queue `
  --id "MESSAGE-ID-HERE" `
  --pop-receipt "POP-RECEIPT-HERE" `
  --account-name staz104mon01 `
  --account-key $storageKey
Lab Resource Names
Resource	Value
Resource Group	rg-az104-monitoring-01
Workspace	lawaz104mon01
Storage Account	staz104mon01
Queue	az104-monitoring-queue
Diagnostic Setting	diag-staz104mon01-queue
Region	eastus
'@	Set-Content .\cli-commands.md