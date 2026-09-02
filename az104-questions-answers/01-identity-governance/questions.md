# AZ-104 Identity & Governance - Questions

## Question 1
What is Microsoft Entra ID, and what problem does it solve?

### SME Answer
Microsoft Entra ID is Azure's cloud-based identity and access management service. It provides centralized identity management and authentication for users, applications, and workloads.

---

## Question 2
What is the difference between Microsoft Entra ID and Azure RBAC?

### SME Answer
Microsoft Entra ID handles identity and authentication. Azure RBAC handles authorization to Azure resources by assigning roles with specific permissions at a defined scope.

---

## Question 3
What are the classic built-in Azure RBAC roles?

### SME Answer
Reader provides read-only access, Contributor can manage Azure resources but cannot assign RBAC roles, and Owner has full resource management and access-management capability.

---

## Question 4
A developer needs to deploy and manage resources only inside rg-app-prod but must not grant permissions. What role and scope should be used?

### SME Answer
Assign Contributor at the rg-app-prod resource-group scope. This allows resource management within the resource group without allowing RBAC role assignment.

---

## Question 5
A developer has Contributor but cannot assign Reader access to another developer. Is Azure RBAC broken?

### SME Answer
No. Contributor can manage resources but does not include Microsoft.Authorization/roleAssignments/write, so the failure is expected.

---

## Question 6
Developers need to manage resources but must never manage user access. Should User Access Administrator be assigned?

### SME Answer
No. User Access Administrator is an access-management role. Contributor is the appropriate role when the requirement is resource management without access management.

---

## Question 7
A developer with Contributor wants to give another developer Reader access. What is happening?

### SME Answer
Contributor does not include permission to create RBAC role assignments. If access management is genuinely required, an appropriate access-management role should be granted at the smallest necessary scope.

---

## Question 8
Azure returns Microsoft.Authorization/roleAssignments/write when a developer tries to assign Reader. What does this mean?

### SME Answer
The caller lacks the permission required to create an RBAC role assignment. I would first check the caller's effective role assignments and scopes.

---

## Question 9
A user has Reader at subscription scope but only wanted access to rg-app-prod. Is the behavior expected?

### SME Answer
Yes. A role assigned at subscription scope is inherited by child resource groups and resources. Move the Reader assignment to rg-app-prod to limit access to that resource group and its resources.

---

## Question 10
A user has Reader on rg-app-prod but cannot read blobs in a storage account. Why?

### SME Answer
Reader is a management-plane role and does not by itself provide blob data access. For Microsoft Entra-based blob access, the user also needs an appropriate data-plane role such as Storage Blob Data Reader.

---

## Question 11
A VM must retrieve a secret from Azure Key Vault without storing a username, password, client secret, or certificate. What Azure feature should be used?

### SME Answer
Enable a managed identity on the VM and authorize that identity to access Key Vault. The managed identity provides passwordless workload authentication, while Key Vault stores and protects the secret.

---

## Question 12
Twenty VMs need to access the same Key Vault using the same workload identity. You want to avoid creating and managing a separate identity for every VM. Which managed identity type is appropriate?

### SME Answer
Use a user-assigned managed identity. A user-assigned managed identity is an independent Azure resource that can be attached to multiple VMs and can share the required Key Vault permissions.

---

## Question 13
One hundred VMs must each have their own unique identity and permissions. Each identity should automatically disappear when its VM is deleted. Which identity type should be used?

### SME Answer
Use a system-assigned managed identity. It is tied to the lifecycle of the Azure resource, so deleting the VM also deletes its system-assigned identity.

---

## Question 14
Ten App Service applications need to use the same identity for Key Vault access, and the identity must survive replacement of individual applications. Which identity type should be used?

### SME Answer
Use a user-assigned managed identity. It has an independent lifecycle, can be shared by multiple Azure resources, and is not automatically deleted when an individual App Service application is replaced.

---

## Question 15
An App Service used a user-assigned managed identity to access Key Vault. The application was deleted and recreated with the same name, but now Key Vault returns 403. What should you investigate?

### SME Answer
Verify that the recreated App Service has the original user-assigned managed identity attached and that the application is actually using that identity. Also verify the identity's principal ID, Key Vault role assignment, scope, and access configuration. Recreating an App Service with the same name does not automatically restore the previous user-assigned identity attachment.

---

## Question 16
An App Service has a user-assigned managed identity. Token acquisition succeeds, but requests to Key Vault return HTTP 403. What does this indicate?

### SME Answer
Successful token acquisition indicates that authentication is working. The next investigation should focus on authorization. Verify the identity being used, its Key Vault data-plane role, the assignment scope, the vault's access-control model, and any applicable network restrictions. For reading secret contents, a role such as Key Vault Secrets User may be appropriate.

---

## Question 17
An App Service system-assigned managed identity has Reader on a Storage Account but receives 403 when downloading blobs. Why?

### SME Answer
Reader is a management-plane role and does not provide blob data access. The managed identity needs an appropriate Storage data-plane role such as Storage Blob Data Reader to read blob contents.

---

## Question 18
An App Service must read blobs only from container-a in a Storage Account containing container-a, container-b, and container-c. What role and scope should be used?

### SME Answer
Assign Storage Blob Data Reader to the application's identity at the container-a scope. This follows least privilege by granting only the required data operation and limiting the assignment to the required container.

---

## Question 19
A user has Contributor at resource-group scope but no direct role assignment on a VM inside that resource group. Can the user manage the VM?

### SME Answer
Yes. Azure RBAC assignments are inherited by child scopes. Contributor assigned at the resource-group scope applies to resources inside that resource group, including the VM.

---

## Question 20
A developer has Contributor at resource-group scope and can create, modify, and delete resources, but cannot assign Reader to another user. Azure reports Microsoft.Authorization/roleAssignments/write. Why?

### SME Answer
Contributor permits resource management but does not include permission to create Azure RBAC role assignments. Microsoft.Authorization/roleAssignments/write is required for that operation. If the developer genuinely requires access-management responsibility, an appropriate role such as User Access Administrator or Owner should be assigned at the smallest necessary scope.
