# Troubleshooting & Knowledge Base

This document records technical issues, common pitfalls, root causes, and verified solutions encountered during the implementation and operation of the Enterprise MLOps Platform.

---

## 🔍 Issue Log Index

| ID | Category | Component | Issue Description | Status |
| :--- | :--- | :--- | :--- | :--- |
| **KB-001** | Terraform | Backend State | State locking failure during concurrent runs | Documented |
| **KB-002** | Networking | Private DNS | Azure ML Studio UI failing to load over Private Endpoint | Documented |
| **KB-003** | Azure ML | Compute Cluster | Cluster stuck in `Creating` or `Resize` state due to quota | Documented |
| **KB-004** | Security | RBAC | Data Scientist unable to submit job due to missing Action | Documented |
| **KB-005** | Pipeline | Azure DevOps | Service Connection lacks permission on Azure ML Registry | Documented |
| **KB-006** | Billing/ARM | Subscription | `ReadOnlyDisabledSubscription`: Subscription in Warned/Read-Only state | Documented |
| **KB-007** | Azure ML | Registry/Endpoints | AzAPI provider required for Azure ML Registry and Online Endpoints | Documented |

---

## 🛠️ Detailed Solutions & Fixes

### KB-001: State Locking Failure During Concurrent Runs
- **Symptom**: `Error: Error acquiring the state lock: blob.StorageError...`
- **Root Cause**: A previous `terraform apply` was interrupted or terminated abruptly without releasing the Azure Blob storage lease.
- **Resolution**:
  ```powershell
  # Check if lease is active
  az storage blob show --account-name <storage_account> --container-name tfstate --name <env>.tfstate --query "properties.lease.status"

  # Break lease if confirmed orphaned
  az storage blob lease break --account-name <storage_account> --container-name tfstate --blob-name <env>.tfstate
  ```

---

### KB-002: Azure ML Studio UI Failing to Load over Private Link
- **Symptom**: Data scientist gets `ERR_NAME_NOT_RESOLVED` when opening `ml.azure.com` inside the corporate network.
- **Root Cause**: Missing Private DNS zone `privatelink.notebooks.azure.net` or `privatelink.api.azureml.ms` not linked to the client's VNet.
- **Resolution**: Ensure both Private DNS Zones exist and have a Virtual Network Link (`azurerm_private_dns_zone_virtual_network_link`) to the Hub and Spoke VNets.

---

### KB-003: Compute Cluster Stuck in Resize / Quota Exceeded
- **Symptom**: Azure ML compute cluster nodes remain at 0 or throw `QuotaExceeded` error when spinning up.
- **Root Cause**: The Azure subscription default quota for specific VM families (e.g. `Standard_DS3_v2` or GPU `Standard_NC6s_v3`) is set to 0 in that region.
- **Resolution**:
  1. Check quota: `az vm list-usage --location eastus -o table`
  2. Switch to a VM family with available cores (e.g. `Standard_DS2_v2` or `Standard_D4s_v3` for POC).
  3. Submit a quota increase request via Azure Portal if GPU is strictly needed.

---

### KB-004: Data Scientist Missing Permissions for Job Submission
- **Symptom**: `AuthorizationFailed: The client does not have authorization to perform action 'Microsoft.MachineLearningServices/workspaces/computes/listKeys/action'`.
- **Root Cause**: Custom Data Scientist RBAC role lacked compute key listing or run submission permissions.
- **Resolution**: Ensure the custom RBAC role includes `Microsoft.MachineLearningServices/workspaces/computes/*/read` and `Microsoft.MachineLearningServices/workspaces/experiments/runs/write`.

---

### KB-005: Azure DevOps Service Connection Lacks Permissions on Azure ML Registry
- **Symptom**: CI pipeline fails at step `az ml model create --registry-name shared-registry` with `Forbidden`.
- **Root Cause**: The Azure DevOps Service Principal / Managed Identity has Contributor on the Team workspace, but lacks permissions on the Shared Subscription Azure ML Registry.
- **Resolution**: Grant the Azure DevOps Service Principal `AzureML Data Scientist` or `Contributor` role at the **Shared Platform Resource Group** scope where the registry resides.

---

### KB-006: ReadOnlyDisabledSubscription (Spending Limit Reached / Free Trial Expired)
- **Symptom**: `unexpected status 409 (409 Conflict) with error: ReadOnlyDisabledSubscription: The subscription '...' is disabled and therefore marked as read only. You cannot perform any write actions on this subscription until it is re-enabled.`
- **Root Cause**: The Azure subscription policy has `spendingLimit: "On"` (default on Free Trial accounts) and entered `Warned` state when trial credit reached zero or expired. All ARM write operations (`PUT`, `POST`, `PATCH`, `DELETE`) are rejected by the Azure control plane.
- **Resolution**:
  1. Open [Azure Portal - Subscriptions](https://portal.azure.com/#view/Microsoft_Azure_Billing/SubscriptionsBlade).
  2. Select the affected subscription (`Azure subscription 1`).
  3. Click **Remove spending limit** banner or upgrade to **Pay-As-You-Go** (keeps existing free resources and unlocks write actions).
  4. Once state transitions from `Warned` back to `Active`, re-run `terraform apply`.

---

### KB-007: Azure ML Registry and Online Endpoints Provider Compatibility
- **Symptom**: Terraform `azurerm` provider fails to manage `Microsoft.MachineLearningServices/registries` or `onlineEndpoints`.
- **Root Cause**: `azurerm` v3.x does not provide native HCL resources for Azure ML Registries or Managed Online Endpoints; attempts to pass custom pre-existing storage accounts trigger ARM 400 Bad Request.
- **Resolution**:
  1. Use Microsoft `azure/azapi` provider (`azapi_resource`).
  2. For Registries, define `systemCreatedStorageAccount` (`Standard_LRS`) and `systemCreatedAcrAccount` (`Premium`) under `regionDetails`.
  3. For Online Endpoints, use resource type `Microsoft.MachineLearningServices/workspaces/onlineEndpoints@2024-04-01-preview` with `authMode: "Key"`.
