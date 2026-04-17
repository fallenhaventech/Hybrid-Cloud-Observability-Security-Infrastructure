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