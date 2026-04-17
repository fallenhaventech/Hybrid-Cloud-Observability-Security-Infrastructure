<#
.SYNOPSIS
    Automated installation and configuration of Zabbix Agent 2 for Windows.
    
.DESCRIPTION
    This script downloads the Zabbix Agent 2 MSI, performs a silent installation 
    configured to point to a specific Zabbix Server, and creates the necessary 
    Windows Firewall rules.

.PARAMETER ZabbixServer
    The IP address or DNS of your Zabbix Server. Default is 192.168.100.247.

.EXAMPLE
    .\Install-ZabbixAgent.ps1 -ZabbixServer "192.168.100.247"
#>

Param(
    [string]$ZabbixServer = "192.168.100.247"
)

$AgentDownloadUrl = "https://cdn.zabbix.com/zabbix/binaries/stable/6.4/6.4.15/zabbix_agent2-6.4.15-windows-amd64-openssl.msi"
$MsiPath = "$env:TEMP\zabbix_agent2.msi"

Write-Host "--- Starting Zabbix Agent 2 Deployment ---" -ForegroundColor Cyan

# 1. Force TLS 1.2 for secure downloads (Best practice for older Windows Server versions)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# 2. Download the MSI
try {
    Write-Host "[1/4] Downloading Zabbix Agent 2 MSI..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $AgentDownloadUrl -OutFile $MsiPath -ErrorAction Stop
} catch {
    Write-Error "Failed to download MSI. Check internet connection or URL. Error: $_"
    exit
}

# 3. Silent Installation
try {
    Write-Host "[2/4] Installing Zabbix Agent 2 silently..." -ForegroundColor Yellow
    $MSIArguments = @(
        "/i", "`"$MsiPath`"",
        "/qn",
        "SERVER=$ZabbixServer",
        "SERVERACTIVE=$ZabbixServer",
        "HOSTNAME=$($env:COMPUTERNAME)",
        "ENABLEPATH=1"
    )
    Start-Process msiexec.exe -ArgumentList $MSIArguments -Wait -ErrorAction Stop
    Write-Host "Installation completed successfully." -ForegroundColor Green
} catch {
    Write-Error "Installation failed. Error: $_"
    exit
}

# 4. Configure Windows Firewall
try {
    Write-Host "[3/4] Configuring Windows Firewall (Port 10050)..." -ForegroundColor Yellow
    if (!(Get-NetFirewallRule -DisplayName "Zabbix Agent Monitoring" -ErrorAction SilentlyContinue)) {
        New-NetFirewallRule -DisplayName "Zabbix Agent Monitoring" `
                            -Direction Inbound `
                            -Action Allow `
                            -Protocol TCP `
                            -LocalPort 10050 `
                            -Description "Allow Zabbix Server to pull metrics"
        Write-Host "Firewall rule created." -ForegroundColor Green
    } else {
        Write-Host "Firewall rule already exists." -ForegroundColor Gray
    }
} catch {
    Write-Warning "Could not configure Firewall automatically. Please check manually."
}

# 5. Service Validation
Write-Host "[4/4] Validating Service Status..." -ForegroundColor Yellow
$Service = Get-Service "Zabbix Agent 2" -ErrorAction SilentlyContinue
if ($Service.Status -eq "Running") {
    Write-Host "Zabbix Agent 2 is UP and RUNNING." -ForegroundColor Green
} else {
    Write-Host "Service found but status is $($Service.Status). Starting service..." -ForegroundColor Cyan
    Start-Service "Zabbix Agent 2"
}

# Cleanup
if (Test-Path $MsiPath) { Remove-Item $MsiPath }

Write-Host "--- Deployment Finished! ---" -ForegroundColor Cyan