# This script retrieves and displays the current Named Domain User along with key network configuration details from the primary IPv4-enabled network adapter, including IP address, DHCP server, default gateway, and DNS servers.
# It uses WMI to access network adapter configuration for compatibility and completeness.
# This script also displays all of the information in a neat format compared to traditional output. 

# Retrieve the Named Domain User
$NDU = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

# Retrieve network adapter configurations and filter for the first IPv4-enabled adapter
$netConfigs = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }
$netConfig = $netConfigs | Where-Object { $_.IPAddress -match '\.' } | Select-Object -First 1

# Extract IPv4 address (filtering for IPv4 format)
$ipv4Address = ($netConfig.IPAddress | Where-Object { $_ -match '^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$' }) -join ', '

# Extract DHCP server IP
$dhcpServer = $netConfig.DHCPServer

# Extract default gateway IP (IPv4)
$gateway = ($netConfig.DefaultIPGateway | Where-Object { $_ -match '^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$' }) -join ', '

# Extract DNS server IPs (joined as comma-separated string)
$dnsServers = $netConfig.DNSServerSearchOrder -join ', '

# Build a single object for table output
$result = [PSCustomObject]@{
    'Named Domain User' = $NDU
    'IPv4 Address'      = $ipv4address
    'DHCP Server IP'    = $dhcpServer
    'Default Gateway'   = $gateway
    'DNS Servers'       = $dnsServers
}

# Display as formatted table
$result | Format-Table -AutoSize
