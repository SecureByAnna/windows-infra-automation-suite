<#
.SYNOPSIS
    Audits scheduled tasks and exports the results to a CSV report.

.DESCRIPTION
    Collects all scheduled tasks from the local machine, showing name, status, triggers, and run times.
    Useful for auditing automated jobs or troubleshooting failed tasks.

.EXAMPLE
    .\scheduled_task_audit.ps1 -OutputPath "C:\Reports\tasks.csv"

.NOTES
    Author: SecureByAnna
#>

param (
    [string]$OutputPath = "Scheduled_Tasks_Report.csv"
)

Write-Host "Collecting scheduled tasks..." -ForegroundColor Cyan

$tasks = Get-ScheduledTask | ForEach-Object {
    $info = $_ | Get-ScheduledTaskInfo
    [PSCustomObject]@{
        TaskName       = $_.TaskName
        TaskPath       = $_.TaskPath
        State          = $_.State
        Enabled        = $_.Enabled
        LastRunTime    = $info.LastRunTime
        NextRunTime    = $info.NextRunTime
        LastTaskResult = $info.LastTaskResult
    }
}

$tasks | Export-Csv -Path $OutputPath -NoTypeInformation
Write-Host "Scheduled tasks exported to: $OutputPath" -ForegroundColor Green