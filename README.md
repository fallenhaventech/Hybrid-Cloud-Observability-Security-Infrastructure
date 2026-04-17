<img width="1580" height="850" alt="topology2" src="https://github.com/user-attachments/assets/75f824f8-60fd-435b-b8f1-717d97f2c2f2" />

# Hybrid-Cloud Observability & Security Lab
### Enterprise Monitoring of a Hybrid Environment (VMware On-Prem + Microsoft Azure)

## 📌 Project Overview
This project demonstrates the implementation of a secure, enterprise-grade monitoring ecosystem. It bridges the gap between **on-premise infrastructure (VMware)** and **public cloud (Microsoft Azure)**, providing a "Single Pane of Glass" view for infrastructure health, security logs, and performance metrics.

The lab was built to apply concepts from **AZ-104 (Azure Administrator)**, **ISC2 Certified in Cybersecurity (CC)**, and **Fortinet NSE** certifications.

---

## 🏗️ Architecture & Topology
- **On-Premise (VMware Workstation):** 
    - **Gateway:** pfSense (FreeBSD-based Firewall).
    - **Servers:** Windows Server 2022, Windows Server 2025, and AlmaLinux (RHEL-based).
    - **Monitoring Core:** Zabbix 8.0 (Alpha) running on AlmaLinux.
- **Cloud (Microsoft Azure):**
    - **Integration:** Agentless monitoring via Azure Monitor API.
    - **Security:** Managed via Entra ID (Service Principals) and RBAC.
    - **Networking:** Virtual Networks (VNet) with segmented subnets.

---

## 🛠️ Tech Stack
*   **Observability:** Zabbix (Primary), Azure Monitor API.
*   **Security:** pfSense (Stateful Firewall), Entra ID (IAM/RBAC), Least Privilege principles.
*   **Infrastructure:** VMware Workstation, Microsoft Azure.
*   **Automation/OS:** PowerShell, Bash, Windows Server, Linux (AlmaLinux/Ubuntu).

---

## 🔐 Key Engineering Features

### 1. Hybrid Observability (Cloud + Local)
Successfully integrated the on-premise Zabbix server with the **Azure API** using a **Service Principal**. 
*   Implemented **OAuth 2.0** authentication.
*   Configured **RBAC (Role-Based Access Control)** by assigning the `Reader` role to the monitoring app, ensuring security through the principle of least privilege.

### 2. Infrastructure Resilience (Self-Healing)
To ensure high availability of the monitoring data, I implemented a **Service Watchdog** on the pfSense gateway. This automated system monitors the Zabbix Agent daemon and triggers an automatic restart upon service failure, reducing "Toil" and manual intervention.

### 3. Network Security & Firewall Hardening
Configured advanced **Stateful Inspection** rules on the pfSense firewall:
*   Restricted Zabbix Agent communication (TCP/10050) to the specific Management IP.
*   Optimized traffic flow by correctly mapping **Source vs. Destination** ports, accounting for ephemeral port ranges.

---

## 🛠️ Troubleshooting Log (Demonstrating Analytical Skills)
One of the main goals of this lab was to solve real-world connectivity issues:

| Error Detected | Technical Root Cause | Resolution |
| :--- | :--- | :--- |
| `[111] Connection Refused` | Daemon service stopped or wrong Listen IP. | Configured `ListenIP=0.0.0.0` and enabled Service Watchdog. |
| `[104] Connection Reset` | Application-level ACL rejection. | Updated `zabbix_agent2.conf` with authorized Server IPs. |
| `Connection Timeout` | Firewall dropping packets (Layer 4). | Created Inbound Allow rules on pfSense and Windows Firewall. |

---

## 🚀 Automation Snippets
### Windows Agent Deployment (PowerShell)
```powershell
# Silent installation and firewall configuration
$ZabbixServerIP = "192.168.100.247"
Invoke-WebRequest -Uri "https://cdn.zabbix.com/zabbix/binaries/stable/6.4/6.4.15/zabbix_agent2-6.4.15-windows-amd64-openssl.msi" -OutFile "C:\zabbix_agent2.msi"
Start-Process msiexec.exe -ArgumentList "/i C:\zabbix_agent2.msi /qn SERVER=$ZabbixServerIP HOSTNAME=$($env:COMPUTERNAME)" -Wait
New-NetFirewallRule -DisplayName "Zabbix" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 10050
```

---

## 📈 Final Results

The final dashboard shows 100% availability across all hybrid assets, including real-time telemetry from Azure subscriptions and local virtualized servers.

<img width="1897" height="607" alt="image" src="https://github.com/user-attachments/assets/027b4438-555b-4865-876a-cb8858c1fabb" />

---

<img width="2559" height="1091" alt="image" src="https://github.com/user-attachments/assets/d41d8ee6-0059-4461-b8e6-3d63e0878419" />



---
