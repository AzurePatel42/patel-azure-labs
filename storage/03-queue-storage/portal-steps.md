# Azure Portal Steps

## Step 1 - Open Storage Account

Sign in to the Azure Portal.

Navigate to:

**Storage Accounts**

Open:

`staz104az01`

---

## Step 2 - Open Queues

Navigate to:

**Data Storage → Queues**

---

## Step 3 - Create Queue

Select:

**+ Queue**

Enter:

```text
documents
```

Create the Queue.

---

## Step 4 - Verify Queue

Open the `documents` Queue.

Verify that the Queue exists and is available.

---

## Step 5 - Add Message

Select:

**Add Message**

Enter:

```text
Process sample document
```

Save the message.

---

## Step 6 - Verify Message

Verify that the message appears in the Queue.

Record the message content and visible message state.

---

## Step 7 - Peek Message

Use the Queue message inspection/peek capability.

Verify that the message can be inspected without permanently removing it.

---

## Step 8 - Receive Message

Receive the message for processing.

Observe:

- Message ID
- Pop Receipt
- Dequeue Count
- Visibility timeout / next visible time

The message becomes temporarily invisible while it is being processed.

---

## Step 9 - Delete Processed Message

After processing is considered successful, delete the message.

Verify that it is no longer available in the Queue.

---

## Step 10 - Final Validation

Return to the Queue.

Verify:

- Queue still exists
- Processed message has been removed
- Queue is ready for additional processing messages

---

## Result

Azure Queue Storage successfully created and validated using the existing Storage Account.