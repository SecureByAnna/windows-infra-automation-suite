<#
.SYNOPSIS
    Collects inventory data from remote Windows machines.

.DESCRIPTION
    This script connects to one or more remote computers and collects system info:
    hostname, OS version, uptime, patch level, and domain membership.

.NOTES
    Author: SecureByAnna
    Date: $(Get-Date -Format "yyyy-MM-dd")
#>

param(
    [string[]]$ComputerName = @("localhost"),
    [string]$OutputPath = ".\reports\server_inventory.csv"
)

$results = foreach ($computer in $ComputerName) {
    try {
        $os = Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $computer
        $cs = Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName $computer

        [PSCustomObject]@{
            ComputerName = $computer
            OSVersion    = $os.Caption
            LastBoot     = $os.LastBootUpTime
            Uptime       = ((Get-Date) - $os.LastBootUpTime).Days
            Domain       = $cs.Domain
        }
    } catch {
        Write-Warning "Failed to connect to $computer: $_"
    }
}

# Create folders if needed
if (-not (Test-Path ".\reports")) { New-Item -ItemType Directory -Path ".\reports" }

# Export report
$results | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8

Write-Host "`nInventory report saved to $OutputPath" -ForegroundColor Green
