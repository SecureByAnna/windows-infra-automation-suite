<#
.SYNOPSIS
    Monitors Windows services on remote machines.

.DESCRIPTION
    This script checks each specified computer for services that are
    not running (Stopped or Paused). Optionally restarts them and logs results.

.NOTES
    Author: SecureByAnna
    Updated: $(Get-Date -Format "yyyy-MM-dd")
#>

param(
    [string[]]$ComputerName = @("localhost"),
    [string]$OutputPath = ".\reports\stopped_services_report.csv",
    [switch]$RestartStopped
)

# Create folders if needed
$logPath = ".\logs"
if (-not (Test-Path $logPath)) { New-Item -ItemType Directory -Path $logPath }
if (-not (Test-Path ".\reports")) { New-Item -ItemType Directory -Path ".\reports" }

$logFile = Join-Path $logPath "service_monitor_log_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
$report = @()

foreach ($computer in $ComputerName) {
    Write-Verbose "Checking $computer..."

    try {
        $services = Get-Service -ComputerName $computer | Where-Object { $_.Status -ne 'Running' }

        foreach ($svc in $services) {
            $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

            $entry = [PSCustomObject]@{
                Timestamp     = $timestamp
                ComputerName  = $computer
                ServiceName   = $svc.Name
                DisplayName   = $svc.DisplayName
                Status        = $svc.Status
            }

            $report += $entry
            "$timestamp [$computer] $($svc.Name) - $($svc.Status)" | Out-File -Append -FilePath $logFile

            if ($RestartStopped -and $svc.Status -eq 'Stopped') {
                try {
                    Start-Service -Name $svc.Name -ComputerName $computer
                    "$timestamp [$computer] Restarted $($svc.Name)" | Out-File -Append -FilePath $logFile
                    Write-Host "Restarted: $($svc.Name) on $computer" -ForegroundColor Green
                } catch {
                    "$timestamp [$computer] Failed to restart $($svc.Name): $_" | Out-File -Append -FilePath $logFile
                    Write-Warning "Failed to restart $($svc.Name) on $computer: $_"
                }
            }
        }
    } catch {
        "$timestamp [$computer] ERROR: $_" | Out-File -Append -FilePath $logFile
        Write-Warning "Failed to query $computer: $_"
    }
}

# Export to CSV
$report | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8
Write-Host "`nStopped services report saved to $OutputPath" -ForegroundColor Cyan
Write-Host "Log file saved to $logFile" -ForegroundColor Cyan