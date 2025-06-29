<#
.SYNOPSIS
    Monitors Windows services on remote machines.

.DESCRIPTION
    This script checks each specified computer for services that are
    not running (Stopped or Paused). Optionally restarts them and logs results.

.NOTES
    Author: SecureByAnna
    Date: $(Get-Date -Format "yyyy-MM-dd")
#>

param(
    [string[]]$ComputerName = @("localhost"),
    [string]$OutputPath = ".\reports\stopped_services_report.csv",
    [switch]$RestartStopped
)

# Ensure reports folder exists
if (-not (Test-Path ".\reports")) { New-Item -ItemType Directory -Path ".\reports" }

$report = @()

foreach ($computer in $ComputerName) {
    try {
        $services = Get-Service -ComputerName $computer | Where-Object { $_.Status -ne 'Running' }

        foreach ($svc in $services) {
            $entry = [PSCustomObject]@{
                ComputerName = $computer
                ServiceName  = $svc.Name
                DisplayName  = $svc.DisplayName
                Status       = $svc.Status
            }
            $report += $entry

            if ($RestartStopped -and $svc.Status -eq 'Stopped') {
                try {
                    Start-Service -Name $svc.Name -ComputerName $computer
                    Write-Host "Restarted: $($svc.Name) on $computer" -ForegroundColor Green
                } catch {
                    Write-Warning "Failed to restart $($svc.Name) on $computer: $_"
                }
            }
        }
    } catch {
        Write-Warning "Failed to query $computer: $_"
    }
}

$report | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8
Write-Host "`nStopped services report saved to $OutputPath" -ForegroundColor Cyan