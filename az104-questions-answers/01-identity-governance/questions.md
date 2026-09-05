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

---

## Question 21
Three subscriptions exist: Production, Development, and Security. Developers should be able to create and manage resources only in Development, but they must not assign RBAC roles. The Security team manages RBAC across all three subscriptions. What roles and scopes should be used?

### SME Answer
Assign Contributor to developers at the Development subscription scope. Assign an appropriate access-management role such as User Access Administrator to the Security team at the subscription scope across the required subscriptions. Developers need resource-management capability but not access-management capability. This follows least privilege.

---

## Question 22
A developer has Contributor on a Production resource group and Reader at subscription scope. The developer can manage the Storage Account but receives AuthorizationPermissionMismatch when downloading a blob. What is the likely cause?

### SME Answer
Contributor and Reader provide management-plane permissions but do not automatically provide blob data access. Downloading a blob is a data-plane operation. Assign Storage Blob Data Reader at the smallest required scope, such as the required container scope if only one container is needed.

---

## Question 23
An organization has 50 Azure VMs. Users should sign in to the Windows VMs using Microsoft Entra ID instead of local administrator passwords. VM administrators need administrative OS access, while regular developers need normal OS sign-in. Developers must not receive Azure resource-management permissions. What design should be used?

### SME Answer
Use Microsoft Entra ID VM login integration. Assign Virtual Machine User Login to regular developers and Virtual Machine Administrator Login to administrators. Use Microsoft Entra security groups for centralized role assignment. Do not use Contributor for developers because Azure resource management and guest OS login are different authorization requirements.

---

## Question 24
An App Service uses a user-assigned managed identity to read secrets from Key Vault. The App Service is deleted and recreated. The new App Service obtains an Entra token but Key Vault returns 403. What should be investigated?

### SME Answer
First verify that the original user-assigned managed identity is attached to the recreated App Service and that the application is using the intended identity. Then verify the identity's principal ID, Key Vault data-plane role such as Key Vault Secrets User, assignment scope, Key Vault access-control model, and applicable network restrictions. Successful token acquisition indicates authentication is working; the 403 requires authorization investigation.

---

## Question 25
An administrator assigns Contributor to a developer at resource-group scope. The developer can start, stop, resize, create, and delete VMs but cannot assign Reader to another user. Why?

### SME Answer
Contributor provides Azure resource-management permissions but does not include Microsoft.Authorization/roleAssignments/write. Therefore the developer can manage resources but cannot create RBAC role assignments. If access management is genuinely required, User Access Administrator can be assigned at the smallest necessary scope. Owner would provide broader permissions than necessary.

---

## Question 26
A developer has Contributor on an Azure VM and Reader at subscription scope. The developer can manage the VM resource but cannot sign in to the Windows guest OS using Microsoft Entra ID. Why?

### SME Answer
Contributor manages the Azure VM resource but does not grant guest OS login. Microsoft Entra VM login requires the appropriate Azure RBAC role: Virtual Machine User Login for normal users or Virtual Machine Administrator Login for administrative OS access.

---

## Question 27
An App Service has Contributor on a Storage Account but no Storage data-plane role. It can configure the Storage Account and create containers, but downloading a blob returns AuthorizationPermissionMismatch. What role is required?

### SME Answer
Downloading a blob is a data-plane operation. Contributor provides resource-management permissions but does not automatically provide blob data access. Assign Storage Blob Data Reader for read-only blob access. If access is needed only to one container, assign the role at that container scope.

---

## Question 28
A developer has Contributor on rg-development and Reader at subscription scope. The developer attempts to assign Reader to another user on rg-development and receives AuthorizationFailed. What permission is missing?

### SME Answer
The developer lacks Microsoft.Authorization/roleAssignments/write. Contributor allows resource management but does not include Azure RBAC access-management permissions. If the developer genuinely needs to assign roles, User Access Administrator can be assigned at resource-group scope rather than granting broader Owner access.

---

## Question 29
An App Service uses a user-assigned managed identity named app-prod-identity. The original App Service is deleted. A new App Service with the same application name is created, and the developer says the existing UAMI should automatically be attached because it has the same name. Is that correct?

### SME Answer
No. A user-assigned managed identity has an independent lifecycle and survives deletion of the App Service, but the new App Service does not automatically have that identity attached. Verify the UAMI attachment first, then verify the identity's principal/client ID and its RBAC permissions and scope. The name of the App Service does not prove that the same identity configuration was restored.

---

## Question 30
An organization has 100 Azure VMs, 90 developers, and 10 administrators. Developers need to sign in to the guest OS but must not manage Azure VM resources. Administrators need administrative OS access. Security wants centralized access management. What architecture should be used?

### SME Answer
Use Microsoft Entra security groups with Azure RBAC. Assign Virtual Machine User Login to the developer group and Virtual Machine Administrator Login to the administrator group at the appropriate VM or resource-group scope. Do not give developers Contributor because they only require guest OS login, not Azure resource management.

Mental model:

Azure VM
    |
    +-- Azure Resource Management
    |       |
    |       +-- Contributor
    |       +-- Start / Stop / Resize / Delete
    |
    +-- Guest OS Login
            |
            +-- Virtual Machine User Login
            +-- Virtual Machine Administrator Login
