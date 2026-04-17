# Azure Cloud Integration & Identity Management

## 🔐 Security First Approach
Instead of using personal credentials, this lab utilizes **Identity & Access Management (IAM)** best practices.

### 1. App Registration (Service Principal)
A dedicated Service Principal named `Zabbix-Monitor` was created in **Microsoft Entra ID**. 
- **Authentication:** Client Secret with a 6-month rotation policy.
- **Scope:** Restricted to the specific Lab Subscription.

### 2. Role-Based Access Control (RBAC)
Following the **Principle of Least Privilege (PoLP)**, the application was assigned the **Reader** role.
- **Why?** The monitoring system only needs to "read" metrics and metadata; it should never have "Contributor" or "Owner" rights to modify infrastructure.

## 📈 Monitoring Methodology
The Zabbix Server performs agentless monitoring by querying the following Azure endpoints:
1. `management.azure.com` (Resource Metadata)
2. `login.microsoftonline.com` (OAuth 2.0 Token generation)

## 🚀 Key Results
- Auto-discovery of Virtual Machines, VNets, and Storage Accounts.
- Real-time visualization of Azure consumption and health within the on-premise dashboard.