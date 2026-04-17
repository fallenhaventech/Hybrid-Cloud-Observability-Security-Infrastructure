# pfSense Gateway Configuration

This document outlines the network security and monitoring configuration for the pfSense firewall, acting as the primary gateway for the on-premises VMware environment.

## 🟢 Roles & Responsibilities
- **Gateway IP:** `192.168.100.254` (Management/LAN)
- **Primary Function:** Network segmentation, security filtering, and hybrid-link termination.
- **Monitoring:** Integrated via Zabbix Agent 6 to provide telemetry on traffic, CPU usage, and system health.

---

## 🛠️ Installed Packages
To enhance the observability and resilience of the gateway, the following packages were installed via the Package Manager:
1.  **Zabbix Agent 6:** For telemetry extraction.
2.  **Service Watchdog:** To ensure high availability of critical services.

---

## 📊 Zabbix Agent Configuration
The agent was configured to allow the Zabbix Server to pull metrics securely.
- **Enable:** Checked
- **Server:** `192.168.100.247`
- **Server Active:** `192.168.100.247`
- **Hostname:** `pfSense-Gateway`
- **Listen IP:** `0.0.0.0` (Listen on all interfaces)
- **Listen Port:** `10050`

---

## 🔒 Firewall Rules (Security Hardening)
A specific **Inbound Pass Rule** was implemented on the LAN interface to follow the principle of **Least Privilege**.

| Action | Interface | Protocol | Source | Destination | Dest. Port | Description |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Pass** | LAN | TCP | `192.168.100.247` (Zabbix) | LAN Address | 10050 | Allow Zabbix Monitoring |

### 💡 Key Technical Note (Troubleshooting)
During the initial setup, a common "Source/Destination" port conflict was identified. The rule was hardened by:
1.  Setting the **Source Port** to `any` (allowing for ephemeral ports used by the Zabbix Server).
2.  Setting the **Destination Port** strictly to `10050` (the Agent's listening port).
This ensures that only the authorized monitoring server can initiate a connection to the gateway.

---

## 🛡️ Service Resilience (Self-Healing)
To mitigate "Service Flapping" and ensure 24/7 observability, the **Service Watchdog** was configured.
- **Monitored Service:** `zabbix_agentd`
- **Action:** Automatic restart upon service failure detection.
- **Outcome:** Zero-touch maintenance for the monitoring daemon, ensuring consistent telemetry flow for the SOC (Security Operations Center) dashboard.

---

## 🚀 Security Hardening (Compliance)
Following **ISC2 CC** best practices:
- **Default Credentials:** Removed. Admin passwords were changed immediately upon provisioning.
- **Management Isolation:** The web interface is restricted to the internal management network, preventing exposure to the WAN.