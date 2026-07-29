# Azure CLI Commands

## Login

```bash
az login
```

---

## Create Queue

```bash
az storage queue create \
  --name documents \
  --account-name <storage-account-name> \
  --auth-mode login
```

---

## Add Message

```bash
az storage message put \
  --queue-name documents \
  --content "Process invoice.pdf" \
  --account-name <storage-account-name> \
  --auth-mode login
```

---

## Peek Messages

```bash
az storage message peek \
  --queue-name documents \
  --account-name <storage-account-name> \
  --auth-mode login
```

---

## Receive Message

```bash
az storage message get \
  --queue-name documents \
  --account-name <storage-account-name> \
  --auth-mode login
```

---

## Delete Message

```bash
az storage message delete \
  --queue-name documents \
  --id <message-id> \
  --pop-receipt <pop-receipt> \
  --account-name <storage-account-name> \
  --auth-mode login
```

---

## List Queues

```bash
az storage queue list \
  --account-name <storage-account-name> \
  --output table
```