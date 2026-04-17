# Troubleshooting & Incident Resolution Log

During the deployment of this lab, several connectivity and application-level issues were identified and resolved. This log serves as a technical knowledge base.

## 🔴 Issue 1: Connection Refused [111] on pfSense
- **Symptom:** Zabbix dashboard showed the pfSense host as "Not Available".
- **Diagnosis:** Running `systemctl status` confirmed the agent was down. Further inspection revealed the "Listen IP" was set to `127.0.0.1`.
- **Resolution:** Updated the configuration to `0.0.0.0` to allow external requests and implemented the **Service Watchdog** package to automatically restart the service upon failure.

## 🔴 Issue 2: Connection Reset by Peer [104] on Windows
- **Symptom:** TCP connection established but immediately closed by the Windows host.
- **Diagnosis:** Identified as an ACL (Access Control List) issue within the `zabbix_agent2.conf` file.
- **Resolution:** Corrected the `Server=` and `ServerActive=` parameters to include the Zabbix Server IP (`192.168.100.247`).

## 🔴 Issue 3: Invalid Source/Destination Port Logic
- **Symptom:** Firewall rules were active but traffic was still blocked.
- **Diagnosis:** The rule was incorrectly configured with Source Port `10050`. 
- **Learning:** Recalled TCP fundamentals: Source ports are ephemeral (random high ports), while Destination ports are fixed for services. 
- **Resolution:** Reconfigured the rule to `Source: Any` -> `Destination Port: 10050`.

## 🔴 Issue 4: Azure API Parameter Missing (app_id)
- **Symptom:** Zabbix failed to discover Azure resources.
- **Diagnosis:** The Zabbix 8.0 template required specific Macro naming conventions.
- **Resolution:** Renamed host macros to `{$AZURE.APP.ID}`, `{$AZURE.SECRET}`, etc., ensuring the JavaScript engine could correctly authenticate via OAuth 2.0.

## 🔴 Issue 5: Global Script Execution Disabled
- **Symptom:** Unable to execute "Ping" or "Traceroute" from the Zabbix Frontend. Error: "Global script execution on Zabbix server is disabled".
- **Technical Context (Security):** Modern Zabbix versions disable this feature by default to minimize the Attack Surface and prevent unauthorized Command Injection.
- **Resolution:** Modified zabbix_server.conf to set EnableGlobalScripts=1.
- **Hardening Consideration:** In a production environment, instead of enabling this globally, it is recommended to use Zabbix RBAC to restrict who can execute these scripts, ensuring that only authenticated Administrators can trigger OS-level commands through the UI.

## 🔴 Issue 6: Azure API Authentication - Missing Param app_id
- **Symptom:** Zabbix failed to poll Azure Monitor with error Required param is not set: app_id.
- **Technical Analysis:** The JavaScript-based HTTP collector in Zabbix 8.0 maps internal variables to specific Host Macros. A mismatch in the macro naming convention (. vs _) causes the authentication payload to be malformed.
- **Resolution:** Standardized macros to the template-required format ({$AZURE.APP.ID}). Validated the fix using the "Execute Now" feature to verify successful OAuth 2.0 token acquisition from login.microsoftonline.com.

## 🔴 Issue 7: SSH Permission Denied (publickey)
- **Symptom:** Unable to access the Azure VM via SSH. Error: Permission denied (publickey).
- **Root Cause:** Azure Linux VMs default to Key-Based Authentication. Attempting to login via password or incorrect username (e.g., administrator on an Ubuntu image) results in a failed handshake.
- **Resolution:** Used the Azure Reset Password extension to enforce a password-based authentication policy and verified the correct administrative username. In a production environment, this would be mitigated by using Azure Bastion or Just-In-Time (JIT) VM Access to enhance security.
