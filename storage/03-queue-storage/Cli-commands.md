# Azure CLI Commands

## Login

```bash
az login
```

---

## Verify Signed-In Account

```bash
az account show \
  --query "{User:user.name,Subscription:id}" \
  --output table
```

---

## Verify Storage Account

```bash
az storage account show \
  --name staz104az01 \
  --resource-group rg-az104-storage-01 \
  --query "{Name:name,ResourceGroup:resourceGroup,Location:location,Kind:kind,Sku:sku.name}" \
  --output table
```

---

## Get Storage Account Resource ID

```bash
az storage account show \
  --name staz104az01 \
  --resource-group rg-az104-storage-01 \
  --query id \
  --output tsv
```

---

## Create Queue

```bash
az storage queue create \
  --name documents \
  --account-name staz104az01 \
  --auth-mode login \
  --output table
```

---

## List Queues

```bash
az storage queue list \
  --account-name staz104az01 \
  --auth-mode login \
  --query "[].{Name:name}" \
  --output table
```

---

## Add a Message

```bash
az storage message put \
  --queue-name documents \
  --content "Process sample document" \
  --account-name staz104az01 \
  --auth-mode login \
  --output table
```

---

## Add a PPST Processing Message

```bash
az storage message put \
  --queue-name documents \
  --content "Process document sample.txt" \
  --account-name staz104az01 \
  --auth-mode login \
  --output table
```

---

## Peek Messages

```bash
az storage message peek \
  --queue-name documents \
  --account-name staz104az01 \
  --auth-mode login \
  --num-messages 32 \
  --output table
```

---

## Receive Messages

```bash
az storage message get \
  --queue-name documents \
  --account-name staz104az01 \
  --auth-mode login \
  --num-messages 1 \
  --visibility-timeout 60 \
  --output table
```

Record the:

- Message ID
- Pop Receipt

The message becomes temporarily invisible while it is being processed.

---

## List Queue Messages

```bash
az storage message peek \
  --queue-name documents \
  --account-name staz104az01 \
  --auth-mode login \
  --num-messages 32 \
  --output table
```

---

## Delete a Processed Message

Replace the placeholders with the Message ID and Pop Receipt returned by the receive operation.

```bash
az storage message delete \
  --queue-name documents \
  --id <message-id> \
  --pop-receipt <pop-receipt> \
  --account-name staz104az01 \
  --auth-mode login \
  --output table
```

---

## Verify Final Queue State

```bash
az storage message peek \
  --queue-name documents \
  --account-name staz104az01 \
  --auth-mode login \
  --num-messages 32 \
  --output table
```

---

## Delete Queue

Only use this if the Queue is no longer required for the remaining lab work.

```bash
az storage queue delete \
  --name documents \
  --account-name staz104az01 \
  --auth-mode login
```

---

## Storage Lab Cleanup

Do not delete the Storage Account or Resource Group while the remaining Storage labs depend on them.

After all Storage labs are complete:

```bash
az group delete \
  --name rg-az104-storage-01 \
  --yes \
  --no-wait
```