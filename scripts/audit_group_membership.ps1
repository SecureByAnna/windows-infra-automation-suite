<#
.SYNOPSIS
    Exports Active Directory group memberships to a CSV report.

.DESCRIPTION
    This script pulls members of specified (or all) AD groups and exports
    them into a readable CSV file for auditing or reporting.

.NOTES
    Author: SecureByAnna
    Date: $(Get-Date -Format "yyyy-MM-dd")
#>

param(
    [string]$GroupName = "*",    # Wildcard by default (all groups)
    [string]$OutputPath = ".\group_membership_report.csv"
)

# Initialize output array
$report = @()

# Get Groups
try {
    $groups = Get-ADGroup -Filter { Name -like $GroupName }
}
catch {
    Write-Host "Failed to retrieve groups: $_" -ForegroundColor Red
    exit
}

# Process each group
foreach ($group in $groups) {
    try {
        $members = Get-ADGroupMember -Identity $group.DistinguishedName -Recursive
        foreach ($member in $members) {
            $report += [PSCustomObject]@{
                GroupName = $group.Name
                MemberName = $member.Name
                MemberSamAccountName = $member.SamAccountName
                MemberObjectClass = $member.objectClass
            }
        }
    }
    catch {
        Write-Host "Failed to retrieve members for group $($group.Name): $_" -ForegroundColor Yellow
    }
}

# Export report
$report | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8

Write-Host "`nGroup membership report saved to $OutputPath" -ForegroundColor Green