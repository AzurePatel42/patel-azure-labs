# Lab 07 — Azure Storage Security Notes

## 1. Purpose of Azure Storage Security

Azure Storage security protects storage resources and data from unauthorized access, accidental exposure, and network-based threats.

Storage security should be considered in multiple layers:

1. Network security
2. Authentication
3. Authorization
4. Encryption
5. Data access controls
6. Secret management
7. Monitoring and operational security

A secure storage architecture should use multiple controls rather than depending on a single security mechanism.

---

# 2. Storage Security Layers

A useful way to understand Azure Storage security is:

```text
                    Azure Storage Account
                            |
              +-------------+-------------+
              |                           |
       Network Security             Identity Security
              |                           |
       Firewall / IP rules            Entra ID
       Virtual Networks              Azure RBAC
       Private Endpoints                  |
              |                           |
              +-------------+-------------+
                            |
                       Data Access
                            |
                 +----------+----------+
                 |                     |
             Encryption            Monitoring
                 |
          Data at Rest
          Data in Transit

Security controls operate at different layers and solve different problems.

3. Network Security

Azure Storage supports network-based restrictions that control where connections can originate.

The Storage Account networking configuration can include:

Public network access
Virtual network rules
IP address rules
Network security perimeter
Private endpoints

Network security determines whether a connection is allowed to reach the storage service.

It does not replace authentication or authorization.

4. Public Network Access

The Storage Account can be configured with:

Enabled from all networks
Enabled from selected virtual networks and IP addresses
Disabled

When public network access is enabled from all networks, the public endpoint is reachable from the internet.

This does not mean that anyone automatically has access to the data.

Authentication and authorization are still required.

However, restricting the network surface reduces exposure.

5. Selected Networks and IP Addresses

A Storage Account can restrict access to specific:

Virtual networks
Subnets
Public IP addresses
IP address ranges

For example:

Internet
   |
   +---- Approved IP --------> Storage Account
   |
   +---- Unapproved IP ------> Blocked

This provides an additional security boundary.

Network rules should be combined with identity-based access controls.

6. Network Security Perimeter

Azure provides Network Security Perimeter capabilities for centrally managing network access rules across supported resources.

A network security perimeter can help organizations establish centralized network boundaries.

For this lab, the network security perimeter was reviewed but not associated with the Storage Account.

Important principle:

Do not create additional security infrastructure simply for experimentation when the objective is to understand the existing control.

7. Authentication vs Authorization

These two concepts must be clearly distinguished.

Authentication

Authentication answers:

Who are you?

Examples:

Microsoft Entra ID
Storage Account access keys
SAS credentials
Authorization

Authorization answers:

What are you allowed to do?

Examples:

Azure RBAC
Storage data roles
SAS permissions

Conceptually:

User / Application
        |
        v
 Authentication
        |
        v
 Identity established
        |
        v
 Authorization
        |
        v
 Access decision
8. Storage Account Access Keys

Azure Storage Accounts provide access keys.

Typically there are two keys:

key1
key2

Access keys are highly privileged secrets.

They can provide broad access to storage services depending on how they are used.

They should therefore be protected like passwords.

Do not:

Commit keys to GitHub
Put keys in source code
Share keys through email or chat
Store keys in plain text
Expose keys in screenshots
9. Why Storage Has Two Access Keys

Storage Accounts provide two keys to support key rotation.

Example:

Application
    |
    +---- key1
    |
    +---- key2

An organization can rotate one key while continuing to use the other.

Example rotation process:

1. Application uses key1
2. Rotate key2
3. Update application to use key2
4. Rotate key1
5. Continue operating

This reduces the need for downtime during credential rotation.

10. Shared Access Signature (SAS)

A Shared Access Signature provides delegated and restricted access to Azure Storage resources.

Instead of giving a client the Storage Account access key, a SAS can provide limited permissions for a limited period.

Example:

Storage Account Key
       |
       v
   SAS Token
       |
       +---- Resource scope
       +---- Permissions
       +---- Start time
       +---- Expiry time
       +---- IP restriction
       +---- Protocol restriction

A SAS should be treated as a secret.

Anyone who obtains a valid SAS may be able to use the permissions encoded in that SAS.

11. Account SAS

An Account SAS can provide access across multiple Azure Storage services.

Possible services include:

Blob
File
Queue
Table

The SAS configuration can specify:

Allowed services

Which storage services can be accessed.

Allowed resource types

Examples:

Service
Container
Object
Allowed permissions

Examples:

Read
Write
Delete
List
Add
Create
Update
Process

The goal should always be least privilege.

12. SAS Expiration

SAS can include a start and expiry time.

Example:

Start: 09:00
End:   17:00

This limits the time during which the SAS can be used.

Short-lived credentials are generally preferable when practical.

Avoid unnecessarily long SAS expiration periods.

13. SAS IP Restrictions

A SAS can optionally restrict access to specific IP addresses or ranges.

Example:

Approved IP
     |
     v
   SAS
     |
     v
Storage Resource

Requests from unauthorized IP addresses can be denied.

This provides another layer of defense.

14. SAS Protocol Restrictions

SAS can be configured to allow:

HTTPS only
HTTPS and HTTP

For secure workloads:

HTTPS only should normally be preferred.

HTTPS protects data while it is transmitted between the client and Azure Storage.

15. SAS Security Principle

SAS provides delegated access, but SAS does not automatically mean secure access.

A poorly configured SAS could provide:

Excessive permissions
Excessively long expiration
Broad network access
More resource scope than necessary

Therefore:

Use the minimum permissions, minimum scope, minimum duration, and minimum network exposure required.

16. Microsoft Entra ID

Microsoft Entra ID provides identity-based authentication for Azure resources and applications.

For Azure-native workloads, Microsoft Entra ID can often provide stronger identity management than distributing storage account keys.

The conceptual model is:

User / Application
        |
        v
Microsoft Entra ID
        |
        v
Azure RBAC
        |
        v
Storage Data
17. Azure RBAC

Azure Role-Based Access Control determines what an identity can do.

RBAC follows the principle of least privilege.

Examples include:

Reader
Contributor
Owner
Storage Account Contributor
Storage Blob Data Reader
Storage Blob Data Contributor
Storage Blob Data Owner

The correct role depends on what the identity actually needs to do.

18. Management Plane vs Data Plane

This is one of the most important Azure concepts.

Management Plane

Controls the Azure resource itself.

Examples:

View the Storage Account
Modify configuration
Manage networking
Change resource settings

Examples of roles:

Reader
Contributor
Owner
Data Plane

Controls access to the actual storage data.

Examples:

Read blobs
Write blobs
Delete blobs
Manage blob data

Examples:

Storage Blob Data Reader
Storage Blob Data Contributor
Storage Blob Data Owner
19. Reader Does Not Automatically Mean Data Reader

A user may have:

Reader

on a Storage Account.

This allows the user to view the Azure resource.

It does not automatically mean:

Read blob contents

A data-plane role such as:

Storage Blob Data Reader

may be required to access blob data.

This distinction is critical when designing least-privilege Azure environments.

20. Storage Encryption

Azure Storage Service Encryption protects data at rest.

Azure encrypts data as it is stored in Azure datacenters and transparently decrypts it when authorized access occurs.

Conceptually:

Application
     |
     v
Azure Storage
     |
     v
Encryption at Rest
     |
     v
Encrypted Data

Storage Service Encryption provides baseline protection for stored data.

21. Microsoft-Managed Keys

Azure Storage can use Microsoft-managed encryption keys.

With Microsoft-managed keys:

Microsoft / Azure
       |
       v
Encryption Keys
       |
       v
Storage Encryption

Azure manages the key lifecycle.

This is the simpler option and is appropriate for many workloads.

22. Customer-Managed Keys

Azure Storage can also support customer-managed keys for supported scenarios.

Customer-managed keys provide greater control over encryption key management.

A common architecture is:

Organization
      |
      v
Azure Key Vault
      |
      v
Customer-Managed Key
      |
      v
Storage Encryption

Customer-managed keys introduce additional operational responsibilities.

These can include:

Key lifecycle management
Key rotation
Access control
Key availability
Monitoring

Customer-managed keys should be used when organizational, regulatory, or architectural requirements justify the additional complexity.

23. Infrastructure Encryption

Infrastructure encryption provides an additional layer of encryption for supported storage configurations.

Conceptually:

Data
 |
 v
Storage Service Encryption
 |
 v
Infrastructure Encryption
 |
 v
Azure Infrastructure

Infrastructure encryption is separate from the normal storage service encryption layer.

For this lab, infrastructure encryption was reviewed but not enabled.

24. Encryption in Transit

Encryption at rest protects stored data.

Encryption in transit protects data while it travels between systems.

Example:

Client
  |
  | HTTPS / TLS
  |
  v
Azure Storage

Secure transfer should be enabled so that supported requests use secure transport.

25. Secure Transfer Required

The Storage Account configuration includes:

Secure transfer required

When enabled, supported requests must use secure transport.

This helps prevent unencrypted communication with the storage service.

For secure production workloads:

Secure transfer should normally remain enabled.

26. TLS

Transport Layer Security protects communications between clients and Azure services.

The security model can be summarized as:

Data at Rest
     |
     v
Storage Encryption

Data in Transit
     |
     v
HTTPS / TLS

Both protections are important.

27. Defense in Depth

Storage security should not depend on one security mechanism.

A layered design may look like:

                Internet
                   |
            Network Controls
                   |
          Firewall / VNet Rules
                   |
          Private Connectivity
                   |
          Authentication
                   |
        Microsoft Entra ID / SAS
                   |
           Authorization
                   |
              Azure RBAC
                   |
             Encryption
                   |
             Storage Data

If one layer is misconfigured, other layers can still provide protection.

28. Least Privilege

Least privilege means giving an identity only the access it needs.

Bad example:

Application
    |
    v
Storage Account Access Key
    |
    v
Broad access

Better example:

Application
    |
    v
Microsoft Entra ID
    |
    v
Storage Blob Data Reader
    |
    v
Required blob data

Least privilege reduces the potential impact of compromised credentials.

29. Access Keys vs SAS vs Entra ID
Method	Scope	Duration	Main Use
Access Key	Broad	Long-lived until rotated	Application/storage authentication
SAS	Restricted	Time-limited	Delegated access
Entra ID + RBAC	Role-based	Identity controlled	Identity-based access

General preference:

Identity-based access
        |
        v
Microsoft Entra ID + RBAC
        |
        v
Use SAS when delegated access is required
        |
        v
Avoid distributing account keys when possible

The appropriate method depends on the application architecture and requirements.

30. Security Configuration Observed in Lab

During this lab, the following areas were reviewed:

Public network access
IP-based firewall restrictions
Network security perimeter
Storage security configuration
Access Control (IAM)
Azure RBAC
Storage access keys
SAS configuration
Storage encryption
Microsoft-managed keys
Customer-managed key option
Infrastructure encryption
Secure transfer
31. Important Security Lessons
Lesson 1

Network access and identity access are different security layers.

Lesson 2

Access Keys are powerful secrets and should be protected carefully.

Lesson 3

SAS provides delegated access but must be tightly scoped.

Lesson 4

Microsoft Entra ID and Azure RBAC provide identity-based authorization.

Lesson 5

Management-plane permissions and data-plane permissions are different.

Lesson 6

Encryption at rest protects stored data.

Lesson 7

HTTPS/TLS protects data in transit.

Lesson 8

Least privilege should be applied wherever possible.

Lesson 9

Security should use defense in depth.

32. Solution Architect Perspective

When designing an Azure Storage solution, security should be considered from multiple angles:

Who?
  |
  +---- Identity

What?
  |
  +---- Permissions

Where?
  |
  +---- Network restrictions

When?
  |
  +---- SAS expiration / credential lifecycle

How?
  |
  +---- HTTPS / TLS

How is data protected?
  |
  +---- Encryption

How is it monitored?
  |
  +---- Logging / monitoring

A strong architecture combines these controls rather than relying on one security feature.

33. Recommended Security Baseline

For a production-oriented Storage Account, consider:

Secure transfer enabled
Strong TLS configuration
Public network access restricted when practical
Firewall/network rules configured
Private endpoints when required
Microsoft Entra ID and RBAC
Least-privilege roles
Access keys protected and rotated
SAS tokens narrowly scoped
Short SAS lifetimes
Encryption at rest
Customer-managed keys when required
Monitoring and logging
Regular security review
34. Lab Summary

This lab demonstrated the major security controls available for Azure Storage.

The most important architectural lesson is:

Azure Storage security is a layered system combining network controls, identity, authorization, encryption, and secure data access.

The goal is not simply to enable every security feature.

The goal is to select the appropriate controls based on:

Business requirements
Data sensitivity
Compliance requirements
Application architecture
Network architecture
Operational complexity
Cost
35. Key AZ-104 Takeaways

Remember these concepts:

Network Security
    ↓
Who can reach the service?

Authentication
    ↓
Who are you?

Authorization
    ↓
What can you do?

Encryption
    ↓
How is the data protected?

SAS
    ↓
How can limited temporary access be delegated?

RBAC
    ↓
How can identity permissions be controlled?

Least Privilege
    ↓
How do we minimize unnecessary access?

Defense in Depth
    ↓
How do multiple controls work together?