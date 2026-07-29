# Lab 03 - Azure Queue Storage

## Objective

The objective of this lab is to create and manage Azure Queue Storage using the Azure Portal. This lab demonstrates how Queue Storage enables asynchronous communication between applications and background processing services.

---

## Learning Objectives

After completing this lab, you should be able to:

- Create an Azure Queue
- Add messages to a queue
- Peek queue messages
- Receive queue messages
- Delete processed messages
- Understand message visibility timeout
- Manage queues using the Azure Portal
- Understand Queue Storage use cases

---

## Azure Services Used

- Azure Storage Account
- Azure Queue Storage

---

## Prerequisites

- Azure Subscription
- Completed Lab 01 – Azure Storage Account
- Completed Lab 02 – Azure Blob Storage

---

## Architecture

```
Azure Subscription
│
└── Resource Group
    │
    └── Storage Account
        │
        └── Azure Queue
            │
            └── Queue Messages
```

---

## Validation Checklist

- Queue created
- Messages added
- Peek operation successful
- Receive operation successful
- Message deleted
- Queue verified

---

## Screenshots

- Queue Created
- Message Added
- Peek Message
- Receive Message
- Queue Overview

---

## Outcome

Successfully created and managed Azure Queue Storage to support asynchronous message processing.