# Hybrid-Cloud Infrastructure Architecture

## 🟢 Design Goals
The goal of this architecture is to simulate a real-world enterprise environment where on-premises workloads are integrated with public cloud resources under a unified monitoring umbrella.

## 🏗️ Components

### 1. On-Premises (VMware Workstation)
- **Management Subnet (192.168.100.0/24):** Dedicated to infrastructure management (Zabbix, pfSense LAN, Server Management).
- **Core Monitoring:** Zabbix 8.0 Alpha running on AlmaLinux 9. This server acts as the central collector for all telemetry.
- **Security Gateway:** pfSense Firewall managing traffic between subnets and providing local security services.
- **Workloads:** 
    - Windows Server 2025 (Active Directory/Lab services)
    - Windows Server 2022 (Application server simulation)

### 2. Public Cloud (Microsoft Azure)
- **VNet:** `vnet-hybrid-lab` (10.0.0.0/16)
- **Segmentation:** Dedicated subnets for Workloads, Azure Bastion, and Gateway services.
- **API Integration:** Agentless monitoring using Azure Monitor API via a dedicated Service Principal.

## 📡 Connectivity
- **Local Monitoring:** Uses Zabbix Agent 2 (TCP/10050) with specific ACLs to ensure only the Zabbix Server can pull data.
- **Cloud Monitoring:** Uses HTTPS (Port 443) to poll Azure Metadata and Monitor APIs.
- **Network Topology:** (Refer to `docs/images/hybrid-topology.png` for a visual representation).