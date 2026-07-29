# Azure Portal Steps

## Step 1

Sign in to the Azure Portal.

---

## Step 2

Navigate to:

Storage Accounts

Select the Storage Account created in Lab 01.

---

## Step 3

Open:

Data Storage → Queues

---

## Step 4

Select:

+ Queue

Provide a queue name.

Example:

```
documents
```

Click **Create**.

---

## Step 5

Open the newly created queue.

Select:

Add Message

Enter a sample message.

Example:

```
Process invoice.pdf
```

Click **OK**.

---

## Step 6

Add additional messages.

Example:

```
Generate embeddings

Archive completed file
```

---

## Step 7

Select:

Peek

Verify the messages are visible without removing them.

---

## Step 8

Select:

Receive Message

Observe:

- Pop Receipt
- Dequeue Count
- Time Next Visible

---

## Step 9

Delete the processed message.

---

## Result

Azure Queue Storage successfully configured and validated.