
# Azure Portal Steps

## Step 1 - Open Storage Account

Open the Azure Portal.

Navigate to:

**Storage accounts → staz104az01**

---

## Step 2 - Open Containers

Navigate to:

**Data storage → Containers**

Select:

**+ Container**

---

## Step 3 - Create Private Container

Create:

```text
Name: documents
Public access level: Private


Step 4 - Verify Container

Open the documents container.

Verify that it is private and ready for Blob data.

Screenshot:

01-blob-container-created.png

Step 5 - Upload Blob

Open the documents container.

Select:

Upload

Upload:

sample.txt

Screenshot:

02-blob-uploaded.png

Step 6 - Inspect Blob Properties and Metadata

Open:

documents → sample.txt

Review:

Size
Content type
Last modified
ETag
Encryption
Access tier
Custom metadata

Screenshot:

03-blob-properties-metadata.png

Step 7 - Verify Access Tier

Review the Blob access tier.

The lab uses:

Hot

Screenshot:

04-blob-access-tier-hot.png

Step 8 - Download Blob

Use the Blob interface to download sample.txt.

Verify that the downloaded file matches the original.

Screenshot:

05-blob-download-validation.png

Step 9 - Generate Read-Only SAS

Generate a short-lived SAS for sample.txt.

Configure:

Read permission
Short expiration
User delegation authentication

Do not expose or commit the generated SAS token.

Screenshot:

06-blob-sas-read-access.png

Result

Azure Blob Storage was successfully configured and validated using Azure Portal and Microsoft Entra-authenticated Azure CLI operations.