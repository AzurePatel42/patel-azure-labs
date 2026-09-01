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
